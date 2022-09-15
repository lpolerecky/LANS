function update_cell_outline(axes1,maskmass, ps, figure1, maskimg, coc, bw, auto_zoom_out,mag_fac)

% t1=clock;

if(nargin>7)
    zout = auto_zoom_out;
else
    zout = 1;
end
if nargin<9
    mag_fac = 1;
end

a=findobj(axes1,'tag','maskmass');

if isempty(a)
    
    axes(axes1);
    hold off;

    if(size(maskmass,3)==1)
        a=imagesc(maskmass, ps); 
        if(bw)
            colormap(gray);
        else
            global additional_settings;
            colormap(get_colormap(additional_settings.colormap));
            %colormap(clut);
        end
    else
        mm=max(maskmass(:));
        if mm>1
            maskmass=maskmass/mm;
        end
        global shown_rgb;
        if shown_rgb(1)==0
            maskmass(:,:,1)=0;
        end
        if shown_rgb(2)==0
            maskmass(:,:,2)=0;
        end
        if shown_rgb(3)==0
            maskmass(:,:,3)=0;
        end
        if sum(shown_rgb)>1
            a=image(maskmass);
        else
            a=imagesc(maskmass(:,:,find(shown_rgb==1)));
            colormap(gray);
        end    

    end

    set(a,'Tag','maskmass');
end

xlim=get(axes1,'xlim');
ylim=get(axes1,'ylim');

%addCellOutline(figure1,maskimg,coc,mag_fac);

if(~zout)
    set(axes1,'xlim',xlim,'ylim',ylim);
end

set(axes1,'xcolor',[1 1 1],'ycolor',[1 1 1],...
    'DataAspectRatio',[1 1 1],'FontSize',8,'color',0.2*[1 1 1]);

% delete all previously drawn ROI boundaries and redraw them within the
% viewed area
b=findobj(axes1,'tag','roi_boundary');
if ~isempty(b)
    delete(b);
end
maskimg_cropped = zeros(size(maskimg));
yint = [round(ylim(1)):round(ylim(2))];
xint = [round(xlim(1)):round(xlim(2))];
yint = yint(find(yint>0 & yint<=size(maskimg,1)));
xint = xint(find(xint>0 & xint<=size(maskimg,2)));
maskimg_cropped(yint, xint) = maskimg(yint, xint);

addCellOutline(axes1,maskimg_cropped,coc,mag_fac);

% t2=clock;
% global verbose
% if verbose
%     fprintf(1,'update_cell_outline.m: %.3fs\n',etime(t2,t1));    
% end