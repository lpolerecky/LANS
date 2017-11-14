function varargout = show_stack(varargin)
% SHOW_STACK M-file for show_stack.fig
%      SHOW_STACK, by itself, creates a new SHOW_STACK or raises the existing
%      singleton*.
%
%      H = SHOW_STACK returns the handle to a new SHOW_STACK or the handle to
%      the existing singleton*.
%
%      SHOW_STACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW_STACK.M with the given input arguments.
%
%      SHOW_STACK('Property','Value',...) creates a new SHOW_STACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show_stack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show_stack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show_stack

% Last Modified by GUIDE v2.5 25-Nov-2009 13:06:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show_stack_OpeningFcn, ...
                   'gui_OutputFcn',  @show_stack_OutputFcn, ...
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


% --- Executes just before show_stack is made visible.
function show_stack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show_stack (see VARARGIN)

% Choose default command line output for show_stack
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
if(nargin>3)
    handles.imagestack=varargin{1};
    nim=size(handles.imagestack,3);
    set(handles.text3,'string',num2str(nim));
    if(nim>1)
        im=handles.imagestack(:,:,1);
    else
        im=handles.imagestack;
    end;
    set(handles.edit2,'string',num2str(max(im(:))));
    display_image(im,handles);
end;

set(handles.figure1,'Name','Mass display')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show_stack wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = show_stack_OutputFcn(hObject, eventdata, handles) 
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

disp(get(hObject,'value'));

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Good bye');
close(gcf);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function slider1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmax=str2num(get(handles.text3,'String'));
n=str2num(get(handles.text1,'String'))+1;
if(n>nmax)
    n=nmax;
end;
if(n<1)
    n=1;
end;
set(handles.text1,'string',num2str(n));
display_image(handles.imagestack(:,:,n),handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmax=str2num(get(handles.text3,'String'));
n=str2num(get(handles.text1,'String'))-1;
if(n>nmax)
    n=nmax;
end;
if(n<1)
    n=1;
end;
set(handles.text1,'string',num2str(n));
display_image(handles.imagestack(:,:,n),handles);


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

function display_image(im,handles)
axes(handles.axes1);
mins=str2num(get(handles.edit1,'string'));
maxs=str2num(get(handles.edit2,'string'));
imagesc(im,[mins, maxs]);
set(handles.axes1,'xtick',[],'ytick',[],'dataaspectratio',[1 1 1]);
colorbar('EastOutside');
%colormap(clut);
global additional_settings;
colormap(get_colormap(additional_settings.colormap));

