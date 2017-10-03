function rois=supervise_classify(handles)
% perform supervised classification of pixels, based on ROIs and classes
% defined by the user
% (c) Lubos Polerecky, 18-02-2017, Soesterberg


[Xvalues, Xrois, Xclasses, Xsize, unique_classes, labels] = load_X(1,1);
Xvalues = transform_values(Xvalues);

%Cprob = calculate_probability_for_pixels(Xvalues, Xclasses);
load cprob.mat

[probimage, classimage1] = convert_prob_class_arrays_to_images(Cprob,Xsize);

[probimage, classimage2] = revise_classification_NaN_pixels(probimage, classimage1);

[probimage, classimage3] = classify_small_rois_as_nan(probimage, classimage2, 2);

[probimage2, classimage4] = revise_classification_NaN_pixels(probimage, classimage3);

[rois classes] = generate_new_rois_classes(classimage4, unique_classes);

Maskimg=rois;
save('/home/lubos/expdata/selina/S16107_Selina_46_1/cells_sc.mat','Maskimg');
fid=fopen('/home/lubos/expdata/selina/S16107_Selina_46_1/cells_sc.dat','w');
for ii=1:length(classes)
    fprintf(fid,'%d\t%c\n',ii,classes(ii));
end;
fclose(fid);

if 0
figure(1); hold off; imagesc(classimage1); set(gca,'dataaspectratio',[1 1 1])
figure(2); hold off; imagesc(classimage2); set(gca,'dataaspectratio',[1 1 1])
figure(3); hold off; imagesc(classimage3); set(gca,'dataaspectratio',[1 1 1])
figure(4); hold off; imagesc(classimage4); set(gca,'dataaspectratio',[1 1 1])
end;

tmp_display(reshape(Xrois,Xsize),reshape(Xclasses,Xsize),classimage4,rois);

end

function [rois classes] = generate_new_rois_classes(classimage, unique_classes)

u_classes = unique(classimage(:));
u_classes = u_classes(find(~isnan(u_classes)));

rois = zeros(size(classimage));
maxv=max(rois(:));
for ii=1:length(u_classes)
    class=u_classes(ii);
    ind=find(classimage==class);
    a=zeros(size(classimage));
    a(ind)=ones(size(ind));
    b = bwlabel(a,8);
    ub = setdiff(unique(b),0);
    ind=find(b>0);
    rois(ind) = b(ind)+maxv;
    classes(ub+maxv)=unique_classes(ii);
    maxv = max(rois(:));
end;

% figure(30);
% imagesc(a);
% figure(31);
% imagesc(b);
% figure(32);
% imagesc(rois);

end

function [probimage, classimage] = classify_small_rois_as_nan(probimage,classimage,mins)
% set probability in all contiguous areas with size<=mins to NaN

u_classes = unique(classimage(:));
u_classes = u_classes(find(~isnan(u_classes)));
Xsize = size(classimage);
for ii=1:length(u_classes)
    class=u_classes(ii);
    a=zeros(Xsize);
    ind=find(classimage==class);
    a(ind)=class*ones(size(ind));
    b=bwlabel(a,4);
    ub = setdiff(unique(b(:)),0);
    for jj=1:length(ub)
        ind = find(b==ub(jj));
        if length(ind)<=mins
            probimage(ind)=NaN*ones(size(ind));
        end;
    end;
end;

end

function [probimage, classimage] = convert_prob_class_arrays_to_images(Cprob,Xsize)

% normalize the classification probability matrix so that the sum of
% probabilities for each pixel is 1
sumCprob = sum(Cprob,2)*ones(1,size(Cprob,2));
C = Cprob./sumCprob;

% classify pixels: class of a pixel is defined as the class where the
% probability derived from the akde algorithm is maximal.
[C1, C2]=max(C,[],2);

% reshape the output to images
classimage = reshape(C2,Xsize);
probimage = reshape(C1,Xsize);

end

function [probimage2, classimage2] = revise_classification_NaN_pixels(probimage, classimage)
% classify pixels with probability=NaN, which are pixels whose data were in
% some way incomplete 

u_classes = unique(classimage(:));
u_classes = u_classes(find(~isnan(u_classes)));
Xsize = size(classimage);
probimage2=probimage;
classimage2=classimage;

ind = find(isnan(probimage));
for ii=1:length(ind)
    % find indices of pixels surrounding the current pixel
    x=ceil(ind(ii)/Xsize(1));
    y=rem(ind(ii),Xsize(1));
    if y==0, y=Xsize(1); end;
    xint=x+[-1 0 1];
    yint=y+[-1 0 1];
    jj=find(xint>=1 & xint<=Xsize(2));
    xint = xint(jj);
    jj=find(yint>=1 & yint<=Xsize(1));
    yint = yint(jj);
    % get probabilities and classes in pixels surrounding the pixel ind(ii)
    psur = probimage(yint,xint);
    csur = classimage(yint,xint);
    % remove NaN's
    jj=find(~isnan(psur));
    if ~isempty(jj)
        c=csur(jj);
        p=psur(jj);
        % find the most frequent class for pixels surrounding the given pixel
        nelem=hist(c,u_classes);
        jj=find(nelem==max(nelem));
        % if more than one class had highest abundance, choose the class with
        % the higher mean probability
        if length(jj)>1
            prob=[];
            for kk=1:length(jj)
                k1=find(c==jj(kk));
                prob(kk)=mean(p(k1));
            end;
            kk=find(prob==max(prob));
            jj=jj(kk);
        end;
        %fprintf(1,'%d\t%d\n',ii,jj);
        if length(jj)~=length(x)
            aa=0;
        end;
        classimage2(y,x)=jj(1);
        %probimage2(y,x)=0;
    else
        classimage2(y,x)=NaN;
        probimage2(y,x)=NaN;
    end;
end;

end

function Cprob=calculate_probability_for_pixels(Xvalues, Xclasses)

% these variables from the input matrix should be taken for classification
coord=1:3; 
% number of grid points
ng = 100; 
% dimension of the space where pdf will be calculated (should be 3)
d=length(coord);

% find all unique classes
ind = find(~isnan(Xclasses));
all_classes = unique(Xclasses(ind));

% extract X values for all pixels
Zall = Xvalues(:,coord);

% define grid where the pdf function will be evaluated by akde. important:
% this grid will be the same for each class, so that the pdf values
% evaluated on this grid will be comparable among the classes. the grid
% should cover the complete range of the entire dataset.
minz = min(Zall,[],1);
maxz = max(Zall,[],1);
scaling=maxz-minz;
dz = scaling/(ng-1);
% create grid where the akde will be evaluated
if d==3
    [X1,X2,X3]=meshgrid(minz(1):dz(1):maxz(1), minz(2):dz(2):maxz(2), minz(3):dz(3):maxz(3));
    grid=reshape([X1(:),X2(:),X3(:)],ng^d,d);
elseif d==2
    [X1,X2]=meshgrid(minz(1):dz(1):maxz(1), minz(2):dz(2):maxz(2));
    grid=reshape([X1(:),X2(:)],ng^d,d);
end;

% round the Zall data to indices of the grid
dzmatrix = ones(size(Zall,1),1)*dz;
Zall_rounded = round(Zall./dzmatrix);
minz_rounded = ones(size(Zall_rounded,1),1)*min(Zall_rounded);
Zall_ind = Zall_rounded - minz_rounded + 1;
if d==2
    figure(32); 
    hold off; 
    plot(Zall_ind(:,1),Zall_ind(:,2),'g.'); 
    set(gca,'dataaspectratio',[1 1 1])
elseif d==3
    figure(32); 
    hold off; 
    plot3(Zall_ind(:,1),Zall_ind(:,2),Zall_ind(:,3),'g.'); 
    set(gca,'dataaspectratio',[1 1 1])
end;
    
for kk=1:length(all_classes)
    class = all_classes(kk);
    
    % extract X values for a given class and for all pixels
    ind = find(Xclasses==class);
    Z = Xvalues(ind,coord);    
    
    if 0
    % calculate mean and std of X values in the given class so that we can
    % z-score the X values for all pixels
    [meanX stdX] = my_meanstd(X);
    meanXmatrix = ones(size(X,1),1)*meanX;
    stdXmatrix = ones(size(X,1),1)*stdX;
    
    % make a z-score of X
    Y = (X-meanXmatrix)./stdXmatrix;
    
    % calculate the PCA coefficients so that we can transform the complete
    % dataset to the system of co-ordinates given by principal components
    [coeff, Z] = princomp(Y);
    % transform the complete dataset
    meanXmatrix = ones(size(Xall,1),1)*meanX;
    stdXmatrix = ones(size(Xall,1),1)*stdX;
    Yall = (Xall-meanXmatrix)./stdXmatrix;
    Zall=(inv(coeff)*Yall')';
    
    % display (in 2D) to check
    figure(28); hold off; plot(X(:,1),X(:,2),'ro'); hold on; plot(Xall(:,1),Xall(:,2),'b.'); set(gca,'dataaspectratio',[1 1 1])
    figure(29); hold off; plot(Y(:,1),Y(:,2),'ro'); hold on; plot(Yall(:,1),Yall(:,2),'b.'); set(gca,'dataaspectratio',[1 1 1])
    end;
    
    figure(30); hold off; 
    if d==3
        plot3(Z(:,1),Z(:,2),Z(:,3),'ro'); 
        hold on; 
        %plot3(Zall(:,1),Zall(:,2),Zall(:,3),'b.'); 
    elseif d==2
        plot(Z(:,1),Z(:,2),'ro'); 
        hold on; 
        plot(Zall(:,1),Zall(:,2),'b.'); 
    end;
    set(gca,'dataaspectratio',[1 1 1])
    %figure(31); hold off; plot(Z2(:,1),Z2(:,2),'.');set(gca,'dataaspectratio',[1 1 1])
    
    
    
    % make sure Z does not contain NaN's
    Znum = Z(find(sum(isnan(Z),2)==0),:);    

    % run adaptive kde, as implemented by Botev et al.
    pdf=akde(Znum,grid); 
    % reshape pdf for use with meshgrid
    pdf=reshape(pdf,size(X1)); 
    % make sure that integral of pdf over the grid is 1!
    if d==2
        x=X1(1,:);
        y=X2(:,1);
        p1 = trapz(x,pdf,2);
        p = trapz(y,p1);
    elseif d==3
        x=squeeze(X1(1,:,1));
        y=squeeze(X2(:,1,1));
        z=squeeze(X3(1,1,:));
        p1 = trapz(x,pdf,2);
        p2 = trapz(z,p1,3);
        p = trapz(y,p2);
    end;
    
    if d==2
        figure(31);
        mesh(X1,X2,pdf);
    elseif d==3
        for iso=[0.005:0.005:0.015] % isosurfaces with pdf = 0.005,0.01,0.015
            isosurface(X1,X2,X3,pdf,iso),view(3),alpha(.3),box on,hold on
            colormap cool
        end
    end;

    %p
    
    % calculate probability that a pixel belongs to the current class based 
    % on the pdf values, do this only for pixels whose values are not NaN
    ind = find(sum(isnan(Zall_ind),2)==0);
    Zprob = NaN*ones(size(Zall_ind,1),1);
    % Zprob(ind) = pdf(Zall_ind(ind,1), Zall_ind(ind,2));
    for ii=1:length(ind)
        if d==3
            Zprob(ind(ii)) = pdf(Zall_ind(ind(ii),2), Zall_ind(ind(ii),1), Zall_ind(ind(ii),3));
        elseif d==2
            Zprob(ind(ii)) = pdf(Zall_ind(ind(ii),2), Zall_ind(ind(ii),1));
        end;
    end;
    Cprob(:,class) = Zprob;
end;

end

function [meanX stdX] = my_meanstd(X)

for ii=1:size(X,2)
    xtmp = X(:,ii);
    ind = find(~isnan(xtmp));
    meanX(1,ii) = mean(xtmp(ind));
    stdX(1,ii) = std(xtmp(ind));
end;

end

function tmp_display(im1,im2,im3,im4)

figure(27);
subplot(2,2,1);
imagesc(im1); set(gca,'dataaspectratio',[1 1 1])
title('original ROIs');
subplot(2,2,2);
imagesc(im2); set(gca,'dataaspectratio',[1 1 1])
title('classified ROIs');
subplot(2,2,3);
imagesc(im3); set(gca,'dataaspectratio',[1 1 1])
title('after akde-based classification');
subplot(2,2,4);
imagesc(im4); set(gca,'dataaspectratio',[1 1 1])
title('after revised classification');

end

function [X, Xrois, Xclasses, Xsize, cidu, labs] = load_X(a,b)

% cname{1} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-12C.mat';
% cname{2} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-12C14N.mat';
% cname{3} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-31P.mat';
% cname{4} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-16O.mat';
% cname{5} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-27Al.mat';
% cname{6} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-32S.mat';
% cname{7} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-56Fe.mat';

switch a,
    case 1,
        cname = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells1.mat';
        clname = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells1.dat';
    case 2,
        cname = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells2.mat';
        clname = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells2.dat';
end;

%cname{1} = '/home/lubos/expdata/selina/S16107_Selina_46_1/cells-grid64.mat';

% mname{1} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/12C-plane-pixel.mat';
% mname{2} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/12C14N-plane-pixel.mat';
% mname{3} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/31P16O2-plane-pixel.mat';
% mname{4} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/16O-plane-pixel.mat';
% mname{5} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/27Al16O-plane-pixel.mat';
% mname{6} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/32S-plane-pixel.mat';
% mname{7} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/56Fe16O-plane-pixel.mat';

switch b,
    case 1, 
        mname{1} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/31P16O2-12C.mat';
        mname{2} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/32S-12C.mat';
        mname{3} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/12C14N-32S.mat';
    case 2,
        mname{1} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/32S-16O.mat';
        mname{2} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/27Al16O-16O.mat';
        mname{3} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/56Fe16O-16O.mat';
    case 3,
        mname{1} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/31P16O2.mat';
        mname{2} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/32S.mat';
        mname{3} = '/home/lubos/expdata/selina/S16107_Selina_46_1/mat/12C14N.mat';
end;

fprintf(1,'Loading input data...');
Nr=length(mname);
jj=0;
for ii=1:Nr
    if exist(mname{ii})
        jj=jj+1;
        a = load(mname{ii});
        Xsize=size(a.IM);
        X(:,jj) = a.IM(:);
        [fdir fname ext]=fileparts(mname{ii});
        labs{jj}=fname;
    else
        fprintf(1,'*** WARNING: File %s does not exist. Ignoring.\n',mname{ii});
        X=[];
        labs=[];
        Xsize=[];
    end;
end;
fprintf(1,'done.\n');

fprintf(1,'Loading ROIs and ROI classes...');
if exist(cname)
    mi = load(cname);
    Xrois = mi.Maskimg(:);
else
    fprintf(1,'*** WARNING: File %s does not exist. Ignoring.\n',cname);
    Xrois = [];
end;

if exist(clname)
    [cidu,cc,cid,cnum,ss]=load_cell_classes(clname);
else
    fprintf(1,'*** WARNING: File %s does not exist. Ignoring.\n',clname);
    cidu = [];
end;
fprintf(1,'done.\n');

% set class value for each pixel according to the definition and
% classification of ROIs, or to NaN if it is not defined
if ~isempty(cidu) & ~isempty(Xrois)
    Xclasses = nan * ones(size(Xrois));
    Ncl=length(cidu);
    for ii=1:Ncl
        ind = find(cid==cidu(ii));
        indc = [];
        for jj=1:length(ind)
            indc = [indc; find(Xrois==ind(jj))];
        end;
        Xclasses(indc) = ii;
    end;
else
    Xclasses = [];
end;

end

function Xout = transform_values(Xin,thr)

if nargin>1
    thrv=thr;
else
    thrv=0;
end;
Xout=nan*ones(size(Xin));
ind=find(Xin>thrv);
Xout(ind) = log10(Xin(ind));
fprintf(1,'Values log10-transformed.\n');

end

function other_stuff
if 0
    xyz=[];
    for jj=1:Nr
        tmp = squeeze(r(:,:,jj));
        xyz(:,jj) = tmp(indc);
    end;
    c = [c; cidu(ii)*ones(length(indc),1)];
    X = [X; xyz];
end;

X = log10(X);

% remove Inf
ind = find(sum(isinf(X),2)==0);
X=X(ind,:);
c=c(ind);

%[coeff, Y, latent, tsquared, explained, mu]=pca(X);

%figure(3);
%scatter3(Y(:,1),Y(:,2),Y(:,3),10,c)

col='rgbmckrgbmckrgbmckrgbmck';
sym='......oooooo++++++vvvvvv';

figure;
uc = unique(c);
for ii=1:length(uc)
    ind = find(c==uc(ii));
    if ii==1
        hold off;
    else
        hold on;
    end;
    plot3(X(ind,1),X(ind,2),X(ind,3),[col(ii) sym(ii)]);
end;
legend(char(uc));
xlabel(labs{1});
ylabel(labs{2});
zlabel(labs{3});
xl=xlim;
yl=ylim;
zl=zlim;
dlim=max([diff(xl), diff(yl), diff(zl)]);
xlim(xl(1)+[0 dlim]);
ylim(yl(1)+[0 dlim]);
zlim(zl(1)+[0 dlim]);
set(gca,'dataaspectratio',[1 1 1],'xtick',[],'ytick',[]);
set(gca,'xtick',[min(xlim):max(xlim)],'ytick',[min(ylim):max(ylim)],'ztick',[min(zlim):max(zlim)])

% classify pixels in a trial area
if 0
    indx = [1:50];
    indy = [50:100];
else
    indx = [1:size(r,2)];
    indy = [1:size(r,1)];
end;

rc = []; 
for ii=1:size(r,3)
    rc(:,:,ii) = r(indy,indx,ii);
end;
cc = zeros(size(rc,1),size(rc,2));
Nx=size(X,1);
fprintf(1,'Classifying pixels ... ')
for ii=1:size(rc,1)
    fprintf(1,'%d/%d\n',ii,size(rc,1));
    for jj=1:size(rc,2)
        %fprintf(1,'%d %d\n',ii,jj);
        Xpixel = log10(squeeze(rc(ii,jj,:)))';
        if sum(isinf(Xpixel))<=1
            ind = find(~isinf(Xpixel));
            dX = ones(Nx,1)*Xpixel(ind) - X(:,ind);
            dist = sqrt(sum(dX.^2,2));
            [mindist,inddist] = sort(dist);
            classind = median(c(inddist(1:20)));
            ind = find(double(cid)==classind);
            if ~isempty(ind)
                cc(ii,jj) = min(ind);
            end;        
        end;
    end;    
end;
fprintf(1,'done.\n');
         
figure; imagesc(cc); colormap(clut(max(cc(:))+1)); 
set(gca,'dataaspectratio',[1 1 1],'xtick',[],'ytick',[]);

rois = 0;

if 0
%ind=[4 5 7];
ind=[1 2 3];
%ind = [1 2 3 4 5 6 7];

maxc = 6;
min_roi_size = 5;
if length(cname)>1
    cname = {cname{ind}};
end;
mname = {mname{ind}};

Nc=length(cname);

fprintf(1,'Loading ROI images...');
for ii=1:Nc
    mi = load(cname{ii});
    mi = mi.Maskimg;
%     ind = find(mi>0);
%     mi(ind)=ones(size(ind));
    if ii==1
        a = zeros(size(mi,1),size(mi,2),Nc);
    end;
    a(:,:,ii) = mi;
end;
fprintf(1,'done.\n');

fprintf(1,'Determining ROIs...');
b=sum(a,3);
ub = setdiff(unique(b(:)), 0);

rois = zeros(size(b));
for ii=1:length(ub)
    ind = find(b==ub(ii));
    tmp = zeros(size(b));
    tmp(ind) = ones(size(ind));
    L = bwlabel(tmp,4);
    %L = remove_small_rois(L,min_roi_size);
    minv = max(rois(:));
    ind = find(L>0);
    rois(ind) = rois(ind) + L(ind) + minv;
end;
%rois=rearrange_sort_cells(rois);
fprintf(1,'done.\n');

figure(10);
imagesc(rois); colorbar; colormap(clut(length(unique(rois(:)))));


Nm=length(mname);

fprintf(1,'Loading ratios...');
mi=[];
for ii=1:Nm
    a = load(mname{ii});
    mi(:,:,ii) = a.IM;
end;
fprintf(1,'done.\n');

fprintf(1,'Calcuating mean ratios in ROIs...');
Nr = length(setdiff(unique(rois(:)),0));
v = zeros(Nr,Nm);
for ii=1:Nr
    ind = find(rois==ii);
    for jj=1:Nm
        tmp = squeeze(mi(:,:,jj));
        v(ii,jj) = mean(tmp(ind));
    end;
end;
fprintf(1,'done.\n');

%X=zscore(log10(v(:,:)));
X=(log10(v(:,:)));
Z = linkage(X,'average','euclidean');
c = cluster(Z,'maxclust',maxc);
% figure;
% dendrogram(Z,0);
figure;
scatter3(X(:,1),X(:,2),X(:,3),10,c)

roisc=zeros(size(rois));
for ii=1:length(setdiff(unique(rois(:)),0))
    ind = find(rois==ii);
    roisc(ind)=c(ii);
end;
figure
imagesc(roisc);

end;
end
