function [xstack,ystack,zstack,xs,ys,h,w,l,dx,dy]=get_stacks(d,x,y,wx,wy,wz,logf)
h=size(d,1);
w=size(d,2);
l=size(d,3);
zstack=squeeze(sum(d,3));
ystack=squeeze(sum(d,1));
xstack=squeeze(sum(d,2));
if wz>1
    ystack=average_z(ystack,wz);
    xstack=average_z(xstack,wz);
end

if bitget(wx,1) % if wx is odd
    dx = x + [-(wx-1)/2:(wx-1)/2];
else
    dx = x + ceil([-(wx-1)/2:(wx-1)/2]);
end
dx = dx(dx>0 & dx<=w);

if bitget(wy,1) % if wy is odd
    dy = y + [-(wy-1)/2:(wy-1)/2];
else
    dy = y + ceil([-(wy-1)/2:(wy-1)/2]);
end
dy = dy(dy>0 & dy<=h);

xs=squeeze(sum(d(:,dx,:),2));
ys=squeeze(sum(d(dy,:,:),1));
if wz>1
    ys=average_z(ys,wz);
    xs=average_z(xs,wz);
end

if logf
    global additional_settings;
    xscale = find_image_scale(xstack,0,additional_settings.autoscale_quantiles,logf,0);
    xstack = log10transform_image(xstack, xscale);
    yscale = find_image_scale(ystack,0,additional_settings.autoscale_quantiles,logf,0);
    ystack = log10transform_image(ystack, yscale);
    zscale = find_image_scale(zstack,0,additional_settings.autoscale_quantiles,logf,0);
    zstack = log10transform_image(zstack, zscale);
    
    xscale1 = find_image_scale(xs,0,additional_settings.autoscale_quantiles,logf,0);
    xs = log10transform_image(xs, xscale1);
    yscale1 = find_image_scale(ys,0,additional_settings.autoscale_quantiles,logf,0);
    ys = log10transform_image(ys, yscale1);
    
%     xstack=logtransform(logf,xstack);
%     ystack=logtransform(logf,ystack);
%     zstack=logtransform(logf,zstack);
%     xs=logtransform(logf,xs);
%     ys=logtransform(logf,ys);
end