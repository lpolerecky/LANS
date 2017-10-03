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
end;
dx=x+[-wx:wx];
indx=find(dx>0 & dx<=w);
dx = dx(indx);
dy=y+[-wy:wy];
indy=find(dy>0 & dy<=h);
dy = dy(indy);
xs=squeeze(sum(d(:,dx,:),2));
ys=squeeze(sum(d(dy,:,:),1));
if wz>1
    ys=average_z(ys,wz);
    xs=average_z(xs,wz);
end;
xstack=logtransform(logf,xstack);
ystack=logtransform(logf,ystack);
zstack=logtransform(logf,zstack);
xs=logtransform(logf,xs);
ys=logtransform(logf,ys);
