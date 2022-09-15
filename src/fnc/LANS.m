function varargout = LANS(varargin)
% LANS M-file for LANS.fig
%      LANS, by itself, creates a new LANS or raises the existing
%      singleton*.
%
%      H = LANS returns the handle to a new LANS or the handle to
%      the existing singleton*.
%
%      LANS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LANS.M with the given input arguments.
%
%      LANS('Property','Value',...) creates a new LANS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LANS_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LANS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LANS

% Last Modified by GUIDE v2.5 09-Jul-2010 12:00:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LANS_OpeningFcn, ...
                   'gui_OutputFcn',  @LANS_OutputFcn, ...
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


% --- Executes just before LANS is made visible.
function LANS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LANS (see VARARGIN)

global LANS_version;

set(handles.figure1,'Name',['Look@NanoSIMS (version ',LANS_version,')'])
fp=get(handles.figure1,'Position');

h = load_settings(handles,get_ini_file('r'));
handles.dtc = h.dtc;

log_user_info('start');

% Choose default command line output for LookAtNanoSIMS
handles.output = hObject;

set(handles.checkbox63,'TooltipString',...
    sprintf('Check if you want to modify the intensity of the hue in the ratio images.\nHI=intensity of the displayed ratio''s hue.'));
set(handles.edit65,'TooltipString',...
    sprintf('If empty, HI is calculated from the denominator in the ratio expression.\nAlternatively, use ID of one of the loaded masses (1-8) to calculate HI from it.\nHI is calculated as HI=(mass-min)/(max-min), and set to 1 when mass>max and to 0 when mass<min.\nThus, you can modify HI by modifying the scale of the corresponding mass.'));

handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LANS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LANS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function quitprogram_Callback(hObject,eventdata,handles)
figure1_CloseRequestFcn(hObject, eventdata, handles);
delete(handles.figure1);

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



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double
mass_edit_action(hObject,handles,3);

% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double
mass_edit_action(hObject,handles,4);

% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double
mass_edit_action(hObject,handles,5);

% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double
mass_edit_action(hObject,handles,6);

% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double
mass_edit_action(hObject,handles,7);

function edit76_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double
mass_edit_action(hObject,handles,8);

% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit76_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit71_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit72_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit73_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit75_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox14.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in checkbox21.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes on button press in checkbox22.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in checkbox17.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox18.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on button press in checkbox13.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox36.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox36


% --- Executes on button press in checkbox45.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox45


% --- Executes on button press in checkbox46.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox46


% --- Executes on button press in checkbox47.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox47


% --- Executes on button press in checkbox48.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox48


% --- Executes on button press in checkbox7.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox11.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit32_Callback(hObject, eventdata, handles)

function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double
special_edit_action(hObject,handles,1);

% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double
special_edit_action(hObject,handles,2);

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit70_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double
special_edit_action(hObject,handles,5);

function edit71_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double
special_edit_action(hObject,handles,6);

function edit72_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double
special_edit_action(hObject,handles,7);

function edit73_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double
special_edit_action(hObject,handles,8);


function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double
special_edit_action(hObject,handles,3);

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double
special_edit_action(hObject,handles,4);

% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox21.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes on button press in checkbox22.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes on button press in checkbox18.
function checkbox18_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox18


% --- Executes on button press in checkbox13.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox36.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox36


% --- Executes on button press in checkbox52.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox52


% --- Executes on button press in checkbox53.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox53



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double


% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit54_Callback(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit54 as text
%        str2double(get(hObject,'String')) returns contents of edit54 as a double


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit55_Callback(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit55 as text
%        str2double(get(hObject,'String')) returns contents of edit55 as a double


% --- Executes during object creation, after setting all properties.
function edit55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit56_Callback(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit56 as text
%        str2double(get(hObject,'String')) returns contents of edit56 as a double
special_edit_action(hObject,handles,5);

% --- Executes during object creation, after setting all properties.
function edit56_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit57_Callback(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit57 as text
%        str2double(get(hObject,'String')) returns contents of edit57 as a double
special_edit_action(hObject,handles,6);

% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox23.
function checkbox23_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox23


% --- Executes on button press in checkbox24.
function checkbox24_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox24


% --- Executes on button press in checkbox45.
function checkbox45_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox45


% --- Executes on button press in checkbox46.
function checkbox46_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox46


% --- Executes on button press in checkbox47.
function checkbox47_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox47


% --- Executes on button press in checkbox48.
function checkbox48_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox48



function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit58 as text
%        str2double(get(hObject,'String')) returns contents of edit58 as a double
special_edit_action(hObject,handles,7);

% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox7.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox11.
function checkbox30_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox12.
function checkbox31_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox13.
function checkbox32_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox36.
function checkbox36_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox36


% --- Executes on button press in checkbox52.
function checkbox52_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox52


% --- Executes on button press in checkbox53.
function checkbox53_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox53



function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double


% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit60_Callback(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit60 as text
%        str2double(get(hObject,'String')) returns contents of edit60 as a double


% --- Executes during object creation, after setting all properties.
function edit60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit61_Callback(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit61 as text
%        str2double(get(hObject,'String')) returns contents of edit61 as a double


% --- Executes during object creation, after setting all properties.
function edit61_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit62_Callback(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit62 as text
%        str2double(get(hObject,'String')) returns contents of edit62 as a double


% --- Executes during object creation, after setting all properties.
function edit62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit63_Callback(hObject, eventdata, handles)
% hObject    handle to edit63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit63 as text
%        str2double(get(hObject,'String')) returns contents of edit63 as a double


% --- Executes during object creation, after setting all properties.
function edit63_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox54.
function checkbox54_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox54


% --- Executes on button press in checkbox55.
function checkbox55_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox55


% --- Executes on button press in checkbox56.
function checkbox56_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox56


% --------------------------------------------------------------------
function ACTION_Callback(hObject, eventdata, handles)
% hObject    handle to ACTION (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function ask_for_range_Callback(hObject, eventdata, handles)
if(strcmp(get(handles.ask_for_range,'checked'),'off'))
    set(handles.ask_for_range,'checked','on');
else
    set(handles.ask_for_range,'checked','off');
end

function shift_columns_rows_Callback(hObject, eventdata, handles)
global shift_first_column_end shift_last_column_beginning
global shift_first_row_end shift_last_row_beginning
if hObject==handles.shift_first_column_end    
    if(strcmp(get(handles.shift_first_column_end,'checked'),'off'))
        set(handles.shift_first_column_end,'checked','on');
        shift_first_column_end=1;
    else
        set(handles.shift_first_column_end,'checked','off');
        shift_first_column_end=0;
    end
end
if hObject==handles.shift_last_column_beginning
    if(strcmp(get(handles.shift_last_column_beginning,'checked'),'off'))
        set(handles.shift_last_column_beginning,'checked','on');
        shift_last_column_beginning=1;
    else
        set(handles.shift_last_column_beginning,'checked','off');
        shift_last_column_beginning=0;
    end
end
if hObject==handles.shift_first_row_end    
    if(strcmp(get(handles.shift_first_row_end,'checked'),'off'))
        set(handles.shift_first_row_end,'checked','on');
        shift_first_row_end=1;
    else
        set(handles.shift_first_row_end,'checked','off');
        shift_first_row_end=0;
    end
end
if hObject==handles.shift_last_row_beginning
    if(strcmp(get(handles.shift_last_row_beginning,'checked'),'off'))
        set(handles.shift_last_row_beginning,'checked','on');
        shift_last_row_beginning=1;
    else
        set(handles.shift_last_row_beginning,'checked','off');
        shift_last_row_beginning=0;
    end
end
fprintf(1,'Current settings for shifts during loading: [%d %d %d %d]\n',...
    fliplr(get_shift_columns_rows(handles)));
guidata(hObject, handles);

function generate_fake_cameca_Callback(hObject, eventdata, handles)
create_fake_file_gui('workdir',get(handles.edit1,'String'));

function load_cameca_image_Callback(hObject, eventdata, handles)
handles = load_cameca_image(handles);
handles = shift_columns_rows(handles);
guidata(hObject, handles);

function load_cameca_as_blocks_Callback(hObject, eventdata, handles)
handles=load_cameca_image_as_blocks(handles);
handles = shift_columns_rows(handles);
guidata(hObject, handles);

function load_processed_image_Callback(hObject, eventdata, handles)
handles = load_cameca_image(handles);
h = Load_Display_Preferences_Callback(hObject, eventdata, handles);
% LP: added 21-05-2021 (next 2 lines)
if isfield(h,'mass'), handles.p.mass = h.mass; end
if isfield(h,'imscale_full'), handles.p.imscale_full = h.imscale_full; end
handles = shift_columns_rows(handles,h.shift_columns_rows);
handles = accumulate_images_Callback(hObject, eventdata, handles);
display_all_masses_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
figure(handles.figure1);
a=0;

% --------------------------------------------------------------------
function show_all_masses_planes_Callback(hObject, eventdata, handles)
% hObject    handle to show_all_masses_planes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = load_masses_parameters(handles);
if p.planes_aligned
    fprintf(1,'Showing aligned masses\n');
else
    fprintf(1,'Showing non-aligned masses\n');
end
show_stack_win6(handles.p.im,p.imscale,p.mass,p.fdir,'m');

% --------------------------------------------------------------------
function show_alignment_mass_Callback(hObject, eventdata, handles)
% hObject    handle to show_alignment_mass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = show_alignment_mass(handles);    
guidata(hObject, handles);

% --------------------------------------------------------------------
function out=accumulate_images_Callback(hObject, eventdata, handles)
% hObject    handle to accumulate_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = load_masses_parameters(handles);
if ~isfolder(p.fdir)
    mkdir(p.fdir);
    fprintf(1,'Output directory %s created.\n',p.fdir);
end

%% fill the image (r) based on which the alignment will be found
[formula, ~, ~] = parse_formula_lans(p.alignment_mass,p.mass);
m=cell(size(p.im));
for mi=1:length(m)
    m{mi} = double(p.im{mi});
end
eval(formula);

xyalign = [];
tforms = [];
choice = 'Reject';

%% find alignments if requested, but only if p.im was not yet aligned 
if p.find_alignments && ~p.planes_aligned
    
    % default file containing the alignment info
    aname=[p.fdir,'xyalign.mat'];
            
    %% load alignment info from disk, if it exists
    if exist(aname)==2        
        a=load(aname);
        disp(['XY-alignment loaded from ',aname]);
        if isfield(a,'xyalign')
            p.xyalign = a.xyalign;
            xyalign = p.xyalign;
        end
        if isfield(a,'tforms')
            p.tforms = a.tforms;
            tforms = p.tforms;
        end
        
        % display xy-alignment data loaded from the file
        if isempty(p.images{1})
            xyplanes=[1:size(p.xyalign,1)]';
        else
            xyplanes=p.images{1};
        end
        f40=figure(40); subplot(1,1,1);
        plot(xyplanes, p.xyalign(xyplanes,1:2), 'x-');
        xlabel('plane');
        title('Alignment coordinates')
        ylabel('x and y (pix)');
        legend('x','y');
    
    else
        
        %% perform alignment using either old or new algorithm
        align_method = questdlg('Which algorithm do you want to use to align images? Old=correlation-based, New=registration-based.',...
            'LANS input', 'Old', 'New', 'Old');
        
        switch align_method
            case 'Old'                
                % old method of alignment (prior to 04-06-2018)
                [xyalign, images, f40, choice] = findimagealignments(r, ...
                    p.images{1}, p.alignment_image,...
                    p.alignmentregion_x, p.alignmentregion_y, p.maxalignment);
                tforms = [];
            case 'New'
                % new alignment method (from 04-06-2018)
                [tforms, images, xyalign, f40, choice] = findimagealignments2(r, ...
                    p.images{1}, ...
                    p.alignmentregion_x, p.alignmentregion_y);
        end                
                
        switch choice
            case 'Apply'
                % update p structure
                p.xyalign = xyalign;
                for ii=1:length(p.images)
                    p.images{ii} = images;
                end
                switch align_method
                    case 'Old'
                        save(aname,'xyalign','-v6')
                        fprintf(1,'XY-alignment saved as %s\n',aname);
                    case 'New'
                        save(aname,'tforms','xyalign','-v6');
                        fprintf(1,'Tforms of plane alignment saved as %s\n',aname);
                        p.tforms = tforms;
                end
                % update the images fields in the GUI
                handles = fillinfo_selected_images(images, handles);                  
                % export it as png
                oname=[p.fdir,'xyalign.png'];
                print(f40,oname,'-dpng');
                fprintf(1,'Alignment exported as %s\n',oname);
            case 'Reject'
                tforms = [];
                xyalign = [];
                fprintf(1,'%s selected. Planes were not accumulated.\n',choice);
        end
        
    end 
    
elseif ~p.find_alignments && ~p.planes_aligned
    %% if no algnment requested
    % if the planes were not yet aligned and accumulated, but there is no
    % desire to align them before accumulation, set the xyalign to zeros.
    % this will force the accumulation to be performed without alignment.
    xyalign = zeros(length(p.planes),2);
end

%% load options 
% to get the status of the checkboxes
[opt1,opt3,opt4]=load_options(handles, 1);

%% align and accumulate masses
% if they were not aligned and accumulated yet
if ~p.planes_aligned && ~isempty(xyalign)
    error_occurred = 0;
         
    if isempty(tforms)
        %% old algorithm
        [p.accu_im, p.im]=accumulate_images(p.im, xyalign, p.mass, p.images, opt4);
    else
        %% new algorithm
        [p.accu_im, p.im, error_occurred]=accumulate_images2(p.im, tforms, p.mass, p.images, opt4);
    end
    if ~error_occurred
        p.planes_aligned = 1;
    end
else
    if p.planes_aligned
        opts = struct('WindowStyle','modal', 'Interpreter','none');
        tit = {'Planes were aligned already. If you want to re-align and re-accumulate',...
            'them, you must first re-load the im file from disk, and possibly also',...
            'remove the xyalign.mat file (see Preferences menu).'};
        edl = warndlg(tit,'Warning',opts);
    end
    if isempty(xyalign) && ~strcmp(choice,'Reject')
        fprintf(1,'*** WARNING: xyalign empty.\n');
    end
end

handles.p = p;
guidata(hObject, handles);
out=handles;
pause(0.1);
figure(handles.figure1);

function accu_resize_Callback(hObject, eventdata, handles)

global additional_settings;
p=handles.p;
nmasses = length(p.mass);
nscales = length(p.imscale);

if ~p.planes_aligned 
    warndlg('Please first align and accumulate the mass images.','Warning','modal');
else  
    % IMPORTANT: Resizing of the images will be done using the nearest
    % method. This is to ensure that no modification of the data occurs if
    % the image is enlarged and then shrunk back by the same factor. This
    % is true, however, only if the magnification factor is M or 1/M, where
    % M is integer. This is why there needs to be (enforced) restriction on M.
    x=inputdlg('Specify magnification factor, M. To enlarge the image, use M>1, where M must be integer. To shrink the image, use M<1, where 1/M must be integer.','LANS input',1,{'1'});
    mf = 1;
    if ~isempty(x)
        mf = str2num(cell2mat(x));
        if isempty(mf) % if x was not a number
            mf = 1;
        end
    end
    % ensure that M is integer (if M>1) or that 1/M is integer (if M<1)
    if mf>1
        mf = round(mf);
    else
        mf = 1/round(1/mf);
    end
    
    fprintf(1,'Using magnification factor %.1f\n',mf);
    
    if mf~=1
        
        x=questdlg(sprintf('You are about to modify the resolution of the ion count and ROI images by a factor %.1f. Do you want to continue?',mf),'LANS input','Yes','No','No');
        
        if strcmp(x,'Yes')
            % BEWARE: here the actual data is changed!
            for i=1:length(p.im) % do this only for the measured ion count images, not for the (potentially loaded) external image
                a = imresize(p.accu_im{i},mf,'method','nearest');
                p.accu_im{i} = a/(mf^2);
            end
        
            msg1 = sprintf('Images resized by a factor %.1f using the NEAREST method.',mf);
            msg2 = sprintf('1. This also changed the ion counts by a factor %.2f. You may need to change the scale of the images to display them properly.',mf^2);
            msg3 = '2. Additionally, you may need to update the ROI image by reloading it from disk to account for this change in resolution.';
            warndlg({msg1,msg2,msg3},'LANS warning','modal');
        
            % resize also Maskimg, or create a new one if it does not exist
            %if isfield(p,'Maskimg')
            %    if sum(size(p.Maskimg)==size(p.accu_im{1}))<1
            %        p.Maskimg = imresize(p.Maskimg,mf,'method','nearest');
            %    end
            %else
            %    p.Maskimg = zeros(size(p.accu_im{1}));
            %end
        
            % remember the magnification factor
            p.mag_factor = mf;

            handles.p = p;
            guidata(hObject, handles);
        end
        
    else
        p.mag_factor = 1;
        handles.p = p;
        guidata(hObject, handles);
    end
end
    
% --------------------------------------------------------------------
function display_all_masses_Callback(hObject, eventdata, handles)
% hObject    handle to display_all_masses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.p = load_masses_parameters(handles);
display_all_masses(handles);
figure(handles.figure1);

function display_xyz_stacks_Callback(hObject, eventdata, handles)
% hObject    handle to display_all_masses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

p = load_masses_parameters(handles);
masses = p.mass;
imagestacks = p.im;
planes = p.planes;
fname = p.filename;
xyz_stack_control_gui(masses, imagestacks, planes, fname);

% --------------------------------------------------------------------
function h=Load_Display_Preferences_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Display_Preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = [];
workdir=get(handles.edit2,'String');
workdir=fixdir(workdir);
if(isdir(workdir))
    newdir=workdir;
else
    newdir='';
end;
global MAT_EXT
def_file = [workdir 'prefs' MAT_EXT];
fprintf(1,'Select the Preferences file (default %s)\n',def_file);

[FileName,newdir,newext] = uigetfile('*.mat', 'Select the Preferences file', def_file);
if(FileName~=0)
    imfile = [newdir, FileName];
    h = load_settings(handles,imfile,0);
end;

% --------------------------------------------------------------------
function define_mask_Callback(hObject, eventdata, handles)
% hObject    handle to define_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function define_external_image_Callback(hObject, eventdata, handles)
% hObject    handle to display_raw_mask_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = load_masses_parameters(handles);
ext_im=define_external_image(p);
% convert to gray. in the future one may want to think of using all 3 rgb
% channels as ext1, ext2 and ext3 "masses", but for now we keep it as a
% gray-scale image only
if size(ext_im,3)>1
    ext_im = rgb2gray(ext_im);
    fprintf(1,'WARNING: External image was converted from RGB to gray scale.\n');
end
if ~isempty(ext_im)
    [formula pois mass_index]=parse_formula_lans('ext',p.mass);
    if mass_index>length(p.mass)
        warndlg('External image added to the list of masses. You can now use it as EXT in any of the expressions.','For your information','modal');
    else
        warndlg('External image replaced. You may want to recalculate ratios or reexport overlays.','For your information','modal');
    end
    % add external image to the list of masses
    p.mass{mass_index} = 'ext';        
    p.imscale{mass_index} = find_image_scale(ext_im, 0);
    p.accu_im{mass_index} = ext_im;
    a = zeros(size(ext_im,1),size(ext_im,2),size(p.im{1},3));
    for i=1:size(a,3)
        a(:,:,i)=ext_im(:,:,1);
    end;
    p.im{mass_index}=a;
    p.images{mass_index} = p.images{1};
    p.ext_im = ext_im;
else
    % if empty ext_im, remove it from the list of masses, if it exists
    [formula pois mass_index]=parse_formula_lans('ext',p.mass);
    if mass_index>1
        p.mass = {p.mass{1:mass_index-1}};
        p.imscale = {p.imscale{1:mass_index-1}};
        p.accu_im = {p.accu_im{1:mass_index-1}};
        p.im = {p.im{1:mass_index-1}};
        p.images = {p.images{1:mass_index-1}};
        if isfield(p,'ext_im')
            p = rmfield(p,'ext_im');
        end;
        warndlg('External image removed from the list of masses. You may no longer use EXT in your expressions or overlay it with masses/ratios.','For your information','modal');
    end
end
handles.p = p;
guidata(hObject, handles);

% --------------------------------------------------------------------
function display_raw_mask_image_Callback(hObject, eventdata, handles)
% hObject    handle to display_raw_mask_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.p.maskmass, handles.p.Maskimg,handles.p.Mask] = display_raw_mask_image(handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function auto_calculate_cells_Callback(hObject, eventdata, handles)
% hObject    handle to auto_calculate_cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.p.Maskimg = auto_calculate_mask(handles);  
guidata(hObject, handles);

% --------------------------------------------------------------------
function cells_definition_tool_Callback(hObject, eventdata, handles)
% hObject    handle to cells_definition_tool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'p')
    
    % select cells file, if previously defined, which will be updated by the
    % tool
    [Maskimg, cellname] = load_cells_from_disk(handles,1);
    
    if isempty(Maskimg)
        if isfield(handles.p,'Maskimg') 
            rmfield(handles.p,'Maskimg');
        end
    else
        handles.p.Maskimg = Maskimg;
    end
    
    guidata(hObject, handles);

    % select cell classification file, if previously defined, which will be
    % updated by the tool
    cellfile = select_classification_file(handles.p);

    % calculate the mask image
    [maskmass,maskimg,mass,ps,bw] = display_raw_mask_image(handles,0,cellname);

    if isfield(handles.p,'mag_factor')
        mag_factor = handles.p.mag_factor;
    else
        mag_factor = 1;
    end
    
    % start the GUI for interactive cell definition
    add_remove_cells_tool(maskmass, maskimg, mass, ps, handles.p.fdir,...
        my_get(handles.edit62,'string'), cellname, bw, cellfile, mag_factor);
        
    guidata(hObject, handles);

else
    
    fprintf(1,'*** WARNING: Nothing loaded, nothing done.\n');
    
end;

% --------------------------------------------------------------------
function load_cells_from_disk_Callback(hObject, eventdata, handles)
% hObject    handle to load_cells_from_disk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Maskimg = load_cells_from_disk(handles,1);
if isempty(Maskimg)
    if(isfield(handles.p,'Maskimg'))
        rmfield(handles.p,'Maskimg');
    end
else
    handles.p.Maskimg = Maskimg;
end

guidata(hObject, handles);
figure(handles.figure1)

% --------------------------------------------------------------------
function shift_cells_image_Callback(hObject, eventdata, handles)
% hObject    handle to shift_cells_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(get(handles.checkbox11,'value'))
    handles.p.Maskimg = shift_image(handles,handles.p.Maskimg);
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function classify_cells_Callback(hObject, eventdata, handles)
% hObject    handle to classify_cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function classify_cells_manually_Callback(hObject, eventdata, handles)
% hObject    handle to classify_cells_manually (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

manual_classification('base_dir',get(handles.edit2,'string'));

% --------------------------------------------------------------------
function classify_cells_automatically_Callback(hObject, eventdata, handles)
% hObject    handle to classify_cells_automatically (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

auto_classification('base_dir', fixdir(my_get(handles.edit2,'string')));

%classify_cells;

function check_consistency_Callback(hObject, eventdata, handles)
fprintf(1,'\nChecking consistency of the output data...\n');

p = load_masses_parameters(handles);
[opt1,opt3,opt4]=load_options(handles, 0);

fncells = select_classification_file(p);

[cidu,cc,cid,cnum,ss]=load_cell_classes(fncells);
if ~isempty(cnum)
    Ncells = max(cnum);
    fprintf(1,'Number of classified ROIs: %d\n',Ncells);
else
    fprintf(1,'*** Warning: cell classification file does not exist.\n');
    Ncells = [];
end;

datdir = [p.fdir,'dat',filesep];
if isdir(datdir)
    fprintf(1,'Checking data in directory %s\n',datdir);
    f = dir([datdir,'*.dac']);
    for ii=1:length(f)
        % load dac files and check for how many cells the data are exported
        % in each of them
        fname = [datdir f(ii).name];
        [val,r]=readdacfile(fname,-2,0);
        Ncells2 = max(val);
        fprintf(1,'%s: ',f(ii).name);
        if ~isempty(Ncells)
            if Ncells2~=Ncells
                fprintf(1,'*** number of cells (N=%d) differs! Please check.\n',Ncells2);
            else
                fprintf(1,'\t\t\tOK\n');
            end;
        else
            Ncells = Ncells2;
            fprintf(1,'number of cells = %d\n',Ncells);
        end;            
    end;
else
    fprintf(1,'*** Warning: directory %s does not exist. No data exported.\n',datdir);
end;
fprintf(1,'Done.\n');

% --------------------------------------------------------------------
function display_cells_image_Callback(hObject, eventdata, handles)
% hObject    handle to display_cells_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
if ~isfield(handles.p,'Maskimg')
    handles.p.Maskimg = zeros(size(p.im{1},1),size(p.im{1},2));
else
    global CELLSFILE MAT_EXT;
    handles.p.Maskimg = load_cells_from_disk(handles,0,[CELLSFILE MAT_EXT]);
end
guidata(hObject, handles);
display_detected_cells(handles);

% --------------------------------------------------------------------
function clear_mask_image_Callback(hObject, eventdata, handles)
% hObject    handle to clear_mask_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.p.Maskimg = zeros(size(handles.p.im{1},1),size(handles.p.im{1},2));
disp('Cells cleared. Cells saved on the disk were not affected.')
guidata(hObject, handles);

% --------------------------------------------------------------------
function GO_ON_Callback(hObject, eventdata, handles)
% hObject    handle to GO_ON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function display_masses_through_mask_Callback(hObject, eventdata, handles)
% hObject    handle to display_masses_through_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display_masses_through_mask(handles);

% --------------------------------------------------------------------
function overlay_mass_with_external_Callback(hObject, eventdata, handles)
% hObject    handle to display_masses_through_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.p,'ext_im')
    overlay_masses_with_external(handles,hObject);
else
    fprintf(1,'*** Error: external image not defined. Select it first.\n');
end;

% --------------------------------------------------------------------
function display_ratios_through_mask_Callback(hObject, eventdata, handles)
% hObject    handle to display_ratios_through_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display_ratios_through_mask(handles);

function display_ratios_each_plane_Callback(hObject, eventdata, handles)
display_ratios_each_plane(handles);

% --------------------------------------------------------------------
function generate_latex_output_Callback(hObject, eventdata, handles)
% hObject    handle to generate_latex_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

generate_latex(handles);

% --------------------------------------------------------------------
function Save_Display_Preferences_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Display_Preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

workdir=get(handles.edit2,'String');
workdir=fixdir(workdir);
if(isdir(workdir))
    newdir=workdir;
else
    newdir='';
end

def_file = [workdir 'prefs'];
fprintf(1,'Specify file name to store the preferences (default %s.mat)\n',def_file);

[FileName,newdir,newext] = uiputfile('*.mat', 'Select *.MAT file', def_file);
if(FileName~=0)
    imfile = [newdir, FileName];
    save_settings(handles,imfile);
end;

% --------------------------------------------------------------------
function close_all_figures_Callback(hObject, eventdata, handles)
% hObject    handle to close_all_figures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cc=get(0,'Children');
for ii=1:length(cc)
    if isempty(get(cc(ii),'Tag'))
        close(cc(ii));
    elseif ~isempty(strfind( get(cc(ii),'Tag'), 'fig_' ))
        close(cc(ii));
    end
end

% --------------------------------------------------------------------
function Postprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to Postprocessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function generate_processing_metafile_Callback(hObject, eventdata, handles)
% hObject    handle to generate_processing_metafile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

manual_metafiledef('base_dir',get(handles.edit1,'string'));

% --------------------------------------------------------------------
function plot_special_as_2D_3D_Callback(hObject, eventdata, handles)
% hObject    handle to plot_special_as_2D_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

process_metafile('base_dir',get(handles.edit1,'string'),...
    'include_outline',my_get(handles.checkbox12,'value'),...
    'outline_color', my_get(handles.edit62,'string'),...
    'zero_outside', my_get(handles.checkbox13,'value'),...
    'base_mass_for_alignment', my_get(handles.edit43,'string'),...
    'all_handles',handles);

% --------------------------------------------------------------------
function process_accumulated_data_Callback(hObject, eventdata, handles)
% hObject    handle to process_accumulated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=load_cameca_image(handles,2);
%h = Load_Display_Preferences_Callback(hObject, eventdata, handles);
%if ~isempty(handles.p.im)
%    handles.p.accu_im = handles.p.im;
%    handles.p.planes_aligned = 1;
display_all_masses_Callback(hObject, eventdata, handles);
%end;

guidata(hObject, handles);
a=0;

function process_full_processed_data_Callback(hObject, eventdata, handles)
% hObject    handle to process_accumulated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=load_cameca_image(handles,3);
display_all_masses_Callback(hObject, eventdata, handles);
guidata(hObject, handles);

function save_full_processed_data_Callback(hObject, eventdata, handles)
% hObject    handle to process_accumulated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'p')
    p=handles.p;
    outfname=[p.filename '.mat'];
    [FileName, fdir] = uiputfile({'*.mat', 'LANS processed file (*.mat)'}, ...
        'Specify LANS-generated data file', outfname);
    if prod(FileName ~= 0)
        outfname = [fdir FileName];
        fprintf(1,'Saving LANS-processed data to %s ... ', outfname);
        save(outfname, 'p');
        fprintf(1,'done\n');
    end
end

function save_processed_data_each_mass_Callback(hObject, eventdata, handles)
% hObject    handle to process_accumulated_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'p')
    p=handles.p;
    for ii=1:length(p.im)
        cnt = double(p.im{ii});
        outfname = [p.filename filesep 'mat' filesep p.mass{ii} '_cnt.mat'];
        a = fileparts(outfname);
        if ~isfolder(a)
            mkdir(a);
            fprintf(1,'Output folder created: %s\n', a);
        end        
        fprintf(1,'Exporting COUNTS for %s into %s ... ', p.mass{ii}, outfname);
        save(outfname, 'cnt');
        fprintf(1,'done\n');
    end
    if p.planes_aligned
        fprintf(1,'Note: individual planes WERE aligned.\n')
    else
        fprintf(1,'Note: individual planes WERE NOT aligned.\n')
    end
end

% --------------------------------------------------------------------
function aboutprogram_Callback(hObject, eventdata, handles)
% hObject    handle to aboutprogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global LANS_version;
about_window('string',my_get(handles.figure1,'Name'),...
    'written', ['written by Lubos Polerecky (MPI Bremen, 2008-2012)'],...
    'updates', ['updates by Lubos Polerecky (Utrecht University, 2013-' LANS_version(1:4) ')']);

function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double

mass_edit_action(hObject,handles,1);

% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double
mass_edit_action(hObject,handles,2);

% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox60_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox60


% --- Executes on button press in checkbox43.
function checkbox43_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox43


% --- Executes on button press in checkbox44.
function checkbox44_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox44




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% remove field p, which contains all the loaded images, because otherwise
% the ini file would be too big and contain unnecessary information
if(isfield(handles,'p'))
    handles = rmfield(handles,'p');
end
if(~isempty(handles))
    save_settings(handles,get_ini_file('w'));
end

log_user_info('quit');

disp('Good bye');

% Hint: delete(hObject) closes the figure
delete(hObject);


function autoscale_images_Callback(hObject, eventdata, handles)
% it is assumed that the im file was already read, so the variable
% handles.p.im is filled.

global additional_settings;

if ~isfield(handles,'p')
    fprintf(1,'*** Error: Load data first.\n');
else
    p = handles.p;    
    
    if hObject==handles.autoscale_images
        if isfield(p,'im')
            N=length(p.im);
            for ii=1:N
                tmp=p.im{ii};
                tmpscale = find_image_scale(double(tmp));
                imscale_full{ii}=tmpscale;
                % write this scale to the appropriate edit field
                if ii<8, k=ii+32; else, k=76; end
                if ii<=8
                    s=sprintf('set(handles.edit%d,''string'',''[%s %s]'');',...
                        k, num2str(tmpscale(1)), num2str(tmpscale(2)));
                    eval(s);
                end
            end
        else
            fprintf(1,'*** Warning: Masses not loaded. Cannot autoscale.\n');
        end
    end
    
    if hObject==handles.autoscale_accu_images
        if isfield(p,'accu_im')
            if isfield(p,'mag_factor')
                mf = p.mag_factor;
            else
                mf = 1;
            end
            % LP: 20-05-2021
            % N=min([8 length(p.accu_im)]);
            N=length(p.accu_im);
            for ii=1:N
                tmp=p.accu_im{ii};
                tmpscale = find_image_scale(double(tmp));
                if mf<=1 
                    tmpscale = round(tmpscale);
                    scale_format = '[%d %d]';
                else
                    scale_format = '[%.3f %.3f]';
                end
                imscale_full{ii}=tmpscale;
                % write this scale to the appropriate edit field
                if ii<8, k=ii+32; else, k=76; end
                scale_string = sprintf(scale_format,tmpscale);
                if ii<=8 
                    s=sprintf('set(handles.edit%d,''string'',''%s'');',...
                        k, scale_string);
                    eval(s);
                end
            end
        else
            fprintf(1,'*** Warning: Masses not accumulated. Cannot autoscale.\n');
        end
    end
    p.imscale_full = imscale_full;
    handles.p = p;
    guidata(hObject, handles);
    fprintf(1,'Done.\n');
end

function additional_settings_gui_Callback(hObject, eventdata, handles)
additional_settings_gui;

function dead_time_correction_Callback(hObject, eventdata, handles)
handles.dtc = dtc_gui(handles.dtc);
guidata(hObject, handles);

function align_external_template_Callback(hObject, eventdata, handles)
p = load_masses_parameters(handles);
if ~isfield(p,'mag_factor')
    p.mag_factor = 1;
end
if isfield(p,'fdir')
    align_exernal_nanosims(1, p.fdir, p.mag_factor);
else
    fprintf(1,'Error: File directory unknown. Please load and process a Cameca dataset first.\n');
end

function do_chain_analysis_Callback(hObject, eventdata, handles)
% this is where I need to change things to make the chain analysis going
% the following code was copied from above but will need modification
%p = load_masses_parameters(handles);
%handles=load_cameca_image_Callback(hObject, eventdata, handles);
%Load_Display_Preferences_Callback(hObject, eventdata, handles);
%handles=accumulate_images_Callback(hObject, eventdata, handles);
%%autoscale_images_Callback(hObject, eventdata, handles);
%display_all_masses_Callback(hObject, eventdata, handles);
%guidata(hObject, handles);
a=0;

function supervise_classify_Callback(hObject, eventdata, handles)
supervise_classify(handles);

function remove_xyalign_Callback(hObject, eventdata, handles)
if(isfield(handles,'p'))
    p = handles.p;
    fname = [p.fdir 'xyalign.mat'];
    [~, p2, ~] = fileparts(p.filename);
    if isfile(fname)
        a = questdlg(sprintf('Are you sure you want to remove the %s/xyalign.mat file from disk?',p2),...
            'Remove xyalign', 'Yes', 'No', 'Yes');
        switch a
            case 'Yes'
                delete(fname);
                fprintf(1,'File %s deleted.\n',fname);
            case 'No'
                fprintf(1,'Ok, I''ll keep it.\n');
        end
    else
        errordlg(sprintf('xyalign.mat not found in the %s subfolder. Nothing done.',p2),'File not found.');
    end
end

function remove_mat_folder_Callback(hObject, eventdata, handles)
if(isfield(handles,'p'))
    p = handles.p;
    fname = [p.fdir 'mat'];
    if isfolder(fname)
        a = questdlg(sprintf('Are you sure you want to remove the mat folder from disk?'),...
            'Remove mat folder', 'Yes', 'No', 'Yes');
        switch a
            case 'Yes'
                rmdir(fname,'s');
                fprintf(1,'Folder %s deleted.\n',fname);
            case 'No'
                fprintf(1,'Ok, I''ll keep it.\n');
        end
    else
        errordlg(sprintf('mat subfolder not found in %s.\nNothing done.',p.fdir),'Folder not found.');
    end
end

function backup_folder_Callback(hObject, eventdata, handles)
if(isfield(handles,'p'))
    p = handles.p;
    [p1, foldername]=fileparts(p.filename);
    bakname = [foldername '.zip'];
    if isfolder(p1)
        a = questdlg(sprintf('Are you sure you want to back up the processed data folder?'),...
            'Remove mat folder', 'Yes', 'No', 'Yes');
        switch a
            case 'Yes'
                global ZIP_COMMAND;
                % create the zip-command and execute it
                cmd = sprintf('!%s %s %s%s%s', ZIP_COMMAND, bakname, foldername, filesep, '*.*at');
                cdir=pwd;
                cd(p1);
                eval(cmd);
                fprintf(1,'Data backed up in %s.\n', [p1 filesep bakname]);
                % if outtputG.pdf exists, copy it to the parent folder and
                % change the filename
                outG = [foldername filesep 'outputG.pdf'];
                newoutG = [foldername '.pdf'];
                if isfile(outG)
                    copyfile(outG, newoutG,'f');
                    fprintf(1,'OutputG.pdf copied to %s\n',[p1 filesep newoutG]);
                elseif isfile(newoutG)
                    fprintf(1,'Backup file %s already exists. Nothing done.\n',[p1 filesep newoutG]);
                else
                    fprintf(1,'OutputG.pdf not found. PDF backup not made.\n');
                end
                cd(cdir);                
            case 'No'
                fprintf(1,'Nothing done.\n');
        end
    end
end