function fig=display_stacks_rgb(f1,xstacks,ystacks,zstacks,xs,ys,q,h,w,l,dx,dy,fname,mass)
fig=my_figure(f1);
% move the new figure to the middle of the screen, if newly created, but
% don't move it any more once it has been filled with stuff
if isempty(get(fig,'children'))
    ss = get(0,'screensize');
    sw = ss(3);
    sh = ss(4)-50;
    set(fig,'position',[sw/2-sh/2 sh/2-sh/2 sh sh])
end;
    
[zDARy zDARx]=size(zstacks{1});
[xDARy xDARx]=size(xstacks{1});
[yDARy yDARx]=size(ystacks{1});

figure(f1);
subplot(3,3,2);
ystacks = rescale_stacks(ystacks,q);
ystacks = transpose3D(ystacks);
image(ystacks);
title(sprintf('Y-stack [%d:%d]',1,h),'fontweight','normal')
xlabel(sprintf('%d -> x -> %d',1,w))
ylabel(sprintf('%d <- z <- %d',l,1))
xlim([0 w]);
ylim([0 l]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[max([xDARy yDARy]), yDARx 1],'FontSize',8)

figure(f1);
subplot(3,3,4);
xs = rescale_stacks(xs,q);
image(xs);
title(sprintf('X-stack [%d:%d]',min(dx),max(dx)),'fontweight','normal')
xlabel(sprintf('%d -> z -> %d',1,l))
ylabel(sprintf('%d <- y <- %d',h,1))
xlim([0 l]);
ylim([0 h]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[],...
    'DataAspectRatio',[xDARx, max([xDARy yDARy]) 1],'FontSize',8)

figure(f1);
subplot(3,3,5);
zstacks = rescale_stacks(zstacks,q);
hold off;
image(zstacks);
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
title(sprintf('%s\nZ-stack [%d:%d]',tit,1,l),'interpreter','none','fontweight','normal')
xlabel(sprintf('%d -> x -> %d',1,w))
ylabel(sprintf('%d <- y <- %d',h,1))
xlim([0 w]);
ylim([0 h]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[max([zDARx zDARy]), max([zDARx zDARy]) 1],'FontSize',8)

figure(f1);
subplot(3,3,6);
xstacks = rescale_stacks(xstacks,q);
image(xstacks);
title(sprintf('X-stack [%d:%d]',1,w),'fontweight','normal')
xlabel(sprintf('%d -> z -> %d',1,l))
ylabel(sprintf('%d <- y <- %d',h,1))
xlim([0 l]);
ylim([0 h]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[xDARx, max([xDARy yDARy]) 1],'FontSize',8)

figure(f1);
subplot(3,3,8);
ys = rescale_stacks(ys,q);
ys = transpose3D(ys);
imagesc(ys);
title(sprintf('Y-stack [%d:%d]',min(dy),max(dy)),'fontweight','normal')
xlabel(sprintf('%d -> x -> %d',1,w))
ylabel(sprintf('%d <- z <- %d',l,1))
xlim([0 w]);
ylim([0 l]);
set(gca,'TickDir','out','xticklabel',[],'yticklabel',[], ...
    'DataAspectRatio',[max([xDARy yDARy]), yDARx 1],'FontSize',8)