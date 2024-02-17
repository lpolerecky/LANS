function save_settings(handles,fname)
% save preferences to a mat file for later use

% remember values in the edit-fields
for ii=1:76
    es=['edit' num2str(ii)];
    b1=['b1=isfield(handles,''',es,''');'];
    b2=['h.',es,'.string = get(handles.',es,',''string'');'];        
    eval(b1);
    if(b1)
        eval(b2);
    end
end

% remember values in the checkboxes
for ii=7:73
    es=['checkbox' num2str(ii)];
    b1=['b1=isfield(handles,''',es,''');'];
    b2=['h.',es,'.value = get(handles.',es,',''value'');'];        
    b3=['h.',es,'.value = 0;'];        
    eval(b1);
    if(b1)
        eval(b2);
    else
        eval(b3);
    end
end

% remember dead-time and QSA correction settings
if isfield(handles,'dtc')
    h.dtc = handles.dtc;
end

% remember additional settings for printing etc
global additional_settings;
h.additional_settings = additional_settings;

% remember correction & calculation settings
global correction_settings;
h.correction_settings = correction_settings;

%h.radiobutton1.value = get(handles.radiobutton1,'value');
%h.radiobutton2.value = get(handles.radiobutton2,'value');

% remember figure position
h.figureposition = get(handles.figure1,'Position');

% remember flags for shifting columns and rows
shift_columns_rows = [0 0 0 0];
if isfield(handles,'p')
    if isfield(handles.p,'shift_columns_rows')
        shift_columns_rows = handles.p.shift_columns_rows;
    %else
        %shift_columns_rows = get_shift_columns_rows(handles);
    end
    % remember masses and scaling (added 20-05-2021)
    if isfield(handles.p,'mass')
        mass = handles.p.mass;
    else
        mass = [];
    end
    if isfield(handles.p,'imscale_full')
        imscale_full = handles.p.imscale_full;
    else
        imscale_full = [];
    end
else
    %shift_columns_rows = get_shift_columns_rows(handles);    
    mass = [];
    imscale_full = [];
end

h.shift_columns_rows = shift_columns_rows;
h.mass = mass;
h.imscale_full = imscale_full;

% remember the raster size
if isfield(handles,'text46')
    h.raster_size = str2num(get(handles.text46,'string'));
else
    h.raster_size = 10;
end

% remember also PDF_VIEWER and UNZIP_COMMAND global variables
global UNZIP_COMMAND PDF_VIEWER
h.UNZIP_COMMAND = UNZIP_COMMAND;
h.PDF_VIEWER = PDF_VIEWER;

% save preferences
if(~isempty(fname))
    save(fname,'h','-v6');
    disp(['Preferences saved in ',fname]);
else
    disp('Preferences could not be saved.');
end

figure(handles.figure1);