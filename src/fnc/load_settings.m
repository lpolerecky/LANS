function s=load_settings(s,fname,fig_pos_flag)

if(nargin>2)
    fpf=fig_pos_flag;
else
    fpf = 1;
end;

%% load the last saved preferences from the ini file and fill the GUI objects and other flags
h=[];
if(exist(fname)==2)
    load(fname);
    [pathstr, name, ext] = fileparts(fname);
    if strcmp(name,'nanosimsini')
        set(s.edit1,'string',h.edit1.string);
        set(s.edit2,'string',h.edit2.string);
    end;    
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
        if(b1a & b1b)
            % in earlier versions of LANS, smoothing kernel was a 2x1 vector,
            % but now it's only a number. so correct this when loading the
            % preferences
            if ii==32
                eval(['sk=' es2 ';']);
                sk=str2num(sk);
                if length(sk)>1
                    sk=sk(1);
                end;
                eval([es2 ' = num2str(sk);']);
            end;
            eval(b2);
        end;
    end;
    
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
        if(b1a & b1b)
            eval(b2);
        end;
    end;
    
    if(isfield(h,'figureposition') & fpf)
        fp=get(s.figure1,'Position');
        fp1 = h.figureposition;
        set(s.figure1,'Position',[fp1(1:2) fp(3:4)]);
    end;
 
    % dead-time-correction structure
    if isfield(h,'dtc')
        s.dtc = h.dtc;
    else
        ones = [1 1 1 1 1 1 1];
        d.dt = 44*ones; % dead-time, in ns
        d.y  = 1*ones; % yield
        d.bkg = 0*ones; % in counts/second
        d.dwelling_time = 1; % dwelling time, in ms
        d.apply_dtc = 0; % apply dead-time correction
        d.apply_QSA = 0; % apply QSA correction
        d.K = 0*ones;
        s.dtc = d;        
    end;    
    if ~isfield(s.dtc,'apply_QSA')
        s.dtc.apply_QSA = 0;
    end;
    if ~isfield(s.dtc,'K')
        s.dtc.K=0*ones;
    end;
    
    % shift_columns_rows flags
    if isfield(h,'shift_columns_rows')
        s.shift_columns_rows = h.shift_columns_rows;
        %fprintf(1,'Flags for shifting columns and rows set to [%d %d %d %d]\n',s.shift_columns_rows);
    else
        s.shift_columns_rows = [0 0 0 0];
    end;
    
    % additional settings (implemented in version 03-09-2012)
    global additional_settings;
    if strcmp(name,'nanosimsini')       
        if isfield(h,'additional_settings')
            additional_settings = h.additional_settings;
            if isempty(additional_settings)
                % these are default values tested on my computer
                if isunix
                    q.print_factors = [0.9 1 3 1 4 1.2 1];
                else
                    q.print_factors = [2.5 3 3 2.5 4 3 1];
                end;                
                q.scale_bar_pos = 1;
                q.color_bar_pos = 2;
                q.export_png = 0;
                q.export_eps = 0;
                q.export_tif = 0;
                q.compress_pdf = 1;            
                q.always_display_rois = 0;
                q.title_length = 40;
                q.defFontSize = 16;
                q.include_scale_text = 1;
                q.scale_bar_length = 3;
                q.autoscale_quantiles = [0.001 0.999];                    
                additional_settings = q;
            else
                if length(additional_settings.print_factors)<6
                    additional_settings.print_factors(6)=1;
                end;
                if length(additional_settings.print_factors)<7
                    additional_settings.print_factors(7)=1;
                end;
                if ~isfield(h.additional_settings,'export_png')
                    additional_settings.export_png = 0;
                end;
                if ~isfield(h.additional_settings,'export_eps')
                    additional_settings.export_eps = 0;
                end;
                if ~isfield(h.additional_settings,'export_tif')
                    additional_settings.export_tif = 0;
                end;
                if ~isfield(h.additional_settings,'compress_pdf')
                    additional_settings.compress_pdf = 0;
                end;
                if ~isfield(h.additional_settings,'always_display_rois')
                    additional_settings.always_display_rois = 0;
                end;
                if ~isfield(h.additional_settings,'title_length')
                    additional_settings.title_length = 40;
                end;
                if ~isfield(h.additional_settings,'defFontSize')
                    additional_settings.defFontSize = 16;
                end;
                if ~isfield(h.additional_settings,'include_scale_text')
                    additional_settings.include_scale_text = 1;
                end;
                if ~isfield(h.additional_settings,'scale_bar_length')
                    additional_settings.scale_bar_length = 3;
                end;
                if ~isfield(h.additional_settings,'autoscale_quantiles')
                    additional_settings.autoscale_quantiles = [0.001 0.999];
                end;
            end;
        else
            % these are default values tested on my computer
            if isunix
                q.print_factors = [0.9 1 3 1 4 1.2 1];
            else
                q.print_factors = [2.5 3 3 2.5 4 3 1];
            end;
            q.scale_bar_pos = 1;
            q.color_bar_pos = 2;
            q.export_png = 0;
            q.export_eps = 0;
            q.export_tif = 0;
            q.compress_pdf = 1;            
            q.always_display_rois = 0;
            q.title_length = 40;
            q.defFontSize = 16;
            q.include_scale_text = 1;
            q.scale_bar_length = 3;
            q.autoscale_quantiles = [0.001 0.999];
            additional_settings = q;
        end;
    end;
    s.additional_settings = additional_settings;
    
    disp(['Preferences loaded from ',fname]);
else
    disp(['Preferences could not be loaded.']);
end;
