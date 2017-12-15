function varargout = additional_settings_gui(varargin)
% ADDITIONAL_SETTINGS_GUI MATLAB code for additional_settings_gui.fig
%      ADDITIONAL_SETTINGS_GUI, by itself, creates a new ADDITIONAL_SETTINGS_GUI or raises the existing
%      singleton*.
%
%      H = ADDITIONAL_SETTINGS_GUI returns the handle to a new ADDITIONAL_SETTINGS_GUI or the handle to
%      the existing singleton*.
%
%      ADDITIONAL_SETTINGS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADDITIONAL_SETTINGS_GUI.M with the given input arguments.
%
%      ADDITIONAL_SETTINGS_GUI('Property','Value',...) creates a new ADDITIONAL_SETTINGS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before additional_settings_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to additional_settings_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help additional_settings_gui

% Last Modified by GUIDE v2.5 03-Sep-2012 13:37:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @additional_settings_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @additional_settings_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before additional_settings_gui is made visible.
function additional_settings_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to additional_settings_gui (see VARARGIN)

global additional_settings;
handles.additional_settings = additional_settings;
% handles.additional_settings_orig = d;

fill_objects(handles);
set(handles.figure1,'Name','Additional Look@NanoSIMS settings');

% Choose default command line output for additional_settings_gui
handles.output = handles.additional_settings;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
%set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes additional_settings_gui wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = additional_settings_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
%%delete(handles.figure1);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = get_values(handles);
handles.output = handles.additional_settings;

global additional_settings;
additional_settings = handles.additional_settings;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
%uiresume(handles.figure1);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles.output = handles.additional_settings_orig;

% Update handles structure
%guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
%uiresume(handles.figure1);
figure1_CloseRequestFcn(handles.figure1, eventdata, handles);

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    %handles.output = handles.additional_settings_orig;
    
    % Update handles structure
    guidata(hObject, handles);
    
    %uiresume(handles.figure1);
    figure1_CloseRequestFcn(handles.figure1, eventdata, handles);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    %uiresume(handles.figure1);
    figure1_CloseRequestFcn(handles.figure1, eventdata, handles);
end    

function fill_objects(h)
switch h.additional_settings.scale_bar_pos
    case 1, set(h.radiobutton1,'value',1);
    case 2, set(h.radiobutton2,'value',1);
    case 3, set(h.radiobutton3,'value',1);
    case 4, set(h.radiobutton4,'value',1);
    case 0, set(h.radiobutton5,'value',1);
end;
switch h.additional_settings.color_bar_pos
    case 1, set(h.radiobutton6,'value',1);
    case 2, set(h.radiobutton7,'value',1);
    case 0, set(h.radiobutton8,'value',1);
end;
set(h.edit1,'String',sprintf('%.2f',h.additional_settings.print_factors(1)));
set(h.edit2,'String',sprintf('%.2f',h.additional_settings.print_factors(2)));
set(h.edit3,'String',sprintf('%.2f',h.additional_settings.print_factors(3)));
set(h.edit4,'String',sprintf('%.2f',h.additional_settings.print_factors(4)));
set(h.edit5,'String',sprintf('%.2f',h.additional_settings.print_factors(5)));
set(h.edit6,'String',sprintf('%.2f',h.additional_settings.print_factors(6)));
if isfield(h,'edit7')
    set(h.edit7,'String',sprintf('%.2f',h.additional_settings.print_factors(7)));
end;
if isfield(h.additional_settings,'export_png')
    set(h.checkbox1,'value',h.additional_settings.export_png);
end;
set(h.checkbox2,'value',h.additional_settings.always_display_rois);
if isfield(h.additional_settings,'export_eps')
    set(h.checkbox3,'value',h.additional_settings.export_eps);
end;
if isfield(h.additional_settings,'export_tif')
    set(h.checkbox4,'value',h.additional_settings.export_tif);
end;
if isfield(h.additional_settings,'compress_pdf')
    set(h.checkbox5,'value',h.additional_settings.compress_pdf);
end;
if isfield(h.additional_settings,'title_length')
    set(h.edit8,'string', num2str(h.additional_settings.title_length));
end;
if isfield(h.additional_settings,'defFontSize')
    set(h.edit9,'string', num2str(h.additional_settings.defFontSize));
end;
if isfield(h.additional_settings,'include_scale_text')
    set(h.checkbox6,'value',h.additional_settings.include_scale_text);
end;
if isfield(h.additional_settings,'scale_bar_length')
    set(h.edit10,'String',num2str(h.additional_settings.scale_bar_length));
end;
if isfield(h.additional_settings,'autoscale_quantiles')
    set(h.edit11,'String',num2str(h.additional_settings.autoscale_quantiles(1)));
    set(h.edit12,'String',num2str(h.additional_settings.autoscale_quantiles(2)));    
end;
if isfield(h.additional_settings,'display_error_bars')
    set(h.checkbox10,'Value',h.additional_settings.display_error_bars);
end;
if isfield(h.additional_settings,'display_trend_lines')
    set(h.checkbox11,'Value',h.additional_settings.display_trend_lines);
end;
if isfield(h.additional_settings,'colormap')
    set(h.popupmenu1,'Value',h.additional_settings.colormap);
end;
if isfield(h.additional_settings,'view_pdf')
    set(h.checkbox15,'value',h.additional_settings.view_pdf);
end;
if isfield(h.additional_settings,'include_colorbar_label')
    set(h.checkbox17,'value',h.additional_settings.include_colorbar_label);
end;
if isfield(h.additional_settings,'apply_1e3_factor')
    set(h.checkbox14,'value',h.additional_settings.apply_1e3_factor);
end;
if isfield(h.additional_settings,'smooth_masses_kernelsize')
    set(h.edit15,'String',num2str(h.additional_settings.smooth_masses_kernelsize));
end;
switch h.additional_settings.title_position
    case 1, set(h.radiobutton11,'value',1);
    case 2, set(h.radiobutton12,'value',1);
    case 3, set(h.radiobutton13,'value',1);
    case 4, set(h.radiobutton14,'value',1);
    case 0, set(h.radiobutton15,'value',1);
end;
if isfield(h.additional_settings,'fill_title_background')
    set(h.checkbox12,'value',h.additional_settings.fill_title_background);
end;
if isfield(h.additional_settings,'title_background_color')
    set(h.edit13,'String',num2str(h.additional_settings.title_background_color));
end;
if isfield(h.additional_settings,'title_font_size_color')
    set(h.edit14,'String',num2str(h.additional_settings.title_font_size_color));
end;

function h=get_values(h)

d.print_factors = [str2num(get(h.edit1,'String')), ...
    str2num(get(h.edit2,'String')), ...
    str2num(get(h.edit3,'String')), ...
    str2num(get(h.edit4,'String')), ...
    str2num(get(h.edit5,'String')), ...
    str2num(get(h.edit6,'String'))];
if isfield(h,'edit7')
    d.print_factors = [d.print_factors, ...
        str2num(get(h.edit7,'String'))];
end;

if get(h.radiobutton1,'value')==1
    d.scale_bar_pos = 1;
elseif get(h.radiobutton2,'value')==1
    d.scale_bar_pos = 2;
elseif get(h.radiobutton3,'value')==1
    d.scale_bar_pos = 3;
elseif get(h.radiobutton4,'value')==1
    d.scale_bar_pos = 4;
elseif get(h.radiobutton5,'value')==1
    d.scale_bar_pos = 0;
else
    d.scale_bar_pos = 1;
end;

if get(h.radiobutton6,'value')==1
    d.color_bar_pos = 1;
elseif get(h.radiobutton7,'value')==1
    d.color_bar_pos = 2;
elseif get(h.radiobutton8,'value')==1
    d.color_bar_pos = 0;
else
    d.color_bar_pos = 1;
end;

if isfield(h,'checkbox1')
    d.export_png = get(h.checkbox1,'value');
else
    d.export_png = 0;
end;

if isfield(h,'checkbox3')
    d.export_eps = get(h.checkbox3,'value');
else
    d.export_eps = 0;
end;

if isfield(h,'checkbox4')
    d.export_tif = get(h.checkbox4,'value');
else
    d.export_tif = 0;
end;

if isfield(h,'checkbox5')
    d.compress_pdf = get(h.checkbox5,'value');
else
    d.compress_pdf = 0;
end;

if isfield(h,'checkbox2')
    d.always_display_rois = get(h.checkbox2,'value');
else
    d.always_display_rois = 0;
end;

if isfield(h,'edit8')
    d.title_length = str2num(get(h.edit8,'string'));
else
    d.title_length = 40;
end;

if isfield(h,'edit9')
    d.defFontSize = str2num(get(h.edit9,'string'));
else
    d.defFontSize = 12;
end;

if isfield(h,'checkbox6')
    d.include_scale_text = get(h.checkbox6,'value');
else
    d.include_scale_text = 0;
end;

if isfield(h,'edit10')
    d.scale_bar_length = str2num(get(h.edit10,'String'));
else
    d.scale_bar_length = 0;
end;

if isfield(h,'edit11')
    d.autoscale_quantiles(1) = str2num(get(h.edit11,'String'));
else
    d.autoscale_quantiles(1) = 0.001;
end;

if isfield(h,'edit12')
    d.autoscale_quantiles(2) = str2num(get(h.edit12,'String'));
else
    d.autoscale_quantiles(2) = 0.999;
end;

if isfield(h,'checkbox10')
    d.display_error_bars = get(h.checkbox10,'value');
else
    d.display_error_bars = 1;
end;

if isfield(h,'checkbox11')
    d.display_trend_lines = get(h.checkbox11,'value');
else
    d.display_trend_lines = 1;
end;

if isfield(h,'popupmenu1')
    d.colormap = get(h.popupmenu1,'value');
else
    d.colormap = 1;
end;

if isfield(h,'checkbox15')
    d.view_pdf = get(h.checkbox15,'value');
else
    d.view_pdf = 0;
end;

if isfield(h,'checkbox17')
    d.include_colorbar_label = get(h.checkbox17,'value');
else
    d.include_colorbar_label = 1;
end;

if isfield(h,'checkbox14')
    d.apply_1e3_factor = get(h.checkbox14,'value');
else
    d.apply_1e3_factor = 0;
end;

if isfield(h,'edit15')
    d.smooth_masses_kernelsize = str2num(get(h.edit15,'String'));
else
    d.smooth_masses_kernelsize = [5 1];
end;

if get(h.radiobutton11,'value')==1
    d.title_position = 1;
elseif get(h.radiobutton12,'value')==1
    d.title_position = 2;
elseif get(h.radiobutton13,'value')==1
    d.title_position = 3;
elseif get(h.radiobutton14,'value')==1
    d.title_position = 4;
elseif get(h.radiobutton15,'value')==1
    d.title_position = 0;
else
    d.title_position = 0;
end;

if isfield(h,'checkbox12')
    d.fill_title_background = get(h.checkbox12,'value');
else
    d.fill_title_background = 0;
end;

if isfield(h,'edit13')
    d.title_background_color = get(h.edit13,'String');
else
    d.title_background_color = 'w';
end;

if isfield(h,'edit14')
    d.title_font_size_color = get(h.edit14,'String');
else
    d.title_font_size_color = '14k';
end;

h.additional_settings = d;
fprintf(1,'Additional output settings updated.\n');


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
