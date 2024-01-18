%function [im1_out,im2_xyscale,rgb,f101]=align2images(v1,v2,im1,im2,im1_xyscale,im2_xyscale,log_flag1,log_flag2)
function [im1_out,im2_xyscale,f101]=align2images(v1,v2,im1,im2,im1_vscale,im2_vscale,...
    im1_xyscale,im2_xyscale,log_flag1,log_flag2,symb_col)

N = size(v1,2);

global additional_settings;

% skip this
if 0
    a=inputdlg({'Auto-scaling options for both image (1=min/max, 0=quantiles)',...
        'Attempt background removal in the external image? (1=yes, 0=no)',...
        'Size of the smoothing window when removing background (in pixels)'},...
        'Enter external and nanosims overlay options',1,...
        {'1','0','200'});
end

a=[];

if isempty(a)
    scale_as_minmax = 1;
    correct_for_bkghetero = 0;
    smoothing_window = 200;
else
    scale_as_minmax = str2num(a{1});
    correct_for_bkghetero = str2num(a{2});
    smoothing_window = str2num(a{3});
end

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
    end
end

% find the actual alignment
xybase1 = v1';
xybase2 = v2';
    
% implementation uses new functions from the image processing toolbox
% changed: 18-05-2018
t_proj = fitgeotrans(xybase1, xybase2, 'projective');
% autoscale image based on quantiles defined in 
% main_GUI:Preferences->Additional Output Options
%sc1 = find_image_scale(im1(im1>0),0,additional_settings.autoscale_quantiles, log_flag1,0);
% autoscale image based on min/max values
% sc1 = find_image_scale(im1(im1>0),1,additional_settings.autoscale_quantiles, log_flag1,0);
sc1 = im1_vscale;

% warp the image, using the maximum as the FillValues (usually maximum is
% white in the BW images, which is a reasonable choice)
%im1_out = imwarp(im1,t_proj,'OutputView',imref2d(size(im2)), 'FillValues',sc1(2));

% warp the image, using the minimum as the FillValues (usually minimum is
% black in the BW images, which is a reasonable choice)
im1_out = imwarp(im1,t_proj,'OutputView',imref2d(size(im2)), 'FillValues',sc1(1));

%im1_out = imwarp(im1,t_proj,'OutputView',imref2d(size(im2)), 'FillValues',min(im1(:)));

% visualize the transformation on a checkerboard image
if 0
    x1=xybase1(:,1);
    y1=xybase1(:,2);
    x2=xybase2(:,1);
    y2=xybase2(:,2);
    mx1y1 = [mean(x1) mean(y1)];
    mx2y2 = [mean(x2) mean(y2)];
    x1=x1-mx1y1(1);
    y1=y1-mx1y1(2);
    x2=x2-mx2y2(1);
    y2=y2-mx2y2(2);
    s1=size(im1);
    I = checkerboard(ceil(max(s1)/10),5);
    I = I(1:s1(1),1:s1(2));
    % see help for fitgeotrans
    Iw = imwarp(I,t_proj,'OutputView',imref2d(size(im2)));
    u = [0 1]; v = [0 0]; 
    [x, y] = transformPointsForward(t_proj, u, v); 
    dx = x(2) - x(1); dy = y(2) - y(1); 
    angle = (180/pi) * atan2(dy, dx);
    scale = 1 / sqrt(dx^2 + dy^2);
    fig201=figure(201);
    subplot(1,3,1);
    hold off;
    plot(x1,y1,'ro');
    hold on;
    plot(x2,y2,'go');
    xlabel('x-mean(x)')
    ylabel('y-mean(y)');
    title('Point pairs','fontweight','normal');
    set(gca,'ydir','reverse')
    legend({'external','nanosims'});
    subplot(1,3,2);
    imagesc(I);
    title('Original','fontweight','normal')
    set(gca,'dataaspectratio',[1 1 1]);
    subplot(1,3,3);
    imagesc(Iw);
    title(sprintf('Warped (a=%.2f def, mag=%.3f)',angle,scale),'fontweight','normal');
    set(gca,'dataaspectratio',[1 1 1]);
    colormap(gray);fig201=figure(201);
    subplot(1,3,1);
    hold off;
    plot(x1,y1,'ro');
    hold on;
    plot(x2,y2,'go');
    xlabel('x-mean(x)')
    ylabel('y-mean(y)');
    title('Point pairs','fontweight','normal');
    set(gca,'ydir','reverse')
    legend({'external','nanosims'});
    subplot(1,3,2);
    imagesc(I);
    title('Original','fontweight','normal')
    set(gca,'dataaspectratio',[1 1 1]);
    subplot(1,3,3);
    imagesc(Iw);
    title(sprintf('Warped (a=%.2f deg, mag=%.3f)',angle,scale),'fontweight','normal');
    set(gca,'dataaspectratio',[1 1 1]);
    colormap(gray);
end
    

% this is how it was done earlier (before 19-05-2018)
% t_proj = cp2tform(xybase1, xybase2, 'projective');
% [I_proj,xdata,ydata] = imtransform(im1,t_proj,'FillValues',.3,'XYScale',1);
% xrange = linspace(xdata(1),xdata(2),size(I_proj,2));
% yrange = linspace(ydata(1),ydata(2),size(I_proj,1));
% xind = find(xrange>0 & xrange<=size(im2,2));
% yind = find(yrange>0 & yrange<=size(im2,1));
% 
% im1_out = zeros(size(im2,1),size(im2,2),size(im1,3));
% im1_out(1:length(yind),1:length(xind),1:size(I_proj,3)) = ...
%     I_proj(yind,xind,1:size(I_proj,3));

% transform output images before passing them for display

% first the nanosims image
%sc2 = find_image_scale(im2,0,additional_settings.autoscale_quantiles, log_flag2,0);
sc2 = im2_vscale;
if log_flag2
    im2 = log10(im2);
    sc2 = log10(sc2);
end
im2r = (im2-sc2(1))/diff(sc2);
im2r(im2r<0)=0;
im2r(im2r>1)=1;
% convert it to RGB based on the current colormap
cm = get_colormap(additional_settings.colormap);
im2r=im2r*size(cm,1);
im2rgb = ind2rgb(uint16(im2r),cm);

% now the external image, converted to grayscale
if log_flag1
    im1_out = log10(im1_out);
    sc1 = log10(sc1);
end
im1r = (im1_out-sc1(1))/diff(sc1);
im1r(im1r<0)=0;
im1r(im1r>1)=1;
if size(im1r,3)>1
    im1gray = rgb2gray(im1r);
else
    im1gray = im1r;
end

% display overlay with transparency
[x1new, y1new] = transformPointsForward(t_proj, xybase1(:,1), xybase1(:,2));
f101=display_transparent_overlay_gui(im2rgb,im1gray,[x1new y1new],xybase2, ...
    [symb_col 'x'], [symb_col '+'],...
    sprintf('Overlay of aligned images (%d points)',N));

% generate the output rgb image
% if size(im1_out,3)>1
%     r=im1_out(:,:,1);
%     g=im1_out(:,:,2);
%     b=im1_out(:,:,3);
%     q95r=quantile(r(:),additional_settings.autoscale_quantiles);
%     q95g=quantile(g(:),additional_settings.autoscale_quantiles);
%     q95b=quantile(b(:),additional_settings.autoscale_quantiles);
%     q95im2=quantile(im2(:),additional_settings.autoscale_quantiles);
%     if length([unique([q95r(2), q95g(2), q95b(2)]) ...
%             unique([q95r(1), q95g(1), q95b(1)]) ]) == 2
%         % all channels appear to be the same, so use only one of them
%         rgb = zeros(size(im1_out));
%         rgb(:,:,1)=(r-q95r(1))/diff(q95r);
%         rgb(1:size(im2,1),1:size(im2,2),2)=(im2-q95im2(1))/diff(q95im2);
%         xlab = 'r=ext g=nanosims';
%     else
%         % substitute the darkest channel in the external image with the
%         % nanosims image        
%         [mm,indm]=min([q95r(2), q95g(2), q95b(2)]);
%         rgb = im1_out;
%         rgb(:,:,1)=(rgb(:,:,1)-q95r(1))/diff(q95r);
%         rgb(:,:,2)=(rgb(:,:,2)-q95g(1))/diff(q95g);
%         rgb(:,:,3)=(rgb(:,:,3)-q95b(1))/diff(q95b);
%         rgb(1:size(im2,1),1:size(im2,2),indm)=(im2-q95im2(1))/diff(q95im2);
%         chan='rgb';
%         xlab=[chan(indm),'=nanosims'];
%     end
%     rgb(rgb>1)=1;
%     rgb(rgb<0)=0;
%     tit = sprintf('Overlay of aligned images (%d points)',N);    
% else
%     % set the nanosims image as the green channel, and the external image as
%     % the red channel, of the aligned composite image
%     rgb = zeros(size(im2,1),size(im2,2),3);
%     
%     %sc1 = find_image_scale(im1_out(im1_out>0),0,additional_settings.autoscale_quantiles, log_flag1,0);
%     if log_flag1
%         im1_out = log10(im1_out);
%         sc1 = log10(sc1);
%     end
%     im1_out = (im1_out-sc1(1))/diff(sc1);
%     im1_out(im1_out<0)=0;
%     im1_out(im1_out>1)=1;
% 
%     sc2 = find_image_scale(im2,0,additional_settings.autoscale_quantiles, log_flag2,0);
%     if log_flag2
%         im2 = log10(im2);
%         sc2 = log10(sc2);
%     end
%     im2 = (im2-sc2(1))/diff(sc2);
%     im2(im2<0)=0;
%     im2(im2>1)=1;
%     
%     rgb(:,:,1) = im1_out;
%     rgb(:,:,2) = im2;
%     tit = sprintf('Overlay of aligned images (%d points)',N);
%     xlab = 'r=ext, g=nanosims';    
% end

% f101=figure(101);
% if isempty(get(f101,'children'))
%     was_empty=1;
% else
%     was_empty=0;
% end
% subplot(1,1,1);
% image(rgb);
% set(gca, 'dataaspectratio',[1 1 1]);
% title(tit);
% xlabel(xlab);    
% if was_empty
%     set(f101,'Position',[100 100 600 500]);
% end
