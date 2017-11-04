function varargout = auto_classification(varargin)
% AUTO_CLASSIFICATION M-file for auto_classification.fig
%      AUTO_CLASSIFICATION, by itself, creates a new AUTO_CLASSIFICATION or raises the existing
%      singleton*.
%
%      H = AUTO_CLASSIFICATION returns the handle to a new AUTO_CLASSIFICATION or the handle to
%      the existing singleton*.
%
%      AUTO_CLASSIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTO_CLASSIFICATION.M with the given input arguments.
%
%      AUTO_CLASSIFICATION('Property','Value',...) creates a new AUTO_CLASSIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before auto_classification_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to auto_classification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help auto_classification

% Last Modified by GUIDE v2.5 10-Jul-2010 09:10:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @auto_classification_OpeningFcn, ...
                   'gui_OutputFcn',  @auto_classification_OutputFcn, ...
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


% --- Executes just before auto_classification is made visible.
function auto_classification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to auto_classification (see VARARGIN)

if(nargin > 3)
    for index = 1:2:(nargin-3),
        if nargin-3==index, break, end
        switch lower(varargin{index})
            case 'base_dir', base_dir = varargin{index+1};
        end
    end
else
    base_dir = pwd;
end

set(handles.edit19,'string',base_dir);

% Choose default command line output for auto_classification
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes auto_classification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = auto_classification_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

base_dir=my_get(handles.edit19,'string');
[FileName,newdir,newext] = uigetfile({'*.dac';'*.dat'},'Select data file', base_dir);
if(FileName~=0)
    set(handles.edit2,'string',[newdir,FileName]);
    set(handles.edit19,'string',newdir);
end;


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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

base_dir=my_get(handles.edit19,'string');
[FileName,newdir,newext] = uigetfile({'*.dac';'*.dat'},'Select data file', base_dir);
if(FileName~=0)
    set(handles.edit4,'string',[newdir,FileName]);
    set(handles.edit19,'string',newdir);
end;


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

base_dir=my_get(handles.edit19,'string');
[FileName,newdir,newext] = uigetfile({'*.dac';'*.dat'},'Select data file', base_dir);
if(FileName~=0)
    set(handles.edit6,'string',[newdir,FileName]);
    set(handles.edit19,'string',newdir);
end;


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
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

base_dir=my_get(handles.edit19,'string');
[FileName,newdir,newext] = uigetfile('*.cls','Select classification conditions file', base_dir);
if(FileName~=0)
    clsname=[newdir,FileName];
    s=load_classification_conditions(clsname);
    update_classification_conditions(handles,s);
    set(handles.edit19,'string',newdir);
end;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

base_dir=my_get(handles.edit19,'string');
[FileName,newdir,newext] = uiputfile('*.cls','Select classification conditions file', base_dir);
if(FileName~=0)
    save_classification_condtitions(handles,[newdir,FileName]);
end;

function s=get_classification_conditions(h)
s2=my_get(h.edit2,'string');
s4=my_get(h.edit4,'string');
s6=my_get(h.edit6,'string');
c2=my_get(h.popupmenu1,'value');
c4=my_get(h.popupmenu2,'value');
c6=my_get(h.popupmenu3,'value');
s.fname{1}=s2;
s.column{1}=c2;
s.var{1}='x';
s.fname{2}=s4;
s.column{2}=c4;
s.var{2}='y';
s.fname{3}=s6;
s.column{3}=c6;
s.var{3}='z';
s1 = my_get(h.edit7,'string');
s2 = my_get(h.edit8,'string');
s.cond{1}=s1;
s.class{1}=s2;
s1 = my_get(h.edit9,'string');
s2 = my_get(h.edit10,'string');
s.cond{2}=s1;
s.class{2}=s2;
s1 = my_get(h.edit11,'string');
s2 = my_get(h.edit12,'string');
s.cond{3}=s1;
s.class{3}=s2;
s1 = my_get(h.edit13,'string');
s2 = my_get(h.edit14,'string');
s.cond{4}=s1;
s.class{4}=s2;
s1 = my_get(h.edit15,'string');
s2 = my_get(h.edit16,'string');
s.cond{5}=s1;
s.class{5}=s2;
s2 = my_get(h.edit18,'string');
s.class{6}=s2;

function update_classification_conditions(h,s)
set(h.edit2,'string',s.fname{1});
set(h.edit4,'string',s.fname{2});
set(h.edit6,'string',s.fname{3});
set(h.edit7,'string',s.cond{1});
set(h.edit8,'string',s.class{1});
set(h.edit9,'string',s.cond{2});
set(h.edit10,'string',s.class{2});
set(h.edit11,'string',s.cond{3});
set(h.edit12,'string',s.class{3});
set(h.edit13,'string',s.cond{4});
set(h.edit14,'string',s.class{4});
set(h.edit15,'string',s.cond{5});
set(h.edit16,'string',s.class{5});
set(h.edit18,'string',s.class{6});
set(h.popupmenu1,'value',s.column{1});
set(h.popupmenu2,'value',s.column{2});
set(h.popupmenu3,'value',s.column{3});

function [s,d]=parsestring(t)
ind=findstr(t,'''');
if(length(ind)==2)
   s=t((ind(1)+1):(ind(2)-1));
   d=str2num(t((ind(2)+2):(ind(2)+2)));
   if(isempty(d))
       d=1;
   end;
else
   s=[];
   d=1;
end;

function s=load_classification_conditions(fname)
if(exist(fname)==2)
    fid=fopen(fname,'r');
    for ii=1:5
        s.cond{ii}=[];
        s.class{ii}=[];
    end;
    ii=0;    
    while 1
        t=fgetl(fid);
        if ~ischar(t),   break,   end
        % parse the lines
        if(findstr(t,'x=read')>0)
            [a,b]=parsestring(t);
            s.fname{1}=a;
            s.column{1}=b;
        else
            if(findstr(t,'y=read')>0)
                [a,b]=parsestring(t);
                s.fname{2}=a;
                s.column{2}=b;
            else
                if(findstr(t,'z=read')>0)
                    [a,b]=parsestring(t);
                    s.fname{3}=a;
                    s.column{3}=b;
                else
                    ind = findstr(t,'otherwise');
                    if(ind>0)
                        t=t(1:ind-1);
                        t=regexprep(t,' ','');
                        t=regexprep(t,char(9),'');
                        s.class{6} = t;
                    else
                        ind=findstr(t,char(9));
                        if(~isempty(ind))
                            ii=ii+1;
                            s.class{ii}=t(1,ind-1);
                            s.cond{ii}=t(ind+1:length(t));
                        end;
                    end;
                end;
            end;
        end;
    end;
    fclose(fid);    
else
    s=[];
end;

function save_classification_condtitions(h,fname)
fid=fopen(fname,'w');
s=get_classification_conditions(h);
fprintf(fid,'x=readdacfile(''%s'',%d);\n', s.fname{1},s.column{1});
fprintf(fid,'y=readdacfile(''%s'',%d);\n', s.fname{2},s.column{2});
fprintf(fid,'z=readdacfile(''%s'',%d);\n', s.fname{3},s.column{3});
for ii=1:length(s.cond)
    if(~isempty(s.cond{ii}))
        fprintf(fid,'%c\t%s\n',s.class{ii},s.cond{ii});
    end;
end;
fprintf(fid,'%c\totherwise',s.class{6});
fclose(fid);
disp(['Classification conditions saved to ',fname]);

function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=get_classification_conditions(handles);
% select cells file
base_dir=fixdir(my_get(handles.edit19,'string'));
base_dir=base_dir(1:length(base_dir)-1);
[base_dir,fname,ext]=fileparts(base_dir);
base_dir=fixdir(base_dir);
global CELLSFILE
[FileName,newdir,newext] = uiputfile('*.dat',['Select output file for cells classification (e.g., ' CELLSFILE '.dat)'], base_dir);
if(FileName~=0)
    % load the x/y/z files, classify cells according to the conditions,
    % save the results in the cells.dat file
    x=readdacfile(s.fname{1},s.column{1},1);
    y=readdacfile(s.fname{2},s.column{2},1);
    z=readdacfile(s.fname{3},s.column{3},1);
    allcells=[1:max([length(x) length(y) length(z)])]';
    % set all classes to the class 'otherwise' by default
    classes=char(s.class{6}*ones(size(allcells)));
    for ii=1:length(s.cond)
        if(~isempty(s.cond{ii}))
            st = sprintf('ind=find(%s);',s.cond{ii});
            % evaluate the condition and set the cells to the corresponding class
            eval(st);
            if(~isempty(ind))
                classes(ind)=char(s.class{ii}*ones(length(ind),1));
            end;
        end;
    end;
    cellsfile = [newdir,FileName];
    fid=fopen(cellsfile,'w');
    for ii=1:length(allcells)
        fprintf(fid,'%d\t%c\n',allcells(ii),classes(ii));
    end;
    fclose(fid);
    disp(['Cells classification saved to ',cellsfile]);
end;

