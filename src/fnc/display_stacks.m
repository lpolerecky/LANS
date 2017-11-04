function fig=display_stacks(f1,xstack,ystack,zstack,xs,ys,q,h,w,l,dx,dy,fname,mass)
fig=my_figure(f1);
% move the new figure to the middle of the screen, if newly created, but
% don't move it any more once it has been filled with stuff
if isempty(get(fig,'children'))
    ss = get(0,'screensize');
    sw = ss(3);
    sh = ss(4)-50;
    set(fig,'position',[sw/2-sh/2 sh/2-sh/2 sh sh])
end;

[zDARy zDARx]=size(zstack);
[xDARy xDARx]=size(xstack);
[yDARy yDARx]=size(ystack);

subplot(3,3,2);
%sc=quantile(ystack(:),q);
sc = find_image_scale(ystack(:));
imagesc(ystack',sc);
title(sprintf('Y-stack [%d:%d], scale=[%.1f %.1f]',1,h,sc),'fontweight','normal')
xlabel(sprintf('%d -> x -> %d',1,w))
ylabel(sprintf('%d <- z <- %d',l,1))
xlim([0 w]);
ylim([0 l]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[max([xDARy yDARy]), yDARx 1],'FontSize',8)

subplot(3,3,4);
%sc=quantile(xs(:),q);
sc = find_image_scale(xs(:));
imagesc(xs,sc);
title(sprintf('X-stack [%d:%d], scale=[%.1f %.1f]',min(dx),max(dx),sc),'fontweight','normal')
xlabel(sprintf('%d -> z -> %d',1,l))
ylabel(sprintf('%d <- y <- %d',h,1))
xlim([0 l]);
ylim([0 h]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[xDARx, max([xDARy yDARy]) 1],'FontSize',8)

subplot(3,3,5);
%sc=quantile(zstack(:),q);
sc = find_image_scale(zstack(:));
hold off;
imagesc(zstack,sc);
hold on;
pp=plot([1 w],min(dy)*[1 1],'w--');
set(pp,'Color',0.95*[1 1 1]);
pp=plot([1 w],max(dy)*[1 1],'w--');
set(pp,'Color',0.95*[1 1 1]);
pp=plot(min(dx)*[1 1],[1 h],'w--');
set(pp,'Color',0.95*[1 1 1]);
pp=plot(max(dx)*[1 1],[1 h],'w--');
set(pp,'Color',0.95*[1 1 1]);
if length(fname)>27
    fname_=['...' fname(length(fname)-27:length(fname))];
else 
    fname_=fname;
end;
tit=sprintf('%s: %s',fname_,mass);
title(sprintf('%s\nZ-stack [%d:%d], scale=[%.1f %.1f]',tit,1,l,sc),'interpreter','none','fontweight','normal')
xlabel(sprintf('%d -> x -> %d',1,w))
ylabel(sprintf('%d <- y <- %d',h,1))
xlim([0 w]);
ylim([0 h]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[max([zDARx zDARy]), max([zDARx zDARy]) 1],'FontSize',8)

subplot(3,3,6);
%sc=quantile(xstack(:),q);
sc = find_image_scale(xstack(:));
imagesc(xstack,sc);
title(sprintf('X-stack [%d:%d], scale=[%.1f %.1f]',1,w,sc),'fontweight','normal')
xlabel(sprintf('%d -> z -> %d',1,l))
ylabel(sprintf('%d <- y <- %d',h,1))
xlim([0 l]);
ylim([0 h]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[xDARx, max([xDARy yDARy]) 1],'FontSize',8)

subplot(3,3,8);
%sc=quantile(ys(:),q);
sc = find_image_scale(ys(:));
imagesc(ys',sc);
title(sprintf('Y-stack [%d:%d], scale=[%.1f %.1f]',min(dy),max(dy),sc),'fontweight','normal')
xlabel(sprintf('%d -> x -> %d',1,w))
ylabel(sprintf('%d <- z <- %d',l,1))
xlim([0 w]);
ylim([0 l]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[max([xDARy yDARy]), yDARx 1],'FontSize',8)

colormap(clut);
