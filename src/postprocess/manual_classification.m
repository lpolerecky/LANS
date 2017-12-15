function varargout = manual_classification(varargin)
% MANUAL_CLASSIFICATION M-file for manual_classification.fig
%      MANUAL_CLASSIFICATION, by itself, creates a new MANUAL_CLASSIFICATION or raises the existing
%      singleton*.
%
%      H = MANUAL_CLASSIFICATION returns the handle to a new MANUAL_CLASSIFICATION or the handle to
%      the existing singleton*.
%
%      MANUAL_CLASSIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUAL_CLASSIFICATION.M with the given input arguments.
%
%      MANUAL_CLASSIFICATION('Property','Value',...) creates a new MANUAL_CLASSIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manual_classification_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manual_classification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manual_classification

% Last Modified by GUIDE v2.5 07-Jul-2010 07:49:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manual_classification_OpeningFcn, ...
                   'gui_OutputFcn',  @manual_classification_OutputFcn, ...
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


% --- Executes just before manual_classification is made visible.
function manual_classification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manual_classification (see VARARGIN)

if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
            case 'base_dir', handles.base_dir = varargin{index+1};
        end
    end
else
    handles.base_dir = pwd;
end

% Choose default command line output for manual_classification
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manual_classification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manual_classification_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% set the value in listbox2 to the same as in listbox1
v=get(handles.listbox1,'value');
set(handles.listbox2,'value',v);
a=get(handles.listbox1,'string');
ss=num2str(str2num(a(v,1:size(a,2))));
set(handles.edit1,'string',ss);
a=get(handles.listbox2,'string');
set(handles.edit2,'string',a(v,1));

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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

% set the value in listbox1 to the same as in listbox2
v=get(handles.listbox2,'value');
set(handles.listbox1,'value',v);
a=get(handles.listbox1,'string');
ss=num2str(str2num(a(v,1:size(a,2))));
set(handles.edit1,'string',ss);
a=get(handles.listbox2,'string');
set(handles.edit2,'string',a(v,1));


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add cell number and its class to the end of the listbox, or replace the
% existing one
cnum = str2num(my_get(handles.edit1,'string'));
class = my_get(handles.edit2,'string');
allcnum = str2num(my_get(handles.listbox1,'string'));
allclass = my_get(handles.listbox2,'string');
N=length(allcnum);

ind=find(allcnum==cnum);
if(~isempty(ind))
    allclass(ind) = class;
else
    N=N+1;
    allcnum(N,1)=cnum;
    allclass(N,1)=class;
end;

update_listboxes(handles,allcnum,allclass,cnum);
% at the end, increase the number in the edit1 field by 1.
set(handles.edit1,'string',num2str(cnum+1));

function update_listboxes(handles,allcnum,allclass,cnum)
if ~isempty(allcnum)
    % sort the cells first
    [allcnum,ind]=sort(allcnum);
    allclass=allclass(ind);
    set(handles.listbox1,'string', num2str(allcnum));
    set(handles.listbox2,'string', allclass);
    % highlight the cell cnum
    ind=find(allcnum==cnum);
    if(~isempty(ind))
        set(handles.listbox1,'value',ind);
        set(handles.listbox2,'value',ind);
    end;
else
    fprintf(1,'WARNING: classification file empty.\n');
end;
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% remove selected cell number and its class from the listbox
ind = my_get(handles.listbox1,'value');
allcnum = str2num(my_get(handles.listbox1,'string'));
allclass = my_get(handles.listbox2,'string');
if(~isempty(allcnum))
    allind = [1:length(allcnum)];
    newind = setdiff(allind,ind);
    allcnum = allcnum(newind,1);
    allclass = allclass(newind,1);
end;

update_listboxes(handles,allcnum,allclass,ind-1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load the cell classification from the selected cellfile
base_dir = handles.base_dir;
base_dir=fixdir(base_dir);

[FileName,newdir,newext] = uigetfile('*.dat','Select cell classification file (e.g. cells.dat)', base_dir);
if(FileName~=0)
    cellfile = [newdir, FileName];
    base_dir=newdir;
else
    % default
    cellfile = [base_dir,delimiter,'cells.dat'];
end;

if(exist(cellfile)==2)
    fid=fopen(cellfile,'r');
    jj=0;
    allcnum=[];
    allclass=[];
    while 1
        tline = fgetl(fid);
        if ~ischar(tline),   break,   end
        a=sscanf(tline,'%d %s');
        jj=jj+1;
        allcnum(jj,1) = a(1);
        allclass(jj,1) = a(2);
    end
    fclose(fid);
    allclass=char(allclass);
    s=sprintf('Data loaded from %s',cellfile);
    disp(s);
    handles.base_dir = base_dir;
    update_listboxes(handles,allcnum,allclass,1);
    guidata(hObject, handles);
end;

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

base_dir = handles.base_dir;
base_dir=fixdir(base_dir);

[FileName,newdir,newext] = uiputfile('*.dat','Select cell classification file (e.g. cells.dat)', base_dir);
if(FileName~=0)
    cellfile = [newdir, FileName];
else
    % default
    cellfile = [base_dir,delimiter,'cells.txt'];
end;

% save the cell classification in the selected cellfile
allcnum = str2num(my_get(handles.listbox1,'string'));
allclass = my_get(handles.listbox2,'string');
N=length(allcnum);
fid=fopen(cellfile,'w');
for ii=1:N
    fprintf(fid,'%d\t%s\n',allcnum(ii,1),allclass(ii,1));
end;
fclose(fid);
s=sprintf('Cell classes saved as %s',cellfile);
disp(s);
