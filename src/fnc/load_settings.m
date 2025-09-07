function s=load_settings(s,fname,fig_pos_flag)

if(nargin>2)
    fpf=fig_pos_flag;
else
    fpf = 1;
end

%% load the last saved preferences from the ini file and fill the GUI 
%  objects and other flags
h=[];
if exist(fname,'file')
    load(fname);
    [~, name, ~] = fileparts(fname);
    if strcmp(name,'nanosimsini')
        set(s.edit1,'string',h.edit1.string);
        set(s.edit2,'string',h.edit2.string);
    end 
    %set(s.listbox1,'string',h.listbox1.string);
    
    % fill edit-fields with the loaded values
    for ii=3:76
        es=['edit' num2str(ii)];
        es1=['s.' es];
        es2=['h.' es '.string'];
        b1a=['b1a=isfield(h,''',es,''');'];
        b1b=['b1b=isfield(s,''',es,''');'];
        b2=['set(',es1,',''string'',',es2,');'];        
        eval(b1a);
        eval(b1b);
        if(b1a && b1b)
            % in earlier versions of LANS, smoothing kernel was a 2x1 vector,
            % but now it's only a number. so correct this when loading the
            % preferences
%             if ii==32
%                 eval(['sk=' es2 ';']);
%                 sk=str2num(sk);
%                 if length(sk)>1
%                     sk=sk(1);
%                 end;
%                 eval([es2 ' = num2str(sk);']);
%             end;
            eval(b2);
        end
    end
    
    % fill checkboxes with the loaded values
    for ii=7:73
        es=['checkbox' num2str(ii)];
        es1=['s.' es];
        es2=['h.' es '.value'];
        b1a=['b1a=isfield(h,''',es,''');'];
        b1b=['b1b=isfield(s,''',es,''');'];
        b2=['set(',es1,',''value'',',es2,');'];        
        eval(b1a);
        eval(b1b);
        if(b1a && b1b)
            eval(b2);
        end
        % ensure that checkboxes "Export ASCII data" and "Export PDF
        % graphics" are *always* checked by default, to avoid panic that
        % may occur if they are unchecked ("nothing seems to work"). 
        if nargin==2 && (ii==58 || ii==59)
            b2=['set(',es1,',''value'',1);'];
            if(b1a && b1b)
                eval(b2);
            end
        end
    end
    
    if(isfield(h,'figureposition') && fpf)
        fp=get(s.figure1,'Position');
        fp1 = h.figureposition;
        set(s.figure1,'Position',[fp1(1:2) fp(3:4)]);
    end
 
    % dead-time-correction structure
    ONES = ones(1, 8);        
    if isfield(h,'dtc')
        s.dtc = h.dtc;
    else
        d.dt = 44*ONES; % dead-time, in ns
        d.y  = 1*ONES; % yield
        d.bkg = 0*ONES; % in counts/second
        %d.dwelling_time = 1; % dwelling time, in ms
        d.apply_dtc = 0; % apply dead-time correction
        d.apply_QSA = 0; % apply QSA correction
        d.beta = 0*ONES;
        d.FCo = 2; % PIB current at sample surface, pA
        s.dtc = d;        
    end    
    if ~isfield(s.dtc,'apply_QSA')
        s.dtc.apply_QSA = 0;
    end
    if ~isfield(s.dtc,'beta')
        s.dtc.beta=0*ONES;
    end
    if ~isfield(s.dtc,'FCo')
        s.dtc.FCo=2;
    end
    
    % shift_columns_rows flags
    if isfield(h,'shift_columns_rows')
        s.shift_columns_rows = h.shift_columns_rows;
        %fprintf(1,'Flags for shifting columns and rows set to [%d %d %d %d]\n',s.shift_columns_rows);
    else
        s.shift_columns_rows = [0 0 0 0];
    end
    
    if isfield(h,'raster_size')
        set(s.text46,'string',num2str(h.raster_size));
    end
    
    if isfield(h,'mass')
        s.mass = h.mass;
    else
        s.mass = [];
    end
    
    if isfield(h,'imscale_full')
        s.imscale_full = h.imscale_full;
    else
        s.imscale_full = [];
    end
        
    % additional settings (implemented in version 03-09-2012)
    global additional_settings;
    if strcmp(name,'nanosimsini')       
        if isfield(h,'additional_settings')
            additional_settings = h.additional_settings;
            if isempty(additional_settings)
                % these are default values tested on my computer
                q = get_default_settings;                
                additional_settings = q;
            else
                if length(additional_settings.print_factors)<6
                    additional_settings.print_factors(6)=1;
                end
                if length(additional_settings.print_factors)<7
                    additional_settings.print_factors(7)=1;
                end
                if ~isfield(h.additional_settings,'export_png')
                    additional_settings.export_png = 0;
                end
                if ~isfield(h.additional_settings,'export_eps')
                    additional_settings.export_eps = 0;
                end
                if ~isfield(h.additional_settings,'export_tif')
                    additional_settings.export_tif = 0;
                end
                if ~isfield(h.additional_settings,'compress_pdf')
                    additional_settings.compress_pdf = 0;
                end
                if ~isfield(h.additional_settings,'always_display_rois')
                    additional_settings.always_display_rois = 0;
                end
                if ~isfield(h.additional_settings,'title_length')
                    additional_settings.title_length = 40;
                end
                if ~isfield(h.additional_settings,'defFontSize')
                    additional_settings.defFontSize = 16;
                end
                if ~isfield(h.additional_settings,'include_scale_text')
                    additional_settings.include_scale_text = 1;
                end
                if ~isfield(h.additional_settings,'scale_bar_length')
                    additional_settings.scale_bar_length = 3;
                end
                if ~isfield(h.additional_settings,'autoscale_quantiles')
                    additional_settings.autoscale_quantiles = [0.001 0.999];
                end
                if ~isfield(h.additional_settings,'display_error_bars')
                    additional_settings.display_error_bars = 1;
                end
                if ~isfield(h.additional_settings,'display_trend_lines')
                    additional_settings.display_trend_lines = 1;
                end
                if ~isfield(h.additional_settings,'colormap')
                    additional_settings.colormap = 1;
                end
                if ~isfield(h.additional_settings,'view_pdf')
                    additional_settings.view_pdf = 0;
                end
                if ~isfield(h.additional_settings,'include_colorbar_label')
                    additional_settings.include_colorbar_label = 1;
                end                
                if ~isfield(h.additional_settings,'apply_1e3_factor')
                    additional_settings.apply_1e3_factor = 0;
                end
                if ~isfield(h.additional_settings,'smooth_masses_kernelsize')
                    additional_settings.smooth_masses_kernelsize = [5 1];
                end
                if ~isfield(h.additional_settings,'smooth_esi_kernelsize')
                    additional_settings.smooth_esi_kernelsize = [1 1];
                end
                if ~isfield(h.additional_settings,'title_position')
                    additional_settings.title_position = 0;
                end
                if ~isfield(h.additional_settings,'fill_title_background')
                    additional_settings.fill_title_background = 0;
                end
                if ~isfield(h.additional_settings,'title_background_color')
                    additional_settings.title_background_color = 'w';
                end
                if ~isfield(h.additional_settings,'title_font_size_color')
                    additional_settings.title_font_size_color = '14k';
                end                
                if ~isfield(h.additional_settings,'calculate_LWfactor')
                    additional_settings.calculate_LWfactor = 1;
                end
                if ~isfield(h.additional_settings,'calculate_perimeter')
                    additional_settings.calculate_perimeter = 0;
                end
                if ~isfield(h.additional_settings,'calculate_roi_variability')
                    additional_settings.calculate_roi_variability = 0;
                end
                if ~isfield(h.additional_settings,'modulate_hue_with_white')
                    additional_settings.modulate_hue_with_white = 0;
                end
            end
        else
            % these are default values tested on my computer
            q = get_default_settings;
            additional_settings = q;       
        end
    end
    s.additional_settings = additional_settings;
    
    % additional settings (implemented in version 03-09-2012)
    global correction_settings;
    if strcmp(name,'nanosimsini')       
        if isfield(h,'correction_settings')
            correction_settings = h.correction_settings;
            if isempty(correction_settings)
                % these are default values tested on my computer
                q = get_default_correction_settings;                
                correction_settings = q;
            else
                if ~isfield(h.correction_settings,'correction_apply')
                    correction_settings.correction_apply = zeros(1,6);
                end
                if ~isfield(h.correction_settings,'correction_classes')
                    correction_settings.correction_classes = 'xxxxxx';
                end
                if ~isfield(h.correction_settings,'correction_values')
                    correction_settings.correction_values = [0.0106 0.0037 1 1 1 1];
                end
                if ~isfield(h.correction_settings,'calculate_rate')
                    correction_settings.calculate_rate = zeros(1,6);
                end
                if ~isfield(h.correction_settings,'medium_value')
                    correction_settings.medium_value = {[1 1], [1 1], [1 1], [1 1], [1 1], [1 1]};
                end
                if ~isfield(h.correction_settings,'treatments')
                    correction_settings.treatments = [1 2];
                end
                if ~isfield(h.correction_settings,'incubation_times')
                    correction_settings.incubation_times = [1 1];
                end
            end
        else
            % these are default values tested on my computer
            q = get_default_correction_settings;                
            correction_settings = q;
        end
    end
    s.correction_settings = correction_settings;
                
    display_message(sprintf('Preferences loaded from %s\n',fname));

    % This was wrong! Don't do any overwriting of these local settings
%     if isfield(h,'PDF_VIEWER')
%         global PDF_VIEWER
%         PDF_VIEWER = h.PDF_VIEWER;
%         fprintf(1,'PDF_VIEWER overwritten by the value from %s\n',fname);
%     end
%     
%     if isfield(h,'UNZIP_COMMAND')
%         global UNZIP_COMMAND
%         UNZIP_COMMAND = h.UNZIP_COMMAND;
%         fprintf(1,'UNZIP_COMMAND overwritten by the value from %s\n',fname);
%     end

else
    
    display_message('Preferences could not be loaded.\n');

end

function q = get_default_settings
if isunix
    q.print_factors = [0.9 1 3 1 4 1.2 1];
else
    q.print_factors = [2.5 3 3 2.5 4 3 1];
end               
q.scale_bar_pos = 1;
q.color_bar_pos = 2;
q.export_png = 0;
q.export_eps = 0;
q.export_tif = 0;
q.compress_pdf = 1;            
q.always_display_rois = 0;
q.title_length = 40;
q.defFontSize = 12;
q.include_scale_text = 1;
q.scale_bar_length = 3;
q.autoscale_quantiles = [0.001 0.999];    
q.display_error_bars = 1;
q.display_trend_lines = 1;
q.colormap = 1;
q.view_pdf = 0;
q.apply_1e3_factor = 0;
q.include_colorbar_label = 1;
q.smooth_masses_kernelsize = [5 1];
q.smooth_esi_kernelsize = [1 1];
q.title_position = 0;
q.fill_title_background = 0;
q.title_background_color = 'w';
q.title_font_size_color = '14k';  
q.calculate_LWfactor = 1;
q.calculate_perimeter = 0;
q.calculate_perimeter = 0;
q.calculate_roi_variability = 0;
q.modulate_hue_with_white = 0;
q.shift_columns_rows = [0 0 0 0];

function q = get_default_correction_settings
q.correction_apply = zeros(1,6);
q.correction_classes = 'xxxxxx';
q.correction_values = [0.0106 0.0037 1 1 1 1];
q.calculate_rate = zeros(1,6);
q.medium_value = {[1 1], [1 1], [1 1], [1 1], [1 1], [1 1]};
q.treatments = [1 2];
q.incubation_times = [1 1];
