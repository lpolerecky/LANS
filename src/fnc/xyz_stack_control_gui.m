function varargout = xyz_stack_control_gui(varargin)
% XYZ_STACK_CONTROL_GUI MATLAB code for xyz_stack_control_gui.fig
%      XYZ_STACK_CONTROL_GUI, by itself, creates a new XYZ_STACK_CONTROL_GUI or raises the existing
%      singleton*.
%
%      H = XYZ_STACK_CONTROL_GUI returns the handle to a new XYZ_STACK_CONTROL_GUI or the handle to
%      the existing singleton*.
%
%      XYZ_STACK_CONTROL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XYZ_STACK_CONTROL_GUI.M with the given input arguments.
%
%      XYZ_STACK_CONTROL_GUI('Property','Value',...) creates a new XYZ_STACK_CONTROL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xyz_stack_control_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xyz_stack_control_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xyz_stack_control_gui

% Last Modified by GUIDE v2.5 21-Nov-2014 10:23:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @xyz_stack_control_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @xyz_stack_control_gui_OutputFcn, ...
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


% --- Executes just before xyz_stack_control_gui is made visible.
function xyz_stack_control_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xyz_stack_control_gui (see VARARGIN)

if nargin>3
    handles.masses = varargin{1};
    handles.imagestacks = varargin{2};
    handles.planes = varargin{3};
    handles.fname = varargin{4};
else
    handles.masses = {'12C', '13C'};
    handles.imagestacks = {[], []};
    handles.planes = {[], []};
    handles.fname = '';
end;

set(handles.popupmenu1,'string',handles.masses);
set(handles.popupmenu2,'string',handles.masses);
set(handles.popupmenu3,'string',handles.masses);
% determine the size of the images so that the ranges of the slides can be
% set
ims=handles.imagestacks{1};
if ~isempty(ims)
    % HELP:
    % stepSz = [1,5]; % <- [minorStep,majorStep]
    % set(handles.slider2, 'Min', val_min, 'Max',val_max','SliderStep',stepSz/(val_max-val_min))
    set(handles.slider1, 'Max', size(ims,2), 'value', round(size(ims,2)/2), 'sliderstep',[1 5]/(size(ims,2)-1));
    set(handles.slider2, 'Max', size(ims,1), 'value', round(size(ims,1)/2), 'sliderstep',[1 5]/(size(ims,1)-1)); 
    set(handles.slider3, 'Max', size(ims,2), 'value', 1,                    'sliderstep',[1 5]/(size(ims,2)-1));
    set(handles.slider4, 'Max', size(ims,1), 'value', 1,                    'sliderstep',[1 5]/(size(ims,1)-1));
    set(handles.edit1,'String',num2str(round(size(ims,2)/2)));
    set(handles.edit2,'String',num2str(round(size(ims,1)/2)));
    set(handles.edit4,'String','1');
    set(handles.edit3,'String','1');
end

pos1=get(handles.figure1,'Position');
set(handles.figure1,'Position',[1 26 pos1(3:4)]);

% Choose default command line output for xyz_stack_control_gui
handles.output = hObject;

handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xyz_stack_control_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = xyz_stack_control_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit1,'string',sprintf('%d',round(get(hObject,'Value'))))
pushbutton1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit2,'string',sprintf('%d',get(hObject,'Max')-round(get(hObject,'Value'))+1))
pushbutton1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.edit3,'string',sprintf('%d',round(get(hObject,'Value'))))
pushbutton1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%set(handles.edit4,'string',sprintf('%d',get(hObject,'Max')-round(get(hObject,'Value'))+1))
set(handles.edit4,'string',sprintf('%d',round(get(hObject,'Value'))))
pushbutton1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
v=str2num(get(hObject,'String'));
if v>get(handles.slider1,'Max')
    v=get(handles.slider1,'Max');
elseif v<1
    v=1;
end
set(handles.slider1,'Value',v);
set(hObject,'String',num2str(v));

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
v=str2num(get(hObject,'String'));
if v>get(handles.slider2,'Max')
    v=get(handles.slider2,'Max');
elseif v<1
    v=1;
end
set(handles.slider2,'Value',get(handles.slider2,'Max')-v+1);
set(hObject,'String',num2str(v));

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
v=str2num(get(hObject,'String'));
if v>get(handles.slider3,'Max')
    v=get(handles.slider3,'Max');
elseif v<1
    v=1;
end
set(handles.slider3,'Value',v);
set(hObject,'String',num2str(v));

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
v=str2num(get(hObject,'String'));
if v>get(handles.slider4,'Max')
    v=get(handles.slider4,'Max');
elseif v<1
    v=1;
end
set(handles.slider4,'Value',v);
set(hObject,'String',num2str(v));

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

massind1 = get(handles.popupmenu1,'value');
mass1 = handles.masses{massind1};
massind2 = get(handles.popupmenu2,'value');
mass2 = handles.masses{massind2};
massind3 = get(handles.popupmenu3,'value');
mass3 = handles.masses{massind3};
d1=double(handles.imagestacks{massind1});
d2=double(handles.imagestacks{massind2});
d3=double(handles.imagestacks{massind3});
d1 = d1(:,:,[1:length(handles.planes)]);
d2 = d2(:,:,[1:length(handles.planes)]);
d3 = d3(:,:,[1:length(handles.planes)]);
x=str2num(get(handles.edit1,'string'));
y=str2num(get(handles.edit2,'string'));
wx=str2num(get(handles.edit3,'string'));
wy=str2num(get(handles.edit4,'string'));
wz=str2num(get(handles.edit5,'string'));
fname=handles.fname;
if get(handles.checkbox1,'value')
    logf=1;
    mass1=['log(',mass1,')'];
    mass2=['log(',mass2,')'];
    mass3=['log(',mass3,')'];
else
    logf=0;
end
rgb_flags = [get(handles.text6,'value'),...
    get(handles.text7,'value'),...
    get(handles.text8,'value')];
if sum(rgb_flags)==1
    if rgb_flags(1)
        fnum=massind1;
    elseif rgb_flags(2)
        fnum=massind2;
    else 
        fnum=massind3;
    end
elseif sum(rgb_flags)>1
    fnum=0;
else
    fnum=[];
end
if ~isempty(fnum)
    if hObject==handles.pushbutton2
        plot_3D_sections(90+fnum,{d1,d2,d3},x,y,wx,wy,wz,fname,{mass1,mass2,mass3},logf,rgb_flags,1);
    else
        plot_3D_sections(90+fnum,{d1,d2,d3},x,y,wx,wy,wz,fname,{mass1,mass2,mass3},logf,rgb_flags,0);
    end
else
    fprintf(1,'WARNING: Select at least one color (red, green or blue) to display XYZ-stacks.\n');
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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton1_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
