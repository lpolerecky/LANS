function rois=supervise_classify(handles)
% perform supervised classification of pixels, based on ROIs and classes
% defined by the user
% (c) Lubos Polerecky, 18-02-2017, Soesterberg

if isfield(handles,'p')
    
    fprintf(1,'You are going to classify all pixels. Make sure that ROIs and ROI classes are correctly defined.\n');
    a=input('Are you sure you want to continue? (1=yes, 0=no) ');
    
    if a
        
        % select file with the defined ROIs
        % ROIs in this file will be used to calculate the pdf functions in 3D
        % for automated pixel classification
        [Xrois, cellname, mf] = load_cells_from_disk(handles,1);
        Xsize = size(Xrois);
       
        % select file with the defined ROI classes
        % ROI classes will be used to calculate the pdf functions in 3D
        % for automated pixel classification
        cf = select_classification_file(handles.p);

        % load the classes defined by the user
        [unique_classes,cc,cid,cnum,ss]=load_cell_classes(cf);
        
        % calculate the mask image, the ROI definition template should be
        % set to rgb2, and the R, G and B channels should be *all* filed
        % with some ratio values
        [maskmass,maskimg,mass,ps,bw,rgb_true,labs] = display_raw_mask_image(handles,0,cellname);

        % convert the rgb_true matrix, which should be a 3D array, to a 2D
        % array. this will speed up the further processing
        for ii=1:size(rgb_true,3)
            a=rgb_true(:,:,ii);
            Xvalues(:,ii)=a(:);
        end;

        % set class value for each pixel according to the definition and
        % classification of ROIs, or to NaN if it is not defined
        if ~isempty(unique_classes) & ~isempty(Xrois)
            Xclasses = nan * ones(size(Xrois));
            Ncl=length(unique_classes);
            for ii=1:Ncl
                ind = find(cid==unique_classes(ii));
                indc = [];
                for jj=1:length(ind)
                    indc = [indc; find(Xrois==ind(jj))];
                end;
                Xclasses(indc) = ii;
            end;
        else
            Xclasses = [];
        end;
        
        if ~isempty(Xclasses)
            
            Cprob = calculate_probability_for_pixels(Xvalues, Xclasses, unique_classes, labs);
            [probimage, classimage1] = convert_prob_class_arrays_to_images(Cprob,Xsize); 
            [probimage, classimage2] = revise_classification_NaN_pixels(probimage, classimage1);
            [probimage, classimage3] = classify_small_rois_as_nan(probimage, classimage2, 2);
            [probimage2, classimage4] = revise_classification_NaN_pixels(probimage, classimage3);
            [Maskimg classes] = generate_new_rois_classes(classimage4, unique_classes);
            % save results of the classificiation in a new file
            [fdir fname ext]=fileparts(mf);
            mout=[fdir filesep fname '_sc' ext];
            save(mout,'Maskimg');
            [fdir fname ext]=fileparts(cf);            
            cout=[fdir filesep fname '_sc' ext];        
            fid=fopen(cout,'w');
            for ii=1:length(classes)
                fprintf(fid,'%d\t%c\n',ii,classes(ii));
            end;
            fclose(fid);
            
            f110=figure(110);
            subplot(1,2,1);
            ind=find(isnan(Xclasses));
            Xclasses(ind)=zeros(size(ind));
            imagesc(Xclasses,[0 max(Xclasses(:))]);
            set(gca,'DataAspectRatio',[1 1 1]);
            title('Map of original classes');
            cb=colorbar;
            set(cb,'YLim',[0 max(Xclasses(:))]);
            set(cb,'Ytick',linspace(0,max(Xclasses(:)),max(Xclasses(:))+2)+0.5);
            lab=['0'; unique_classes(:)];
            set(cb,'YTickLabel',lab);
            
            subplot(1,2,2);
            imagesc(classimage4,[0 max(Xclasses(:))]); 
            set(gca,'DataAspectRatio',[1 1 1]);
            title('Map of automatically classified pixels');
            colormap(clut(max(Xclasses(:))+1));
            cb=colorbar;
            set(cb,'YLim',[0 max(Xclasses(:))]);
            set(cb,'Ytick',linspace(0,max(Xclasses(:)),max(Xclasses(:))+2)+0.5);
            lab=['0'; unique_classes(:)];
            set(cb,'YTickLabel',lab);
            
            fout=[fdir filesep fname '_sc.png']; 
            print(f110,fout,'-dpng');
            
            fprintf(1,'Results of supervised pixel auto-classification saved in:\n%s\n%s\n%s\n',mout,cout,fout);            
            
        else
            fprintf(1,'*** Error in class definition. Please revise it.\n');
        end;        
        
    end;
    
else
    
    fprintf(1,'*** WARNING: Nothing loaded, nothing done.\n');

end;

end

function first_attempt(a)
% not used

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

function Cprob=calculate_probability_for_pixels(Xvalues, Xclasses, unique_classes, legs, cc)

if nargin>4
    coord=cc;
else
    % these variables from the input matrix should be taken for classification
    coord=1:3; 
end;

% number of grid points
ng = 100; 

% dimension of the space where pdf will be calculated (debugged for 3)
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

if 0
    figure(100); 
    hold off;
    if d==2
        plot(Zall_ind(:,1),Zall_ind(:,2),'k.'); 
    elseif d==3
        plot3(Zall_ind(:,1),Zall_ind(:,2),Zall_ind(:,3),'k.'); 
    end;
    set(gca,'dataaspectratio',[1 1 1])
end;

% find pdf for each class
for kk=1:length(all_classes)
    
    class = all_classes(kk);
    
    % extract X values for a given class and for all pixels
    ind = find(Xclasses==class);
    Z = Xvalues(ind,coord);
    
    if 1
        figure(101); hold off; 
        if d==3
            plot3(Z(:,1),Z(:,2),Z(:,3),'k.'); 
        elseif d==2
            plot(Z(:,1),Z(:,2),'k.'); 
        end;
        set(gca,'dataaspectratio',[1 1 1])  
    end;
    
    % make sure Z does not contain NaN's
    Znum = Z(find(sum(isnan(Z),2)==0),:);    

    % run adaptive kde, as implemented by Botev et al.
    pdf=akde(Znum,grid); 
    % reshape pdf for use with meshgrid
    pdf=reshape(pdf,size(X1)); 

    if 1
        figure(101); hold on;
        if d==2
            contour(X1,X2,pdf,20);
        elseif d==3
            mpdf = max(pdf(:));
            for iso=[mpdf/20:mpdf/5:mpdf]
                isosurface(X1,X2,X3,pdf,iso), view(3);alpha(.3);                
            end            
            box on;
            colormap cool;            
        end;
        title(['Pixels in class ',unique_classes(kk)]);
        xlabel(legs{1});
        ylabel(legs{2});
        zlabel(legs{3});        
        pause(0.5);
    end;
    
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
% not used

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
% not used
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

