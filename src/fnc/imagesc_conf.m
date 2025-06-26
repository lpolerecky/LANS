function [a, xt, xtl, cmap, cb, fc, cura] = imagesc_conf(IM, mi, ma, HI, colmap, colorbarpos, ax, islog)
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

if nargin>7
    log_flag = islog;
else
    log_flag = 0;
end

cmap = get_colormap(colmap);
if prod(HI(:))~=1
    % if hue modulation requested, cut out the darkest colors from the colormap
    cmap = cmap(6:size(cmap,1),:);
end

% if the image is full of NaN's, which happens when cells are plotted, make
% the image look white
[h,w]=size(IM);
if sum(isnan(IM(:)))==w*h
    a1=ones(h,w,3);
else
    if ~isfloat(IM)
        IM=double(IM);
    end
    as=(IM-mi)/(ma - mi);
    a1=ind2rgb(uint8(as*size(cmap,1)),cmap);
end

% apply hue modulation
if prod(HI(:))~=1
    global additional_settings;
    for ii=1:size(a1,3)
        % LP: 26-06-2025
        % user can now choose in the additional_settings GUI between
        % white and black bkg for hue modulation
        if additional_settings.modulate_hue_with_white
            a1(:,:,ii) = 1 - (1-a1(:,:,ii)).*HI;
        else
            a1(:,:,ii) = a1(:,:,ii).*HI;
        end
    end    
end


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
    
    ch = get(fc,'Children');
    ind_cb = find(isgraphics(ch,'ColorBar'));
    if ~isempty(ind_cb)
        cb = ch(ind_cb);
    else
        cb = colorbar;
    end

    if cbpos==2
        if ~strcmp(get(cb,'location'),'manual')
            set(cb,'location','southoutside');
        end
        xylim = 'x';
    else
        if ~strcmp(get(cb,'location'),'manual')
            set(cb,'location','eastoutside');
        end
        xylim = 'y';
    end
    
    % determine the positions of the ticks, and the corresponding tick
    % labels
    % LP: last update 21-05-2021
    mi=real(mi);
    dr=ma-mi;
    if round(mi)==mi && round(ma)==ma && dr<10
        if dr==1
            xt=[mi:0.5:ma];
        else
            xt = [mi:ma];
        end
    else
        % figure out how to set the tick labels better
        % LP: ticks and ticklabels
        f1 = 10^(floor(log10(dr/4)));
        dx = f1*floor((dr/4)/f1);
        % LP: last update 21-05-2021
        %xt = [(ma-10*dx):dx:ma];
        if round(mi)==mi
            xt = [(mi/dx):ceil(ma/dx)]*dx;
        else
            step = 1;
            xt = [floor(mi/dx):step:ceil(ma/dx)]*dx;            
            while length(xt)>6
                step = step+1;
                xt = [floor(mi/dx):step:ceil(ma/dx)]*dx;
            end
        end
        xt = xt(xt>=mi & (ma-xt)>-eps);
    end
    
    % LP: last update 21-10-2023
    % related to TickLabels
    %xt2 = xt(xt==round(xt));
    if (xt(1)-mi) > 0.5*(xt(2)-xt(1)) && ~log_flag
        xt = [mi xt];
    end
    if (ma-xt(end)) > 0.5*(xt(end)-xt(end-1)) && ~log_flag
        xt = [xt ma];
    end
    
    if max(xt)>0
        f2 = 10^floor(log10(max(xt))-1);    
    else
        f2 = 1;
    end
    if f2>1
        xt=round(xt/f2)*f2;
    end
    
    % LP: last update 21-05-2021
    for ii=1:length(xt)
        if log10(f2)>2             
            xtl{ii,1} = [num2str(xt(ii)/f2) '\times10^{' num2str(log10(f2)), '}' ];
        elseif log10(f2)<=-3
            xtl{ii,1} = [num2str(xt(ii)/(f2*10)) '\times10^{' num2str(log10(f2*10)), '}'];
        elseif log_flag
            xtl{ii,1} = ['10^{', num2str(xt(ii)), '}'];
        else
            xtl{ii,1} = num2str(xt(ii));
        end
    end
    
    % LP: last update 21-05-2021
    %xt=get(cb,[xylim 'tick']);
    %xtl=get(cb,[xylim 'ticklabel']);
    %delete(cb);
          
else
    
    xt=[];
    xtl=[];
    %delete(cb);
    cb = [];
    
end

