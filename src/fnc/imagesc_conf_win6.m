function [a, xt, xtl, cmap, cb, fc, cura] = imagesc_conf_win6(IM, mi, ma, HI, colmap, colorbarpos, ax)
% display image with the hue intensity modified by HI correction

if nargin>5
    cbpos = colorbarpos;
else
    cbpos = 0;
end

if nargin>6
    cura = ax;
else
    cura = gca;
end

cmap = get_colormap(colmap);
[h,w]=size(IM);
if ~isfloat(IM)
    IM=double(IM);
end
as=(IM-mi)/(ma - mi);
a1=ind2rgb(uint8(as*size(cmap,1)),cmap);

a = cura.Children;
ind_image = find(isgraphics(cura.Children,'Image'));
if ~isempty(ind_image)
    a = a(ind_image);
    a.CData = a1;
    cura.YLim = [0.5 h+0.5];
    cura.XLim = [0.5 w+0.5];
else
    axes(cura);
    a = image(a1);
    set(cura, 'DataAspectRatio', [1 1 1], ...
        'XTick',[], 'YTick',[],'box','on', ...
        'Visible','off');
end

fc = get(cura,'Parent');

if cbpos ~= 0
    % do nothing  
    cb = [];
else
    
    xt=[];
    xtl=[];
    cb = [];
    
end

