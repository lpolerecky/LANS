function varargout = show_stack_win(varargin)
% SHOW_STACK_WIN M-file for show_stack_win.fig
%      SHOW_STACK_WIN, by itself, creates a new SHOW_STACK_WIN or raises the existing
%      singleton*.
%
%      H = SHOW_STACK_WIN returns the handle to a new SHOW_STACK_WIN or the handle to
%      the existing singleton*.
%
%      SHOW_STACK_WIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW_STACK_WIN.M with the given input arguments.
%
%      SHOW_STACK_WIN('Property','Value',...) creates a new SHOW_STACK_WIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show_stack_win_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show_stack_win_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show_stack_win

% Last Modified by GUIDE v2.5 29-Nov-2009 19:03:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show_stack_win_OpeningFcn, ...
                   'gui_OutputFcn',  @show_stack_win_OutputFcn, ...
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

% --- Executes just before show_stack_win is made visible.
function show_stack_win_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show_stack_win (see VARARGIN)

% Update handles structure
guidata(hObject, handles);
if(nargin>3)
    handles.imagestack=varargin{1};
    if(length(varargin)>1)
        handles.deselected = varargin{2};
    else
        handles.deselected = zeros(1,size(handles.imagestack,3));
    end;
    nim=size(handles.imagestack,3);
    set(handles.text3,'string',num2str(nim));
    if(nim>1)
        im=handles.imagestack(:,:,1);
    else
        im=handles.imagestack;
    end;
    set(handles.edit2,'string',num2str(max(im(:))));
    %handles.deselected = zeros(1,size(handles.imagestack,3));
    display_image(im,handles);
end;

handles.output.deselected = handles.deselected;
handles.output.region_x = get(handles.axes1,'xlim');;
handles.output.region_y = get(handles.axes1,'ylim');;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show_stack_win wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = show_stack_win_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1




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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
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
set(handles.checkbox1,'value',handles.deselected(n));
display_image(handles.imagestack(:,:,n),handles);

function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
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
set(handles.checkbox1,'value',handles.deselected(n));
display_image(handles.imagestack(:,:,n),handles);

% --- Executes on button press in pushbutton5.
function pushbutton7_Callback(hObject, eventdata, handles)
set(handles.text1,'string','1');
set(handles.checkbox1,'value',handles.deselected(1));
display_image(handles.imagestack(:,:,1),handles);

function pushbutton8_Callback(hObject, eventdata, handles)
n=str2num(get(handles.text3,'String')); % n=nmax
set(handles.text1,'string',num2str(n));
set(handles.checkbox1,'value',handles.deselected(n));
display_image(handles.imagestack(:,:,n),handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.deselected = handles.deselected;
handles.output.region_x = get(handles.axes1,'xlim');
handles.output.region_y = get(handles.axes1,'ylim');

guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

function display_image(im,handles)
axes(handles.axes1);
mins=str2num(get(handles.edit1,'string'));
maxs=str2num(get(handles.edit2,'string'));
imagesc(im,[mins, maxs]);
%set(handles.axes1,'xtick',[],'ytick',[],'dataaspectratio',[1 1 1]);
set(handles.axes1,'dataaspectratio',[1 1 1],'FontSize',10);
b=colorbar('FontSize',10);
%set(b,'OuterPosition',[0.105 0.005 0.8 0.0467]);
colormap(clut);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
n=str2num(get(handles.text1,'String'));
handles.deselected(n)=get(handles.checkbox1,'value');
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.figure1);    
else
    % The GUI is no longer waiting, just close it
    delete(handles.figure1);
end



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on;

