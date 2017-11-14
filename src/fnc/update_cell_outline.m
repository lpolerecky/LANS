function update_cell_outline(axes1,maskmass, ps, figure1, maskimg, coc, bw, auto_zoom_out)

if(nargin>7)
    zout = auto_zoom_out;
else
    zout = 1;
end;

xlim=get(axes1,'xlim');
ylim=get(axes1,'ylim');

axes(axes1);
hold off;

if(size(maskmass,3)==1)
    imagesc(maskmass, ps); 
    if(bw)
        colormap(gray);
    else
        global additional_settings;
        colormap(get_colormap(additional_settings.colormap));
        %colormap(clut);
    end;
else
    mm=max(maskmass(:));
    if mm>1
        maskmass=maskmass/mm;
    end;
    imagesc(maskmass);
end;

%set(axes1,'xticklabel',[],'yticklabel',[]);

addCellOutline(figure1,maskimg,coc);

if(~zout)
    set(axes1,'xlim',xlim,'ylim',ylim);
end;

set(axes1,'xcolor',[1 1 1],'ycolor',[1 1 1],...
    'DataAspectRatio',[1 1 1],'FontSize',8,'color',0.2*[1 1 1]);
