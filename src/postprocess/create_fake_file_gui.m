function varargout = create_fake_file_gui(varargin)
% CREATE_FAKE_FILE_GUI M-file for create_fake_file_gui.fig
%      CREATE_FAKE_FILE_GUI, by itself, creates a new CREATE_FAKE_FILE_GUI or raises the existing
%      singleton*.
%
%      H = CREATE_FAKE_FILE_GUI returns the handle to a new CREATE_FAKE_FILE_GUI or the handle to
%      the existing singleton*.
%
%      CREATE_FAKE_FILE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATE_FAKE_FILE_GUI.M with the given input arguments.
%
%      CREATE_FAKE_FILE_GUI('Property','Value',...) creates a new CREATE_FAKE_FILE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before create_fake_file_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to create_fake_file_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help create_fake_file_gui

% Last Modified by GUIDE v2.5 04-Dec-2010 09:55:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @create_fake_file_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @create_fake_file_gui_OutputFcn, ...
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


% --- Executes just before create_fake_file_gui is made visible.
function create_fake_file_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to create_fake_file_gui (see VARARGIN)

% Choose default command line output for create_fake_file_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

workdir = find_home_dir;
if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
         case 'workdir'
           workdir = varargin{index+1};
        end
    end
end

if(~isdir(workdir))
    workdir='';
end;
handles.workdir=fixdir(workdir);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes create_fake_file_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = create_fake_file_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,newdir,newext] = uigetfile('*.chk_im', 'Select CHK_IM file', handles.workdir);
if(FileName~=0)
    %set(handles.text2,'String',newext);
    imfile = [newdir, FileName];
    set(handles.edit1,'String',imfile);
end;

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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,newdir] = uiputfile('*.im', 'Define output filename',[handles.workdir]);
if(FileName~=0)
   set(handles.edit2,'String',[newdir FileName]);
else
    set(handles.edit2,'String',[]);
end;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newdir = uigetdir(handles.workdir,'Select directory with a processed IM file');
alldirs = get(handles.listbox1,'String');
N=length(alldirs);
isnew=1;
if(newdir~=0)
    for ii=1:N
        if(strcmp(alldirs{ii},newdir)==1)
            isnew=0;
            break;
        end;
    end;
    if(isnew)
        alldirs{N+1}=newdir;
    end;
end;
set(handles.listbox1,'String',alldirs,'value',length(alldirs));
    
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

chk_im_file = get(handles.edit1,'String');
outname = get(handles.edit2,'String');
processed_imfiles = get(handles.listbox1,'String');
if(~isempty(chk_im_file) & ~isempty(outname) & ~isempty(processed_imfiles))
    create_fake_imfile(chk_im_file, processed_imfiles, outname);
else
    fprintf(1,'Input/output cannot be empty.\n');
end;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alldirs = get(handles.listbox1,'String');
ind=1:length(alldirs);
newind = setdiff(ind,get(handles.listbox1,'value'));
if(~isempty(newind))
    newalldirs=alldirs(newind);
    set(handles.listbox1,'value',1,'String',newalldirs);
else
    set(handles.listbox1,'value',0,'String',[]);
end;

