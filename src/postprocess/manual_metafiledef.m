function varargout = manual_metafiledef(varargin)
% MANUAL_METAFILEDEF M-file for manual_metafiledef.fig
%      MANUAL_METAFILEDEF, by itself, creates a new MANUAL_METAFILEDEF or raises the existing
%      singleton*.
%
%      H = MANUAL_METAFILEDEF returns the handle to a new MANUAL_METAFILEDEF or the handle to
%      the existing singleton*.
%
%      MANUAL_METAFILEDEF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUAL_METAFILEDEF.M with the given input arguments.
%
%      MANUAL_METAFILEDEF('Property','Value',...) creates a new MANUAL_METAFILEDEF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manual_metafiledef_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manual_metafiledef_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manual_metafiledef

% Last Modified by GUIDE v2.5 07-Jul-2010 09:48:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manual_metafiledef_OpeningFcn, ...
                   'gui_OutputFcn',  @manual_metafiledef_OutputFcn, ...
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


% --- Executes just before manual_metafiledef is made visible.
function manual_metafiledef_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manual_metafiledef (see VARARGIN)

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

set(handles.edit10,'string',handles.base_dir);

% Choose default command line output for manual_metafiledef
handles.output = hObject;

handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manual_metafiledef wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manual_metafiledef_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% set the value in listbox2 and 3 to the same as in listbox1
v=get(handles.listbox1,'value');
set(handles.listbox2,'value',v);
set(handles.listbox3,'value',v);

a=get(handles.listbox1,'string');
set(handles.edit1,'string',a(v));
a=get(handles.listbox2,'string');
set(handles.edit2,'string',num2str(str2num(a(v,1:size(a,2)))));
a=get(handles.listbox3,'string');
set(handles.edit3,'string',a(v));


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

% set the value in listbox1 and 3 to the same as in listbox2
v=get(handles.listbox2,'value');
set(handles.listbox1,'value',v);
set(handles.listbox3,'value',v);

a=get(handles.listbox1,'string');
set(handles.edit1,'string',a(v));
a=get(handles.listbox2,'string');
set(handles.edit2,'string',num2str(str2num(a(v,1:size(a,2)))));
a=get(handles.listbox3,'string');
set(handles.edit3,'string',a(v));

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add dataset, treatment and cell classes to the listbox, or replace the
% existing one
ds = my_get(handles.edit1,'string');
tt = str2num(my_get(handles.edit2,'string'));
cc = my_get(handles.edit3,'string');
if(length(cc)==1)
    cc=char(cc);
end;
if(~isempty(ds) & ~isempty(tt) & ~isempty(cc))
    specialx = my_get(handles.edit4,'string');
    specialy = my_get(handles.edit5,'string');
    specialz = my_get(handles.edit6,'string');
    specialy2 = my_get(handles.edit7,'string');
    specialx3 = my_get(handles.edit8,'string');
    specialy3 = my_get(handles.edit9,'string');
    
    allt = str2num(my_get(handles.listbox2,'string'));
    allt = allt(:);
    allds = my_get(handles.listbox1,'string');
    allds = convert2cell(allds);
    allcc = my_get(handles.listbox3,'string');
    allcc = convert2cell(allcc);
    N=length(allt);

    % for some strange reason, sometimes ds turns out to be a cell, not
    % just a string. convert it.
    if iscell(ds)
        ds=ds{1};
    end;

    % if more than 1 dataset is in the ds string, parse it and add each
    % dataset separately, making sure that there are no repetitions
    C=textscan(ds,'%s','delimiter',';');    
    for ii=1:length(C{1})
        ds = C{1}(ii);
        ind=finddatasetind(allds,ds);
        if(isempty(ind))
            ind=N+1;
        end;
        allds{ind}=char(ds);
        allt(ind,1)=tt;
        allcc{ind,1}=char(cc);
        update_listboxes(handles,allds,allt,allcc,specialx,specialy,specialz,...
            specialy2, specialx3, specialy3, ind);
        N=length(allt);
    end;
    
end;

function b=convert2cell(a)
if(~iscellstr(a))
    % convert from vector to cell
    N=length(a);
    b=cell(N,1);
    for ii=1:N
        b{ii}=a(ii);
    end;
else 
    b=a;
end;

function ind=finddatasetind(allds,ds)
ind=[];
for ii=1:length(allds)
    if(strcmp(allds(ii),ds))
        ind=ii;
        break;
    end;
end;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% remove selected dataset from the listbox
ind = my_get(handles.listbox1,'value');
allt = str2num(my_get(handles.listbox2,'string'));
allds = my_get(handles.listbox1,'string');
allcc = my_get(handles.listbox3,'string');
specialx = my_get(handles.edit4,'string');
specialy = my_get(handles.edit5,'string');
specialz = my_get(handles.edit6,'string');
specialy2 = my_get(handles.edit7,'string');
specialx3 = my_get(handles.edit8,'string');
specialy3 = my_get(handles.edit9,'string');
N=length(allt);

if(~isempty(allt))
    allind = [1:length(allt)];
    newind = setdiff(allind,ind);
    allt = allt(newind,1);
    allds = allds(newind,1);
    allcc = allcc(newind,1);
end;
N=length(allt);
update_listboxes(handles,allds,allt,allcc,specialx,specialy,specialz,...
    specialy2, specialx3, specialy3, ind-1);



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


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3

% set the value in listbox1 and 2 to the same as in listbox3
v=get(handles.listbox3,'value');
set(handles.listbox1,'value',v);
set(handles.listbox2,'value',v);

a=get(handles.listbox1,'string');
set(handles.edit1,'string',a(v));
a=get(handles.listbox2,'string');
set(handles.edit2,'string',num2str(str2num(a(v,1:size(a,2)))));
a=get(handles.listbox3,'string');
set(handles.edit3,'string',a(v));


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% select dataset from the directory
% get default base_dir
base_dir = handles.base_dir;
base_dir=fixdir(base_dir);
%dname = uigetdir(base_dir,'Select dataset directory');
fprintf(1,'Select processed IM file(s). Hold Ctrl for selecting multiple files.\n');

[FileName,PathName,~] = uigetfile({'*.im', 'Cameca IM file'; ...
    '*.im.zip','Compressed Cameca IM file (*.im.zip)'; ...
    '*.mat','LANS-generated file (*.mat)'}, ...
    'Select processed *.IM, *.IM.zip or *.mat file(s) (+Ctrl for multiple)', base_dir, ...
    'MultiSelect', 'on');

if iscell(FileName)
    FileName1 = FileName{1};
else
    FileName1 = FileName;
end

% find the relative path for the selected filename(s)
if FileName1~=0
    if strcmp(base_dir,PathName)
        rp=[];
    else
        [p, rp]=fileparts(PathName(1:end-1));
        i=0;
        while i<10 && ~strcmp(base_dir,[p filesep])
            [p, rp2] = fileparts(p);
            rp = [rp2 filesep rp];
            i=i+1;
        end
    end
end

if FileName1~=0
    
    if iscell(FileName)
        % when multiple files were selected, add them all to the edit1
        % field; when clicked "Add data set(s)", they will be added with
        % the same Treatment number and cell classes.
        fnames=[];
        for ii=1:length(FileName)
            % remove the .zip suffix
            indzip = findstr(FileName{ii},'.zip');
            if indzip>0
                FileName{ii}= FileName{ii}(1:indzip-1);
            end
            [~,fn,~] = fileparts(FileName{ii});
            if(fn~=0)
                if ii>1
                    fnames = [fnames ';']; % add ; in between
                end
                if isempty(rp)
                    fnames = [fnames fn];
                else
                    fnames = [fnames rp filesep fn];
                end
            end
        end
    else
        % remove the .zip suffix
        indzip = findstr(FileName,'.zip');
        if indzip>0
            FileName = FileName(1:indzip-1);
        end
        [~,fnames,~] = fileparts(FileName);
        if ~isempty(rp)
            fnames = [rp filesep fnames];
        end
    end
    
    % in case the prefs.mat file was selected, choose the corresponding
    % folder name
    ind = findstr(fnames, '/prefs');
    if ~isempty(ind)
        fnames = fnames(1:(ind-1));
    end
    
    if ~isempty(fnames)
        set(handles.edit1,'string',fnames);
    end
    
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load metafile and fill out the GUI fields
base_dir = handles.base_dir;
base_dir=fixdir(base_dir);

[FileName,newdir,newext] = uigetfile('*.txt','Select metafile ', base_dir);
if(FileName~=0)
    metafile = [newdir, FileName];
    base_dir=newdir;
else
    % default
    metafile = [base_dir,delimiter,'metafile.txt'];
end;

if(exist(metafile)==2)
    fid=fopen(metafile,'r');
    jj=0;
    specialx1=[];
    specialy1=[];
    specialx2=[];
    specialy2=[];
    specialx3=[];
    specialy3=[];
    while 1
        tline = fgetl(fid);
        if ~ischar(tline) | isempty(tline),   break,   end
        if strcmp(tline(1),'#') 
            if jj==0
                % this is the first line, which contains the basedir
                ind=findstr(tline,' ');
                if length(ind)==1
                    basedir = tline(ind+1:end);
                    fprintf(1,'Base directory: %s\n',basedir);
                end;
                if isdir(basedir)
                    base_dir=basedir;
                    set(handles.edit10,'string',base_dir);
                end;
            end;
        end;
        a=sscanf(tline,'%c');
        if(~strcmp(a(1),'#'))
            ind=[0 findstr(a,char(9)) length(a)+1];
            jj=jj+1;
            for ii=1:(length(ind)-1)
                s = a(ind(ii)+1:ind(ii+1)-1);
                switch ii
                    case 2, all_datasets{jj} = s;
                    case 3, all_treatments(jj,1) = str2num(s);
                    case 4, all_cellclasses{jj} = s;
                    case 5, specialx1 = s;
                    case 6, specialy1 = s;
                    case 7, specialx2 = s;
                    case 8, specialy2 = s;
                    case 9, specialx3 = s;
                    case 10, specialy3 = s;
                end;
            end;
        end;
    end;
    fclose(fid);
    fprintf(1,'Data loaded from %s\n',metafile);
    handles.base_dir = base_dir;
    update_listboxes(handles,all_datasets,all_treatments,all_cellclasses,...
        specialx1,specialy1,specialx2,specialy2,specialx3,specialy3,1);
    listbox1_Callback(hObject, eventdata, handles);
    guidata(hObject, handles);
end;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save the information to the metafile
base_dir = handles.base_dir;
base_dir=fixdir(base_dir);

[FileName,newdir,newext] = uiputfile('*.txt','Select metafile ', base_dir);
if(FileName~=0)
    metafile = [newdir, FileName];
else
    % default
    metafile = [base_dir,delimiter,'metafile.txt'];
end;

% save the cell classification in the selected cellfile
all_datasets = my_get(handles.listbox1,'string');
all_treatments = str2num(my_get(handles.listbox2,'string'));
all_cellclasses = my_get(handles.listbox3,'string');
specialx1 = my_get(handles.edit4,'string');
specialy1 = my_get(handles.edit5,'string');
specialx2 = my_get(handles.edit6,'string');
specialy2 = my_get(handles.edit7,'string');
specialx3 = my_get(handles.edit8,'string');
specialy3 = my_get(handles.edit9,'string');

N=length(all_treatments);
fid=fopen(metafile,'w');
fprintf(fid, '# %s\n',base_dir);
for ii=1:N
    file_name = all_datasets{ii};
    if contains(file_name,' ')
        file_name = sprintf('"%s"', file_name);
    end
    fprintf(fid,'%d\t%s\t%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
        ii,file_name,all_treatments(ii),all_cellclasses{ii},...
        specialx1,specialy1,specialx2,specialy2,specialx3,specialy3);
end;
fclose(fid);
fprintf(1,'Metafile saved as %s\n',metafile);


function update_listboxes(handles,all_datasets,all_treatments,all_cell_classes,...
    specialx1,specialy1,specialx2,specialy2,specialx3,specialy3,dnum)
% sort the cells first
N=length(all_datasets);
set(handles.listbox1,'string', all_datasets);
set(handles.listbox2,'string', num2str(all_treatments));
set(handles.listbox3,'string', all_cell_classes);
set(handles.edit4,'string', specialx1);
set(handles.edit5,'string', specialy1);
set(handles.edit6,'string', specialx2);
set(handles.edit7,'string', specialy2);
set(handles.edit8,'string', specialx3);
set(handles.edit9,'string', specialy3);

% highlight the dataset dnum
if(~isempty(dnum) & dnum>0)
    set(handles.listbox1,'value',dnum);
    set(handles.listbox2,'value',dnum);
    set(handles.listbox3,'value',dnum);
end;

function pushbutton6_Callback(hObject, eventdata, handles)
% select different base_dir

base_dir = handles.base_dir;
base_dir=fixdir(base_dir);
dname = uigetdir(base_dir,'Select dataset directory');

if ~isdir(dname)
    
    fprintf(1,'Directory %s does not exist.\nPlease select a valid directory.\n',dname);
    
else
    handles.base_dir = dname;
end;

set(handles.edit10,'string',handles.base_dir);
guidata(hObject, handles);
