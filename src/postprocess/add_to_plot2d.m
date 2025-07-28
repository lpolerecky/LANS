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

global additional_settings;

% find out the number of datapoints that will be shown (from selected
% treatments and classes):
N_displayed = sum(ismember(char(roi_prop.roi_class), cls_sel) & ismember(roi_prop.treatment,tmnt_sel));

XY_DATA_SCATTER_PLOT = zeros(N_displayed,4);

i_added = 0;
for ii=1:size(x,1)
    % only include datapoints for selected treatments and classes
    if ismember(char(roi_prop.roi_class(ii)), cls_sel) && ismember(roi_prop.treatment(ii),tmnt_sel)
        tag=sprintf('ROI/CLASS/TREATMENT/SIZE - FILE\n%d/%c/%d/%.2f - %s',...
            roi_prop.roi_id(ii),roi_prop.roi_class(ii),roi_prop.treatment(ii),roi_prop.size(ii),roi_prop.file{ii});
        p1=find(cls_sel==char(roi_prop.roi_class(ii)));
        p2=find(tmnt_sel==roi_prop.treatment(ii));
        my_plot(x(ii), y(ii), [cls_col(p1),tmnt_symb(p2)],'markersize',10,'tag',tag); 
        i_added = i_added + 1;
        if(i_added==1), hold on; end
        % make sure that the axis is not autoscaled every time a point is added
        set(ax,'Xlim',xscale, 'Ylim',yscale,'XLimMode','manual','YLimMode','manual')
        if s.disp_errorbars % additional_settings.display_error_bars 
            my_errorbar2(x(ii), y(ii), dx(ii), dy(ii), cls_col(p1));
        end
        XY_DATA_SCATTER_PLOT(i_added,:) = [x(ii) dx(ii) y(ii) dy(ii)];
    end
end
if i_added ~= N_displayed
    fprintf(1,'Number of added and displayed points do not agree with each other.\n')
end

% remember the added data in the correct global variable (used for fitting)
global XY_DATA_SCATTER_PLOT1 XY_DATA_SCATTER_PLOT2 XY_DATA_SCATTER_PLOT3;
XY_DATA_SCATTER_PLOT1 = 0;
XY_DATA_SCATTER_PLOT2 = 0;
XY_DATA_SCATTER_PLOT3 = 0;

fignum = get(get(ax,'Parent'),'Number');
switch fignum
    case 61, XY_DATA_SCATTER_PLOT1 = XY_DATA_SCATTER_PLOT;
    case 62, XY_DATA_SCATTER_PLOT2 = XY_DATA_SCATTER_PLOT;
    case 63, XY_DATA_SCATTER_PLOT3 = XY_DATA_SCATTER_PLOT;
end

% populate strings for the title
legend_colors = strings(1,length(cls_sel));
for ii=1:length(cls_sel)
    legend_colors{ii} = [num2str(cls_sel(ii)), '/' cls_col(ii)];
end
legend_colors = join(legend_colors);

legend_symbols = strings(1,length(tmnt_sel));
for ii=1:length(tmnt_sel)
    legend_symbols{ii} = [num2str(tmnt_sel(ii)), '/' tmnt_symb(ii)];
end
legend_symbols = join(legend_symbols);

if set_autoscale_x
    set(ax,'XLimMode','auto');
end
if set_autoscale_y
    set(ax,'YLimMode','auto');
end

xlabel(xlab,'FontSize',additional_settings.defFontSize);
ylabel(ylab,'FontSize',additional_settings.defFontSize);
%selct = sprintf('(c: %s) [t: %s]', cls_sel, num2str(tmnt_sel));
selct = sprintf('(col: %s) [sym: %s]', legend_colors, legend_symbols);
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