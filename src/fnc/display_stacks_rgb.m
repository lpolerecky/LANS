function fig=display_stacks_rgb(f1,xstacks,ystacks,zstacks,xs,ys,q,h,w,l,dx,dy,fname,mass)
fig=my_figure(f1);
set(fig,'Name','Accumulated data stacks')
% adjust the position of the figure, if newly created, but don't move it
% any more once it has been filled with stuff
if isempty(get(fig,'children'))
    ss = get(0,'screensize');
    sw = ss(3);
    sh = ss(4)*0.75;
    set(fig,'position',[sw/2-sh*1.543/2 0.125*sh sh*1.543 sh])
end
    
[zDARy zDARx]=size(zstacks{1});
[xDARy xDARx]=size(xstacks{1});
[yDARy yDARx]=size(ystacks{1});

global additional_settings;

%% display full z-stack
subplot(2,3,1);
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
title(sprintf('Z-stack [%d:%d]',1,l))
xlim([0 w+1]);
xticks([1, round((1+w)/2), w])
xticklabels({'1', 'x', sprintf('%d',w)});
ylim([0 h+1]);
yticks([1, round((1+h)/2), h])
yticklabels({'1', 'y', sprintf('%d',h)});
set(gca, ...
    'TickDir','out', ...
    'fontsize',additional_settings.defFontSize, ...
    'DataAspectRatio',[max([zDARx zDARy]), max([zDARx zDARy]) 1])

%% display full x-stack
subplot(2,3,2);
xstacks = rescale_stacks(xstacks,q);
image(xstacks);
title(sprintf('X-stack [%d:%d]',1,w))
xlim([0 l+1]);
xticks([1, round((1+l)/2), l])
xticklabels({'1', 'z', sprintf('%d',l)});
ylim([0 h+1]);
yticks([1, round((1+h)/2), h])
yticklabels({'1', 'y', sprintf('%d',h)});
set(gca, ...
    'TickDir','out', ...
    'fontsize',additional_settings.defFontSize, ...
    'DataAspectRatio',[xDARx, max([xDARy yDARy]) 1])

%% display full y-stack
subplot(2,3,3);
ystacks = rescale_stacks(ystacks,q);
ystacks = transpose3D(ystacks);
image(ystacks);
title(sprintf('Y-stack [%d:%d]',1,h))
xlim([0 w+1]);
xticks([1, round((w+1)/2), w])
xticklabels({'1', 'x', sprintf('%d',w)});
ylim([0 l+1]);
yticks([1, round((1+l)/2), l])
yticklabels({'1', 'z', sprintf('%d',l)});
set(gca, ...
    'TickDir','out', ...
    'fontsize',additional_settings.defFontSize, ...
    'DataAspectRatio',[max([xDARy yDARy]), yDARx 1])

%% display cropped x-stack
subplot(2,3,5);
xs = rescale_stacks(xs,q);
image(xs);
title(sprintf('X-stack2 [%d:%d]',min(dx),max(dx)))
xlim([0 l+1]);
xticks([1, round((1+l)/2), l])
xticklabels({'1', 'z', sprintf('%d',l)});
ylim([0 h+1]);
yticks([1, round((1+h)/2), h])
yticklabels({'1', 'y', sprintf('%d',h)});
set(gca, ...
    'TickDir','out', ...
    'fontsize',additional_settings.defFontSize, ...
    'DataAspectRatio',[xDARx, max([xDARy yDARy]) 1])

%% display cropped y-stack
subplot(2,3,6);
ys = rescale_stacks(ys,q);
ys = transpose3D(ys);
imagesc(ys);
title(sprintf('Y-stack2 [%d:%d]',min(dy),max(dy)))
xlim([0 w+1]);
xticks([1, round((w+1)/2), w])
xticklabels({'1', 'x', sprintf('%d',w)});
ylim([0 l+1]);
yticks([1, round((1+l)/2), l])
yticklabels({'1', 'z', sprintf('%d',l)});
set(gca, ...
    'TickDir','out', ...
    'fontsize',additional_settings.defFontSize, ...
    'DataAspectRatio',[max([xDARy yDARy]), yDARx 1])

%% add global title
if length(fname)>27
    fname_=['...' fname(length(fname)-27:length(fname))];
else 
    fname_=fname;
end
tit=sprintf('%s: %s',fname_,mass);
sgtitle(tit, 'interpreter', 'none','fontweight','bold')

