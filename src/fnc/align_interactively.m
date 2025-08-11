function [im_out,im1_xyscale,rgb,f102] = align_interactively(im1,im2,im1_vscale,im2_vscale,...
    im1_xyscale,im2_xyscale,log_flag1,log_flag2,tflag)

% default output
im_out = [];
rgb = [];
f102 = [];

% channels of the rgb image for the ext and nanosims images
ext_channel = 1;
ns_channel = 2;

% remember the original nanosims image
im2_orig = im2;

% align im1 to im2 based on two points

global additional_settings;

if nargin>8
    fill_v = 1*(tflag>0);
else
    %fill_v = quantile(im1(:),additional_settings.autoscale_quantiles(1));
    fill_v = im1_vscale(1);
end

% rescale image im1 so that it matches true dimensions of im2
sc1 = size(im1);
sc2 = size(im2);
mag = ( sc1(2)/im1_xyscale ) / ( sc2(2)/im2_xyscale );
if mag>1 % external image maps a smaller area than nanosims
    im1s = imresize(im1,1/mag,'method','bilinear');
    % recreate im1 so that it has the same pixel size as im2, with the rescaled
    % im1 in the center
    sc1s = size(im1s);
    im1f = zeros(sc2);
    dy = round((sc2(1)-sc1s(1))/2);
    dx = round((sc2(2)-sc1s(2))/2);
    im1f(dy+[1:sc1s(1)],dx+[1:sc1s(2)]) = im1s;
    % update im1 and im1_xyscale;
    im1 = im1f;
    im1_xyscale = im1_xyscale*mag;
elseif mag<1 % external image maps a larger area than nanosims    
    im1s = imresize(im1,1/mag,'method','bilinear');
    % recreate im2 so that it has the same pixel size as im1s, with the rescaled
    % im1 in the center
    sc1s = size(im1s);
    im2f = zeros(sc1s);
    dy = round((sc1s(1)-sc2(1))/2);
    dx = round((sc1s(2)-sc2(2))/2);
    im2f(dy+[1:sc2(1)],dx+[1:sc2(2)]) = im2;
    % update im1, im2 and im2_xyscale;
    im1 = im1s;
    im2 = im2f;
    im1_xyscale = im1_xyscale*mag;
elseif mag==1 % external image does not have a defined scale
    mag = im1_xyscale/im2_xyscale;
    if mag>1 % external image has higher resolution than nanosims
        im2 = imresize(im2,mag,'method','nearest');
        im2_xyscale = size(im2,2);
    else
        fprintf(1,'Warning: mag<1, do not know what to do.\n');
    end
end

% assemble rgb image
rgb = zeros(size(im2,1),size(im2,2),3);

im1s = im1;
if size(im1s,3)>1
    im1s = rgb2gray_lans(im1s);
end
im2s = im2;

if sum(abs(size(im2s)-size(im1s)))>0
    fprintf(1,'ERROR: Sizes of the external and nanosims images are not in proportion.\n');
    fprintf(1,'Please zoom in the external image to correct this.\n');
else
    %sc1 = find_image_scale(im1s(im1s>0),0,additional_settings.autoscale_quantiles, log_flag1,0);
    sc1 = im1_vscale;
    if log_flag1
        im1s = log10(im1s);
        sc1 = log10(sc1);
    end
    im1s = (im1s-sc1(1))/diff(sc1);
    im1s(im1s<0)=0;
    im1s(im1s>1)=1;

    %sc2 = find_image_scale(im2s,0,additional_settings.autoscale_quantiles, log_flag2,0);
    sc2 = im2_vscale;
    if log_flag2
        im2s = log10(im2s);
        sc2 = log10(sc2);
    end
    im2s = (im2s-sc2(1))/diff(sc2);
    im2s(im2s<0)=0;
    im2s(im2s>1)=1;

    rgb(:,:,ext_channel) = im1s;
    rgb(:,:,ns_channel) = im2s;

    %% display it for interactive alignment

    f102=figure(102);
    if isempty(get(f102,'children'))
        was_empty=1;
    else
        was_empty=0;
    end
    subplot(1,1,1);
    irgb=image(rgb);

    set(gca, 'dataaspectratio',[1 1 1]);
    rgb_channels = 'rgb';
    title(sprintf('Overlay of images: %c=ext, %c=nanosims (interactive)',...
        rgb_channels(ext_channel),rgb_channels(ns_channel)));
    keys='l/r=turn left/right,  b/s=make bigger/smaller,  arrows=move,  Enter=Finish';
    xlabel(keys);
    if was_empty
        ss = get(0,'Screensize');
        set(f102,'Position',[100 100 0.85*ss(4) 5/6*0.85*ss(4)])
    end

    hd=helpdlg({'Entering INTERACTIVE ALIGNMENT TOOL',...
        'Use the following keys to transform the external image:',...
        'L = rotate LEFT by 1 deg',...
        'R = rotate RIGHT by 1 deg',...
        'ARROW (left/right/up/down) = displace by 1 pix in the direction of the ARROW',...
        'B = make BIGGER by 1 per cent',...
        'S = make SMALLER by 1 per cent',...
        'ENTER or ESC = FINISH interactive alignment',...
        'NOTE: do NOT close the window or do other actions before finishing!'},'LANS help');
    set(hd,'windowstyle','modal');

    uiwait(hd);

    k=0;
    ang=0;
    magi=1;
    xoff = 0;
    yoff = 0;
    comp = 0;
    set(f102,'windowstyle','modal')
    fprintf(1,'Current status: angle=%d, mag=%.2f, xoff=%d, yoff=%d, comp=%.2f.\n',ang,magi,xoff,yoff,comp);
    while k~=27 & k~=13
        [x y k ax ] = my_ginput(f102);
        if k == double('l') | k == double('L')
            ac='Turning left';
            ang = ang-1;
            if ang==-1, ang=359; end
        elseif k == double('r') | k == double('R')
            ac='Turning right';
            ang = ang+1;
            if ang==360, ang=0; end
        elseif k == double('b') | k == double('B')
            ac='Making bigger';
            magi = magi+0.01;
        elseif k == double('s') | k == double('S')
            ac='Making smaller';
            magi = magi-0.01;
        elseif k == 28 % left arrow
            ac='Moving left';
            xoff = xoff-1;
        elseif k == 29 % right arrow
            ac='Moving right';
            xoff = xoff+1;
        elseif k == 30 % up arrow
            ac='Moving up';
            yoff = yoff-1;
        elseif k == 31 % down arrow
            ac='Moving down';
            yoff = yoff+1;
        elseif k==27 | k==13
            ac='Finishing';
        else
            ac='No action associated with this key.';
        end
        fprintf(1,'%s\n',ac);

        theta = ang;
        tform = affine2d([magi.*cosd(theta) magi.*sind(theta) 0; ...
                          -magi.*sind(theta)  magi.*cosd(theta) 0; ...
                          0 0 1]);
        im1b = imwarp(im1s,tform);
        comp = (size(im1b,2)-size(im1s,2))/2;
        im1t = imtranslate(im1b,[xoff-comp yoff-comp],'FillValues',max(im1b(:)));

        if size(im1t,1)>=size(im2s,1)
            rgb=zeros(size(im1t,1),size(im1t,2),3);
            rgb(1:size(im2s,1),1:size(im2s,2),ns_channel)=im2s; %cells3/max(cells3(:));
            rgb(:,:,ext_channel)=im1t; %im1t/max(im1t(:));
        else
            rgb=zeros(size(im2s,1),size(im2s,2),3);
            rgb(1:size(im1t,1),1:size(im1t,2),ext_channel)=im1t; %im1t/max(im1t(:));
            rgb(:,:,ns_channel)=im2s; %cells3/max(cells3(:));
        end

        set(irgb,'cdata',rgb, 'xdata',[1 size(rgb,2)], 'ydata',[1 size(rgb,1)] );
        fprintf(1,'Current status: angle=%d, mag=%.2f, xoff=%d, yoff=%d, comp=%.2f (press ENTER or ESC to finish).\n',ang,magi,xoff,yoff,comp);

    end

    fprintf(1,'Interactive alignment finished.\n');
    figure(f102)
    title('Overlay of aligned images (interactive)','HorizontalAlignment', 'center')
    xlabel(sprintf('%c=ext, %c=nanosims (a=%d m=%.2f dx=%d dy=%d)',...
        rgb_channels(ext_channel),rgb_channels(ns_channel), ang,magi/mag,xoff,yoff));
    set(f102,'windowstyle','normal')

    % perform the same transformation on the original image
    % rotate
    im1b = imwarp(im1,tform);
    comp = (size(im1b,2)-size(im1s,2))/2;
    % translate
    im_out = imtranslate(im1b,[xoff-comp yoff-comp],'FillValues',0);
    % crop
    if size(im_out,1)<size(im2,1)
        tmp = zeros(size(im2));
        tmp(1:size(im_out,1),1:size(im_out,2)) = im_out;
        im_out = tmp;
    else
        im_out = im_out(1:size(im2,1),1:size(im2,2));
        rgb = rgb(1:size(im2,1),1:size(im2,2),:);
    end
    mag = size(im2_orig,1)/size(im_out,1);
    if mag~=1 % resize to the original size of the nanosims image
        im_out = imresize(im_out,mag,'method','nearest');
        rgb = imresize(rgb,mag,'method','nearest');
        im1_xyscale = size(im_out,2);
    end
    a=0;
end
