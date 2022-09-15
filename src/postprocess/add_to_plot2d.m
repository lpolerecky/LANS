function [cls_sel, tmnt_sel]=add_to_plot2d(ax, x, y, dx, dy, roi_prop, ...
    xlab,ylab,xscale,yscale, logscalex,logscaley, s)

% color/symbol scheme
cls_sel  = regexprep(s.cellclasses,' ','');
if isempty(cls_sel)
    cls_all = char(roi_prop.roi_class)';
    cls_sel = unique(cls_all);
end
cls_col = regexprep(s.cellcolors,' ','');
cls_col = cls_col(1:length(cls_sel));

tmnt_sel = str2num(s.treatments);
if isempty(tmnt_sel)
    tmnt_sel = unique(roi_prop.treatment)';
end
tmnt_symb = regexprep(s.symbols,' ','');
tmnt_symb = tmnt_symb(1:length(tmnt_sel));

x_min=min(x);
x_max=max(x);
y_min=min(y);
y_max=max(y);

if ischar(xscale)
    xscale=str2num(xscale);
    set_autoscale_x=0;
end
if isempty(xscale)
    xscale = [0.9*x_min 1.1*x_max];
    set_autoscale_x=1;
end
if ischar(yscale)    
    yscale=str2num(yscale);
    set_autoscale_y=0;
end
if isempty(yscale)
    yscale = [0.9*y_min 1.1*y_max];
    set_autoscale_y=1;
end

for ii=1:size(x,1)
    % only include datapoints for selected treatments and classes
    if ismember(char(roi_prop.roi_class(ii)), cls_sel) && ismember(roi_prop.treatment(ii),tmnt_sel)
        tag=sprintf('ROI/CLASS/TREATMENT/SIZE - FILE\n%d/%c/%d/%.2f - %s',...
            roi_prop.roi_id(ii),roi_prop.roi_class(ii),roi_prop.treatment(ii),roi_prop.size(ii),roi_prop.file{ii});
        p1=find(cls_sel==char(roi_prop.roi_class(ii)));
        p2=find(tmnt_sel==roi_prop.treatment(ii));
        my_plot(x(ii), y(ii), [cls_col(p1),tmnt_symb(p2)],'markersize',10,'tag',tag); 
        if(ii==1), hold on; end
        % make sure that the axis is not autoscaled every time a point is added
        set(ax,'Xlim',xscale, 'Ylim',yscale,'XLimMode','manual','YLimMode','manual')
        if s.disp_errorbars
            my_errorbar2(x(ii), y(ii), dx(ii), dy(ii), cls_col(p1));
        end
    end
end

if set_autoscale_x
    set(ax,'XLimMode','auto');
end
if set_autoscale_y
    set(ax,'YLimMode','auto');
end

global additional_settings;

xlabel(xlab,'FontSize',additional_settings.defFontSize);
ylabel(ylab,'FontSize',additional_settings.defFontSize);
selct = sprintf('(c: %s) [t: %s]', cls_sel, num2str(tmnt_sel));
title({s.graphtitle,selct},'FontSize',additional_settings.defFontSize,'interpreter','none');
set(ax,'box','on','FontSize',additional_settings.defFontSize);
set(ax,'FontSize',additional_settings.defFontSize);
if logscalex
    set(ax,'xscale','log');
else
    set(ax,'xscale','linear');
end
if logscaley
    set(ax,'yscale','log');
else
    set(ax,'yscale','linear');
end