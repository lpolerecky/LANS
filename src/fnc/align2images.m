function [im1_out,rgb]=align2images(v1,v2,im1,im2)

N = size(v1,2);

global additional_settings;

a=inputdlg({'Auto-scaling options for both image (1=min/max, 0=quantiles)',...
    'Attempt background removal in the external image? (1=yes, 0=no)',...
    'Size of the smoothing window when removing background (in pixels)'},...
    'Enter external and nanosims overlay options',1,...
    {'1','0','200'});

if isempty(a)
    scale_as_minmax = 1;
    correct_for_bkghetero = 0;
    smoothing_window = 200;
else
    scale_as_minmax = str2num(a{1});
    correct_for_bkghetero = str2num(a{2});
    smoothing_window = str2num(a{3});
end;

% correct im1 for background heterogeneity, if requested
if correct_for_bkghetero
    for ii=1:size(im1,3)
        a = double(squeeze(im1(:,:,ii)));
        fprintf(1,'Correcting channel %d of the external image for background heterogeneity:\n ... ',ii);
        % periodically expand im1 to all sides
        am=[flipud(fliplr(a)) flipud(a) flipud(fliplr(a));...
            fliplr(a) a fliplr(a);...
            flipud(fliplr(a)) flipud(a) flipud(fliplr(a))];
        % smooth it
        fprintf(1,'- smoothing ... ');
        bm=wiener2(am,smoothing_window*[1 1]);
        % remove the smoothed image
        fprintf(1,'- subtracting background ... ');
        amc=am-bm;
        % extract the image in the original size
        s=size(im1);
        a=amc(s(1)+[1:s(1)],s(2)+[1:s(2)]);
        fprintf(1,'done\n');  
        im1(:,:,ii)=a;
    end;
end;

% normalize the input image im1
% for ii=1:size(im1,3)
%     a = double(squeeze(im1(:,:,ii)));        
%     sc = find_image_scale(a,0,scale_as_minmax);
%     if sc(2)>sc(1)
%         a = (a-sc(1))/(sc(2)-sc(1));
%         ind = find(a<0);
%         a(ind)=zeros(size(ind));
%         ind = find(a>1);
%         a(ind)=ones(size(ind));  
%     else
%         if size(im1,3)>1, zero_channel=ii; end;
%     end;    
%     im1(:,:,ii) = a*255;        
% end;

% stretch contrast of the input image im2
% a = im2;
% sc = find_image_scale(a,0,scale_as_minmax);
% if sc(2)>sc(1)
%     a = (a-sc(1))/(sc(2)-sc(1));
%     ind = find(a<0);
%     a(ind)=zeros(size(ind));
%     ind = find(a>1);
%     a(ind)=ones(size(ind));        
% end;
% im2 = a*255;

% find the actual alignment
xybase1 = v1';
xybase2 = v2';
t_proj = cp2tform(xybase1, xybase2, 'projective');
[I_proj,xdata,ydata] = imtransform(im1,t_proj,'FillValues',.3,'XYScale',1);
xrange = linspace(xdata(1),xdata(2),size(I_proj,2));
yrange = linspace(ydata(1),ydata(2),size(I_proj,1));
xind = find(xrange>0 & xrange<=size(im2,2));
yind = find(yrange>0 & yrange<=size(im2,1));

im1_out = zeros(size(im2,1),size(im2,2),size(im1,3));
im1_out(1:length(yind),1:length(xind),1:size(I_proj,3)) = ...
    I_proj(yind,xind,1:size(I_proj,3));

% generate the output images
if size(im1_out,3)>1
    % substitute the darkest channel in the external image with the
    % nanosims image
    r=im1_out(:,:,1);
    g=im1_out(:,:,2);
    b=im1_out(:,:,3);
    q95r=quantile(r(:),additional_settings.autoscale_quantiles(2));
    q95g=quantile(g(:),additional_settings.autoscale_quantiles(2));
    q95b=quantile(b(:),additional_settings.autoscale_quantiles(2));
    [mm,indm]=min([q95r, q95g, q95b]);
    rgb = im1_out;
    rgb(1:size(im2,1),1:size(im2,2),indm)=im2;
    tit=['channel ',num2str(indm),'=external'];
else
    % set the nanosims image as the green channel and the external image as
    % the red channel of the aligned composite image
    rgb(1:size(im2,1),1:size(im2,2),1) = im1_out;
    rgb(:,:,2) = im2;
    rgb(:,:,3) = zeros(size(im2));
    tit='red=external; green=nanosims';
end;

% make sure that the values in the rgb image are between 0 and 255 before
% displaying it
for ii=1:size(rgb,3)
    a = double(squeeze(rgb(:,:,ii)));        
    sc = find_image_scale(a,0,scale_as_minmax);
    if sc(2)>sc(1)
        a = (a-sc(1))/(sc(2)-sc(1));
        ind = find(a<0);
        a(ind)=zeros(size(ind));
        ind = find(a>1);
        a(ind)=ones(size(ind));  
%     else
%         if size(im1,3)>1, zero_channel=ii; end;
    end;    
    rgb(:,:,ii) = a*255;
end;
rgb = uint8(rgb);

figure(100);
image(rgb);
title(tit,'fontweight','normal');
set(gca, 'dataaspectratio',[1 1 1]);
