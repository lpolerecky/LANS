function fig=display_stacks(f1,xstack,ystack,zstack,xs,ys,q,h,w,l,dx,dy,fname,mass)
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

[zDARy zDARx]=size(zstack);
[xDARy xDARx]=size(xstack);
[yDARy yDARx]=size(ystack);

global additional_settings;

%% display full z-stack
subplot(2,3,1);
sc_z = find_image_scale(zstack(:), 0,additional_settings.autoscale_quantiles,0,0);
hold off;
imagesc(zstack,sc_z);
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
sc_x = find_image_scale(xstack(:), 0,additional_settings.autoscale_quantiles,0,0);
imagesc(xstack,sc_x);
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
sc_y = find_image_scale(ystack(:), 0,additional_settings.autoscale_quantiles,0,0);
imagesc(ystack',sc_y);
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
sc_x2 = find_image_scale(xs(:), 0,additional_settings.autoscale_quantiles,0,0);
imagesc(xs,sc_x2);
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
sc_y2 = find_image_scale(ys(:), 0,additional_settings.autoscale_quantiles,0,0);
imagesc(ys',sc_y2);
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

s4=subplot(2,3,4);
cb=colorbar('northoutside', ...
    'Limits', [0 1], ...
    'ticks', [0 1], ...
    'TickLabels',{'min', 'max'}, ...
    'fontsize',additional_settings.defFontSize);

%% add scale information for each stack
t1 = findobj('tag',['t1.', num2str(f1)]);
if isempty(t1)
    t1 = text(0,1, 'Scale:', 'fontsize',additional_settings.defFontSize,'fontweight','bold', 'tag', ['t1.', num2str(f1)]);
end
t2 = findobj('tag',['t2.', num2str(f1)]);
if isempty(t2)
    t2 = text(0,0.9, sprintf('Z-stack:  [%d %d]', round(sc_z)), 'units','normalized', 'fontsize',additional_settings.defFontSize, 'tag', ['t2.', num2str(f1)]);
end
t3 = findobj('tag',['t3.', num2str(f1)]);
if isempty(t3)
    t3 = text(0,0.8, sprintf('X-stack:  [%d %d]', round(sc_x)), 'units','normalized', 'fontsize',additional_settings.defFontSize, 'tag', ['t3.', num2str(f1)]);
end
t4 = findobj('tag',['t4.', num2str(f1)]);
if isempty(t4)
    t4 = text(0,0.7, sprintf('Y-stack:  [%d %d]', round(sc_y)), 'units','normalized', 'fontsize',additional_settings.defFontSize, 'tag', ['t4.', num2str(f1)]);
end
t5 = findobj('tag',['t5.', num2str(f1)]);
if isempty(t5)
    t5 = text(0,0.6, sprintf('X-stack2: [%d %d]', round(sc_x2)), 'units','normalized', 'fontsize',additional_settings.defFontSize, 'tag', ['t5.', num2str(f1)]);
else
    set(t5,'String', sprintf('X-stack2: [%d %d]', round(sc_x2)));
end
t6 = findobj('tag',['t6.', num2str(f1)]);
if isempty(t6) 
    t6 = text(0,0.5, sprintf('Y-stack2: [%d %d]', round(sc_y2)), 'units','normalized', 'fontsize',additional_settings.defFontSize, 'tag', ['t6.', num2str(f1)]);
else
    set(t6,'String', sprintf('Y-stack2: [%d %d]', round(sc_y2)));
end
s4.Visible = 0;

colormap(get_colormap(additional_settings.colormap));
