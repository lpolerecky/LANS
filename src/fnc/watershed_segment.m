function [segm_im nfig]=watershed_segment(bw, mass, be_verbose, size_threshold)
% watershed segmentation implements basic ideas found at
% http://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/ 
% but the final algorithm has been modified quite a lot.
% Thank you Steve!
% (c) Lubos Polerecky, 04-03-2017, Utrecht

nfig=[100 101];

fprintf(1,'Performing watershed segmentation of ROIs.\n');
if nargin>2
    verbose=be_verbose;
else
    verbose=1;
end;

if nargin>3
    size_thr=size_threshold;
else
    size_thr=20;
end;

[Ny,Nx]=size(bw);
[xb,yb]=meshgrid([1:Ny],[1:Nx]);

if 0
    BW1 = edge(mass,'canny',0.1);
    se = strel('line',5,0);
    BW2 = imclose(BW1,se);

    BW3 = zeros(size(BW1));
    ind = find(BW2==1);
    cp = ind(1);

    xcp = xb(cp);
    ycp = yb(cp);

    xsur = xcp+[1 0 -1 0];
    ysur = ycp+[0 -1 0 1];
    inside = find(xsur>=1 & xsur<=Nx & ysur>=1 & ysur<=Ny);
    xsur = xsur(inside);
    ysur = ysur(inside);
    v=zeros(size(xsur));
    for i=1:length(v)
        v(i)=BW2(ysur(i), xsur(i));
    end;
    if sum(v)>0
        BW2(ycp, xcp)=0;
        ind1=min(find(v==1));
        xcp = xsur(ind1);
        ycp = ysur(ind1);
    else
        xsur = xcp+[1 -1 -1 1];
        ysur = ycp+[-1 -1 1 1];
        inside = find(xsur>=1 & xsur<=Nx & ysur>=1 & ysur<=Ny);
        xsur = xsur(inside);
        ysur = ysur(inside);
        v=zeros(size(xsur));
        for i=1:length(v)
            v(i)=BW2(ysur(i), xsur(i));
        end;
        if sum(v)>0
            BW2(ycp, xcp)=0;
            ind1=min(find(v==1));
            xcp = xsur(ind1);
            ycp = ysur(ind1);
            BW3(ycp,xcp)=1;
        end;
    end;


    BW1=bwlabel(BW1,8);
    im2 = (max(mass(:)) - mass)/(max(mass(:)) - min(mass(:)));
    Ld = watershed(im2); 
    BW2 = bwlabel(Ld,4);
end;

if 0 & verbose
    figure;
    subplot(1,2,1);
    imagesc(BW1);
    subplot(1,2,2);
    imagesc(BW2);
    colormap(clut)
    %imshowpair(BW1,BW2,'montage');
end;

ind = find(bw>0);
bw(ind) = ones(size(ind));
bw_in = bw;
[Ny,Nx]=size(bw);
[xb,yb]=meshgrid([1:Ny],[1:Nx]);

% invert the input mass to calculate the watershed regions
% it is assumed that the input mass is well smoothed!
im2 = (max(mass(:)) - mass)/(max(mass(:)) - min(mass(:)));
Ld = watershed(im2); 

bw(Ld == 0) = 0;
%segm_im = bwlabel(bw,4);
segm_im = bwlabel(bw,8);
urois = setdiff(unique(segm_im(:)),0);

%boundaries = bwlabel(bw_in-bw,4);
boundaries = bwlabel(bw_in-bw,8);
uboundaries = setdiff(unique(boundaries(:)),0);

% LP: break-point here. debug for speed

% calculate centers of rois in the segmented image
fprintf(1,'- Calculating centers of segmented ROIs (N=%d)...', length(urois));
t1=now;
for ii=1:length(urois)
    ind = find(segm_im==urois(ii));
    xrois(ii)=mean(xb(ind));
    yrois(ii)=mean(yb(ind));
end;
t2=now;
fprintf(1,'done (in %.1fs)\n',(t2-t1)*24*3600);

% add pixels on the boundaries, which were removed by the watershed, to the
% closest ROIs; do this pixel by pixel because some boundaries can be
% pretty long and can touch several ROIs.
fprintf(1,'- Adding boundaries (N=%d) to the segmented ROIs...',length(uboundaries));
t1=now;
for ii=1:length(uboundaries)
    ind=find(boundaries==uboundaries(ii));
    for jj=1:length(ind)
        % find an interval around the current boundary pixel
        xinterval = xb(ind(jj))+[-1:1];
        yinterval = yb(ind(jj))+[-1:1];
        indx=find(xinterval>0 & xinterval<=Nx);
        indy=find(yinterval>0 & yinterval<=Ny);
        xinterval=xinterval(indx);
        yinterval=yinterval(indy);
        % find values in the segm_im image in this interval
        tmp = segm_im(yinterval, xinterval);
        % take only non-zero value
        tmp = tmp(find(tmp>0));
        % the most abundant element in tmp will be the roi number of that
        % pixel
        if ~isnan(mode(tmp))
            segm_im(yb(ind(jj)),xb(ind(jj)))=mode(tmp);
        end;            
    end;
end;
t2=now;
fprintf(1,'done (in %.1fs)\n',(t2-t1)*24*3600);

% repeat 3 times searching for small rois and merging them with larger rois
% that they touch.
segm_im_init = segm_im;
for jj=1:3
    
    if jj==1
        fprintf(1,'- Merging small rois touching larger ones.\n');
    end;
    
    % calculate center and size of the new rois
    urois = setdiff(unique(segm_im(:)),0);
    xrois=zeros(size(urois));
    yrois=zeros(size(urois));
    srois=zeros(size(urois));
    for ii=1:length(urois)
        ind = find(segm_im==urois(ii));
        xrois(ii)=mean(xb(ind));
        yrois(ii)=mean(yb(ind));
        srois(ii)=length(ind);
    end;

    % display some useful information
    if verbose
        if jj==1
            my_figure(nfig(1));
            subplot(1,2,1);
            imagesc(segm_im);
            colormap(clut(max(segm_im(:))+1));
            set(gca,'DataAspectRatio',[1 1 1]);
            title('ROIs after watershed segmentation','fontsize',10,'fontweight','normal');
            subplot(1,2,2);
            hist(srois,[0:5:max(srois)]);
            xlim([0 max(srois)]);
            title('Histogram of sizes of the segmented ROIs','fontsize',10,'fontweight','normal');
            xlabel('Size class');
            ylabel('Number of ROIs');
            set(nfig(1),'Position',[50 400 1000 400]);
            pause(0.5);

            % ask for the threshold size 
            answer = inputdlg(sprintf('Based on Fig %d, specify size below which touching ROIs should be merged.',nfig(1)),'Merging ROIs',1,{num2str(size_thr)});
            if isempty(answer)
                sthr = [];
            else
                sthr = str2num(answer{1});
            end;
            if isempty(sthr), sthr=size_thr; end;
        end;   
    else
        sthr = size_thr;
    end;

    if jj==1
        fprintf(1,'ROI is considered small when its size < %d.\n', sthr);    
    end;
    
    % loop over small rois and merge them with existing ones, if they are
    % touching    
    inds=find(srois<sthr);
    if length(inds)>0
        fprintf(1,'Number of small ROIs found: %d. Merging now ...\n',length(inds));
    end;
    more_touching = 0;
    t1=now;
    for ii=1:length(inds)
        
        ind = find(segm_im==urois(inds(ii)));
        tmp = zeros(size(bw));
        tmp(ind)=ones(size(ind));
        
        % enlarge the roi by one pixel around the original area
        shift_matrix = [1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1];
        tmp_bigger = tmp;
        for kk=1:size(shift_matrix,1)
            tmp2=shiftimg(tmp,shift_matrix(kk,1),shift_matrix(kk,2));
            tmp_bigger = tmp_bigger+tmp2;
        end;
        ind2=find(tmp_bigger>0);
        tmp_bigger(ind2)=ones(size(ind2));
        
        % determine pixels surrounding the roi
        tmp_bigger = tmp_bigger-tmp;
        
        % find values in the original roi image in these pixels        
        tmpval = segm_im(find(tmp_bigger>0));
        
        % remove zeros
        tmpval = tmpval(find(tmpval>0));
        
        % remember the most frequent value surrounding the original small
        % roi
        if ~isempty(tmpval), newval = mode(tmpval); else, newval=0; end;

        % find indices of the closest ROI
        closest = find(segm_im==newval);
        
        % use bwlabel to figure out whether the original small roi and the 
        % closest roi are touching
        tmp(closest)=ones(size(closest));
        bwtmp=bwlabel(tmp,8);
        if length(unique(bwtmp(:)))==2 & newval>0
            % this means that the ROIs are touching, so they should be merged
            ind3 = find(segm_im==newval);
            segm_im(ind)=newval*ones(size(ind));
            ind4 = find(segm_im==newval);
            if verbose
                fprintf(1,'%d/%d: %d(%d) + %d(%d) -> %d(%d)\n',ii, length(inds), ...
                    urois(inds(ii)), length(ind), newval, length(ind3), newval, length(ind4));
            end;
            more_touching=1;
        else
            if verbose
                fprintf(1,'%d/%d: WARNING: ROI %d has size=%d, which is <%d, but it is not touching any other ROI. Consider removing it manually.\n',ii, length(inds),urois(inds(ii)),srois(inds(ii)),sthr);
            end;
        end;
    end;
    t2=now;
    if length(inds)>0
        fprintf(1,'Merging of N=%d small ROIs with larger ones...',length(inds));
        fprintf(1,'done (in %.1fs)\n',(t2-t1)*24*3600);
    end;
    
    % this will effectively stop checking the ROIs if there are no more
    % touching ROIs
    if more_touching==0
        break;
    end;

end;

% sort the ROIs so that their centers increase from left to right
% first, calculate x-center of the new rois
fprintf(1,'Sorting merged ROIs ... ');
t1=now;
urois = setdiff(unique(segm_im(:)),0);
xrois=zeros(size(urois));
for ii=1:length(urois)
    ind = find(segm_im==urois(ii));
    xrois(ii)=mean(xb(ind));
end;
% sort it
[xs indx]=sort(xrois);
segm_new=zeros(size(segm_im));
k=0;
% rearrange rois according to this sorting
srois=zeros(size(urois));
for ii=1:length(urois)
    ind = find(segm_im==urois(indx(ii)));
    k=k+1;
    segm_new(ind)=k*ones(size(ind));
    srois(k) = length(ind);
end;
segm_im = segm_new;
t2=now;
fprintf(1,'done (in %.1fs)\n',(t2-t1)*24*3600);

fprintf(1,'Unique ROIs: %d\n',length(urois));
fprintf(1,'ROIs with size < %d that are not touching any other ROIs: ',sthr);
fprintf(1,'%d ',find(srois<sthr));
fprintf(1,'(N=%d)\n',length(find(srois<sthr)));

fprintf(1,'Watershed segmentation of ROIs done.\n');

if verbose
    my_figure(nfig(2));
    subplot(1,2,1);
    imagesc(segm_im);
    colormap(clut(max(segm_im(:))+1));
    set(gca,'DataAspectRatio',[1 1 1]);
    title('ROIs after watershed segmentation and merging','fontsize',10,'fontweight','normal');
    subplot(1,2,2);
    hist(srois,[0:5:max(srois)]);
    xlim([0 max(srois)]);
    title('Histogram of sizes of the segmented and merged ROIs','fontsize',10,'fontweight','normal');
    xlabel('Size class');
    ylabel('Number of ROIs');
    set(nfig(2),'Position',[50 400 1000 400]);
    pause(0.5);
end;