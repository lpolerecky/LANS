function [ext5,im1_xyscale,rgb,f100]=align2images_2points(v1,v2,im1,im2,im1_vscale,im2_vscale,...
    im1_xyscale,im2_xyscale,log_flag1,log_flag2,tflag)

% align im1 to im2 based on two points

global additional_settings;

if nargin>10
    fill_v = 1*(tflag>0);
else
    fill_v = quantile(im1(:),additional_settings.autoscale_quantiles(1));
end

% choose the first 2 points, in case more than 2 were input
v1 = v1(:,1:2);
v2 = v2(:,1:2);

% resize image im1 so that it matches true dimensions of im2
sc1 = size(im1);
sc2 = size(im2);

if sc1(2)==im1_xyscale
% this happens when the image xy_scale is in pixels, not in real size units
    mag = sc1(2)/sc2(2);
else
    mag = ( sc1(2)/im1_xyscale ) / ( sc2(2)/im2_xyscale );
end

if size(im1,3)>1
    im1=rgb2gray(im1);
end

if mag>1 % external image maps a smaller area than nanosims
    im1s = imresize(im1,1/mag,'method','bilinear');
    % recreate im1 so that it has the same pixel size as im2, with the rescaled
    % im1 in the center
    sc1s = size(im1s);
    im1f = zeros(sc2);
    dy = round((sc2(1)-sc1s(1))/2);
    dx = round((sc2(2)-sc1s(2))/2);
    im1f(dy+[1:sc1s(1)],dx+[1:sc1s(2)]) = im1s;
    % transform also the locations of the points defined on im1
    v1s = round(v1/mag+[dx; dy]);
    % update im1, v1 and im1_xyscale;
    im1 = im1f;
    v1 = v1s;
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
    % transform also the locations of the points defined on im1 and im2
    v1s = round(v1/mag);
    v2s = round(v2+[dx; dy]);
    % update im1, im2, v1, v2 and im2_xyscale;
    im1 = im1s;
    im2 = im2f;
    v1 = v1s;
    v2 = v2s;
    im1_xyscale = im1_xyscale*mag;    
end
    
% check images
if 0
    figure(1);
    subplot(1,2,1);
    hold off
    imagesc(im1);
    hold on;
    plot(v1(1,:),v1(2,:),'wo')    
    title('rescaled external');
    subplot(1,2,2);
    hold off
    imagesc(im2);
    hold on;
    plot(v2(1,:),v2(2,:),'wo')
    title('nanosims')
    colormap(hot)
end

% extend the points to the edges of the images
v1edge = get_v_edge(v1, im1);
v2edge = get_v_edge(v2, im2);
% get coordinates of all points connecting the edge points
[x1, y1] = get_points_lateral_profile(v1edge);
[x2, y2] = get_points_lateral_profile(v2edge);
lw = 1;

% extract profile along these extended profiles
[pos1, meanv1, stdv1] = get_lateral_profile(x1, y1, im1, lw, im1_xyscale);
[pos2, meanv2, stdv2] = get_lateral_profile(x2, y2, im2, lw, im2_xyscale);

% find positions of the original points on the profile
pos1pp = zeros(size(v1,2),2);
pos2pp = zeros(size(v2,2),2);
for j=1:size(v1,2)
    d1 = (x1-v1(1,j)).^2 + (y1-v1(2,j)).^2;
    [m1,i1] = min(abs(d1));
    pos1pp(j,1) = pos1(i1);
    pos1pp(j,2) = meanv1(i1)/max(meanv1);
    d2 = (x2-v2(1,j)).^2 + (y2-v2(2,j)).^2;
    [m2,i2] = min(abs(d2));
    pos2pp(j,1) = pos2(i2);
    pos2pp(j,2) = meanv2(i2)/max(meanv2);
end     

% calculate the offset between the two profiles as the average of the
% offsets of the first and second points
dpos = mean(pos2pp(:,1) - pos1pp(:,1));

extimage = im1;
nanosimsimage = im2;

%% now align the images by rotation and translation

% calculate the centers of the points
c1 = mean(v1,2);
c2 = mean(v2,2);
dc = c2 - c1;
% calculate the angle between the vectors
v1vec = diff(v1,1,2);
v2vec = diff(v2,1,2);
sp = sum(v1vec.*v2vec);
lp = sqrt(sum(v1vec.*v1vec)) * sqrt(sum(v2vec.*v2vec));
phi = -acos(sp/lp);
% rotation matrix
M = [cos(phi) sin(phi); -sin(phi) cos(phi)];
t = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1];
tform = affine2d(t);
% translate image and profile so that the profile's center is in the middle
dc1 = size(extimage)'/2-c1;
ext2 = imtranslate(extimage,dc1','FillValues',fill_v);
v1t = v1 + dc1;
% rotate image and profile (around the central point)
ext3 = imwarp(ext2,tform);
v1r = M*(v1t-mean(v1t,2)) + round([size(ext3,2)/2 size(ext3,1)/2]);
% translate and crop
dc2 = round((size(ext3)-size(nanosimsimage))/2);
v1rt = v1r - [dc2(2); dc2(1)];
dc3 = round(mean(v2,2)-mean(v1rt,2));
ind1 = [1:size(nanosimsimage,1)]+dc2(1);
ind2 = [1:size(nanosimsimage,2)]+dc2(2);
% crop to the final size
ext4 = ext3(ind1,ind2);
ind1 = ind1-dc3(2); %??? +dc3(1)
ind2 = ind2-dc3(1); %??? +dc3(2)
ext5 = ext3(ind1,ind2);
v1rtt = v1rt + dc3;

% check results
if 0
    % progress of the image and profile transformations
    figure(3);
    subplot(2,3,1); hold off;
    imagesc(extimage); hold on;
    plot(v1(1,:),v1(2,:),'w-');
    title('original ext');
    subplot(2,3,2); hold off;
    imagesc(ext2); hold on;
    plot(v1t(1,:),v1t(2,:),'w-');
    title('translated ext');
    subplot(2,3,3); hold off;
    imagesc(ext3); hold on;
    plot(v1r(1,:),v1r(2,:),'w-');
    title('translated+rotated ext');
    subplot(2,3,4); hold off;
    imagesc(ext4); hold on;
    plot(v1rt(1,:),v1rt(2,:),'w-');
    title('translated+rotated+cropped ext');
    subplot(2,3,5); hold off;
    imagesc(ext5); hold on;
    plot(v1rtt(1,:),v1rtt(2,:),'w-');
    title('translated+rotated+cropped2 ext');
    subplot(2,3,6); hold off;
    imagesc(nanosimsimage); hold on;
    plot(v2(1,:),v2(2,:),'w-');
    title('translated nanosims');
    colormap(hot);
    % final overlap of the end-points
    figure(4);
    hold off
    plot(v1rtt(1,:),v1rtt(2,:),'ro-');
    hold on;
    plot(v2(1,:),v2(2,:),'gx-');
    set(gca,'ydir','reverse')
    xlim([1,sc2(2)]);
    ylim([1,sc2(1)]);    
    legend({'external','nanosims'});
end

% assemble output rgb image
rgb = zeros(size(im2,1),size(im2,2),3);

im1 = ext5;
%sc1 = find_image_scale(im1(im1>0),0,additional_settings.autoscale_quantiles, log_flag1,0);
sc1 = im1_vscale;
if log_flag1
    im1 = log10(im1);
    sc1 = log10(sc1);
    meanv1 = log10(meanv1);
end
im1 = (im1-sc1(1))/diff(sc1);
im1(im1<0)=0;
im1(im1>1)=1;
meanv1 = (meanv1-sc1(1))/diff(sc1);

im2 = nanosimsimage;
%sc2 = find_image_scale(im2,0,additional_settings.autoscale_quantiles, log_flag2,0);
sc2 = im2_vscale;
if log_flag2
    im2 = log10(im2);
    sc2 = log10(sc2);
    meanv2 = log10(meanv2);
end
im2 = (im2-sc2(1))/diff(sc2);
im2(im2<0)=0;
im2(im2>1)=1;
meanv2 = (meanv2-sc2(1))/diff(sc2);
    
rgb(:,:,1) = im1;
rgb(:,:,2) = im2;
tit = sprintf('Overlay of aligned images (%d points)',2);
xlab = 'r=ext, g=nanosims';

% display final results: 1. overlay the lateral profiles; 2. overlay images
if 1
    f100=figure(100);
    if isempty(get(f100,'children'))
        was_empty=1;
    else
        was_empty=0;
    end
    subplot(1,2,1);
    hold off;
    plot(pos1+dpos,meanv1/max(meanv1),'r.-');
    hold on;
    plot(pos2,meanv2/max(meanv2),'g.-');
    plot([pos1pp(:,1) pos1pp(:,1)]'+dpos,[zeros(size(pos1pp,1),1) pos1pp(:,2)]','r--');
    plot([pos2pp(:,1) pos2pp(:,1)]',[zeros(size(pos2pp,1),1) pos2pp(:,2)]','g--');
    legend({'external','nanosims'},'Location','Northwest');  
    axis tight
    ylim([0 1]);
    title('Overlay of lateral profiles')
    xlabel('position (\mum)')
    subplot(1,2,2);
    hold off
    image(rgb)
    hold on
    plot(v1rtt(1,:),v1rtt(2,:),'wo-');
    plot(v2(1,:),v2(2,:),'yo-');    
    title(tit)
    xlabel(sprintf('%s (a=%.1f m=%.2f)', xlab,-phi/pi*180,1/mag));    
    set(gca,'dataaspectratio',[1 1 1])
    if was_empty
        ss = get(0,'Screensize');
        set(f100,'Position',[100 100 12/5*0.5*ss(4) 0.5*ss(4)]);
        set(f100,'PaperPosition',[0.25 0.5 12 5])    
    end
end
a=0;