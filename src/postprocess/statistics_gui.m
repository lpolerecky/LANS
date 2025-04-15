function varargout = statistics_gui(varargin)
% STATISTICS_GUI MATLAB code for statistics_gui.fig
%      STATISTICS_GUI, by itself, creates a new STATISTICS_GUI or raises the existing
%      singleton*.
%
%      H = STATISTICS_GUI returns the handle to a new STATISTICS_GUI or the handle to
%      the existing singleton*.
%
%      STATISTICS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STATISTICS_GUI.M with the given input arguments.
%
%      STATISTICS_GUI('Property','Value',...) creates a new STATISTICS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before statistics_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to statistics_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help statistics_gui

% Last Modified by GUIDE v2.5 05-Jul-2011 13:10:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @statistics_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @statistics_gui_OutputFcn, ...
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


% --- Executes just before statistics_gui is made visible.
function statistics_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to statistics_gui (see VARARGIN)

if nargin>3
    handles.roi_prop = varargin{1};
    handles.roi_ratios = varargin{2};
    handles.varnames = varargin{3};
    handles.metafile = varargin{4};
    %handles.print_factor = varargin{4};
else
    handles.roi_prop = [];
    handles.roi_ratios = [];
    handles.varnames = [];
    handles.metafile = [];
    %handles.print_factor = [];
end

if ~isempty(handles.roi_prop)
    
    % initialize GUI based on input
    
    cellclass = handles.roi_prop.roi_class;
    treatment = handles.roi_prop.treatment;
    
    set(handles.popupmenu1,'string',handles.varnames,'value',1);
    
    cu = unique(cellclass);    
    % make all classes that are not in cu invisible
    % also fill handles.class_checkbox variable, which will be used to
    % identify which checkbox is associated with which class
    for ii=1:25
        if ii<=length(cu)            
            s = sprintf('set(handles.checkbox%d,''visible'',''on'');',ii);
            eval(s);
            s = sprintf('set(handles.checkbox%d,''value'',1);',ii);
            eval(s);
            s = sprintf('set(handles.checkbox%d,''string'',''%c'');',ii,char(cu(ii)));
            eval(s);
            handles.class_checkbox(ii) = ii;
        else
            s = sprintf('set(handles.checkbox%d,''visible'',''off'');',ii);
            eval(s);
        end    
    end
    
    tu = unique(treatment);
    % make all treatments that are not in tu invisible
    % also fill handles.treatment_checkbox variable, which will be used to
    % identify which checkbox is associated with which treatment
    for ii=1:15
        s = sprintf('set(handles.checkbox%d,''visible'',''off'');',ii+25);
        eval(s);
        s = sprintf('set(handles.checkbox%d,''value'',0);',ii+25);
        eval(s);
    end
    for ii=1:min([15 length(tu)])
        s = sprintf('set(handles.checkbox%d,''visible'',''on'');',ii+25);
        eval(s);
        if ii==1
            s = sprintf('set(handles.checkbox%d,''value'',1);',ii+25);
            eval(s);
        end
        s = sprintf('set(handles.checkbox%d,''string'',''%d'');',ii+25,tu(ii));
        eval(s); 
        handles.treatment_checkbox(ii)=ii+25;
    end

end

apos=get(handles.axes1,'Position');
%set(handles.axes1,'Position',[apos(1:2) 400 400]);

% Choose default command line output for statistics_gui
handles.output = hObject;

handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes statistics_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = statistics_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Nc = length(handles.class_checkbox);
for ii=1:Nc
    s=sprintf('set(handles.checkbox%d,''value'',1);',ii);
    eval(s);
end;

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Nc = length(handles.class_checkbox);
for ii=1:Nc
    s=sprintf('set(handles.checkbox%d,''value'',0);',ii);
    eval(s);
end;

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


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


% --- Executes on button press in checkbox19.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox19


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


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


% --- Executes on button press in checkbox25.
function checkbox25_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox25


% --- Executes on button press in checkbox26.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26


% --- Executes on button press in checkbox27.
function checkbox27_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox27


% --- Executes on button press in checkbox28.
function checkbox28_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox28


% --- Executes on button press in checkbox29.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox29


% --- Executes on button press in checkbox30.
function checkbox30_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox30


% --- Executes on button press in checkbox31.
function checkbox31_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox31


% --- Executes on button press in checkbox32.
function checkbox32_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox32


% --- Executes on button press in checkbox33.
function checkbox33_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox33


% --- Executes on button press in checkbox34.
function checkbox34_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox34


% --- Executes on button press in checkbox35.
function checkbox35_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox35


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Nc = length(handles.treatment_checkbox);
for ii=1:Nc
    s=sprintf('set(handles.checkbox%d,''value'',1);',25+ii);
    eval(s);
end;

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Nc = length(handles.treatment_checkbox);
for ii=1:Nc
    s=sprintf('set(handles.checkbox%d,''value'',0);',25+ii);
    eval(s);
end;

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox36.
function checkbox36_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox36

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[nt,t] = selected_treatments(handles);
[nc,c] = selected_classes(handles);
sr = handles.varnames{selected_ratio(handles)};

% export when pushbutton7 pressed
export_flag = hObject==handles.pushbutton7;

if selected_compare(handles)==1 
    if nt==1
        
        %% THIS WILL NOT WORK %%
        
        if nc>0
            
            % code for comparing ROIs in 1 or more classes for 1 treatment
            % ratios measured in different planes are used as the basis for
            % comparison
            
%             d=handles.data{selected_ratio(handles)};
%             cellclass = d(:,4);
%             treatment = d(:,5);
            ROIs = handles.roi_prop.roi_uid;
            cellclass = handles.roi_prop.roi_class;
            treatment = handles.roi_prop.treatment;
            ratios = table2array(handles.roi_ratios(:,(selected_ratio(handles)-1)*2+1));

            cu = unique(cellclass);
            tu = unique(treatment);
            indc = findn(cellclass, cu(find(c)));
            indt = findn(treatment, tu(find(t)));
            ind = intersect(indc,indt);
            
            % prepare data
            x = log_transform(ratios(ind),handles); % ratios, optionally log10-transformed
            cls = cellclass(ind); % classes
            tmnt = treatment(ind); % treatments
            % cell number is the group for comparison, classes are ignored now
            g = ROIs(ind); 
            if get(handles.checkbox43,'value')
                sr = ['log(' sr ')']; % selected ratio
            end;
            tt = get(handles.popupmenu3,'value'); % test type 
            
            % remove NaN, in case they occur. This may happen when ratios
            % are zero and the data are log-transferred
            ind=find(isnan(x)==0);
            indnan=find(isnan(x)==1);
            if ~isempty(indnan)
                fprintf(1,'Warning: %d NaN values removed from the dataset (N=%d).\n',length(indnan),length(x));
            end;
            x=x(ind);
            cls=cls(ind);
            tmnt=tmnt(ind);
            g=g(ind);
            
            % do the actual comparison test
            switch tt
                case 1, test_levene(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'ROI',handles,export_flag);
                case 2, test_kw(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'ROI',handles,export_flag);
                case 3, test_anova(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'ROI',handles,export_flag);
            end;                    
            
        else
            fprintf(1,'ERROR: At least 1 class must be selected when comparing ROIs\n');
        end;
    else
        fprintf(1,'ERROR: 1 treatment must be selected when comparing ROIs\n');
    end;
end;

if selected_compare(handles)==2
    if nt==1
        
            
            % code for comparing 2 or more classes for 1 treatment
            % average ratios measured in different ROIs are used as the basis for
            % comparison
                        
            ROIs = handles.roi_prop.roi_uid;
            cellclass = handles.roi_prop.roi_class;
            treatment = handles.roi_prop.treatment;
            ratios = table2array(handles.roi_ratios(:,(selected_ratio(handles)-1)*2+1));
                        
            % find average ratios for each ROI first
            mr = grpstats(ratios,ROIs,{'mean'});
            mc = grpstats(cellclass,ROIs,{'mean'});
            mt = grpstats(treatment,ROIs,{'mean'});
            
            % get data only for selected classes and treatments
            cu = unique(mc);
            tu = unique(mt);
            indc = findn(mc, cu(find(c)));
            indt = findn(mt, tu(find(t)));
            ind = intersect(indc,indt);
            
            % finalize data preparation
            x = log_transform(mr(ind),handles); % ratios, optionally log10-transformed
            cls = mc(ind); % classes
            tmnt = mt(ind); % treatments
            g = char(cls); % ROI class is the group for comparison
            if get(handles.checkbox43,'value')
                sr = ['log(' sr ')']; % selected ratio
            end;
            
            % remove NaN, in case they occur. This may happen when ratios
            % are zero and the data are log-transferred
            ind=find(isnan(x)==0);
            indnan=find(isnan(x)==1);
            if ~isempty(indnan)
                fprintf(1,'Warning: %d NaN values removed from the dataset.\n',length(indnan));
            end;
            x=x(ind);
            cls=cls(ind);
            tmnt=tmnt(ind);
            g=g(ind);
            
            % display raw data to the main window so that the one can copy
            % and paste it nicely organized, if one wishes to do so
            fprintf(1,'*********\nALL DATA (comparison of classes):\ncls\ttmnt\t%s\n',sr);
            for ii=1:length(x)
                fprintf(1,'%c\t%d\t%.4e\n',cls(ii),g(ii),x(ii));
            end;
            
            % calculate means, std, etc.
            [mm,ss,gn,nn,meanci,sem]=grpstats(x,g,{'mean','std','gname','numel','meanci','sem'});
            [mc]=grpstats(cls,g,{'mean'});
            [mt]=grpstats(tmnt,g,{'mean'});
            fprintf(1,'STATISTICS:\t%s\ngroup\tmean    \tsem      \tstd      \tN      \tfrac (%s)\tPr(mean=0)\t(ci)\n',sr,'%');
            for ii=1:length(mm)
                % test whether value significantly different from zero
                ind0 = find(g==gn{ii});
                [ht,pt,cit]=ttest(x(ind0));
                fprintf(1,'%s\t%.3e\t%.3e\t%.3e\t%d\t%.1f\t%.1e\t\t%.3e\t%.3e\n',gn{ii},mm(ii),sem(ii),ss(ii),nn(ii), 100*nn(ii)/sum(nn),pt,cit);
            end
                     
        if nc>1
            
            tt = get(handles.popupmenu3,'value'); % test type       
            % do the actual comparison test
            switch tt
                case 1, test_levene(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'class',handles,export_flag);
                case 2, test_kw(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'class',handles,export_flag);
                case 3, test_anova(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'class',handles,export_flag);
            end; 
            
        else
            fprintf(1,'ERROR: At least 2 classes must be selected when comparing Classes\n');
        end;
    else
        fprintf(1,'ERROR: 1 treatment must be selected when comparing Classes\n');
    end;
end;

if selected_compare(handles)==3
    if nt>1
        if nc==1
            
            % code for comparing 2 or more treatments for 1 class
            % average ratios measured in different ROIs are used as the basis for
            % comparison
                        
            %d=handles.data{selected_ratio(handles)};
            %ROIs = d(:,2);
            ROIs = handles.roi_prop.roi_uid;
            %cellclass = d(:,4);
            cellclass = handles.roi_prop.roi_class;
            %treatment = d(:,5);
            treatment = handles.roi_prop.treatment;
            %ratios = d(:,3);
            ratios = table2array(handles.roi_ratios(:,(selected_ratio(handles)-1)*2+1));
            
            % find average ratios for each ROI first
            mr = grpstats(ratios,ROIs,{'mean'});
            mc = grpstats(cellclass,ROIs,{'mean'});
            mt = grpstats(treatment,ROIs,{'mean'});
            
            % get data only for selected classes and treatments
            cu = unique(mc);
            tu = unique(mt);
            indc = findn(mc, cu(find(c)));
            indt = findn(mt, tu(find(t)));
            ind = intersect(indc,indt);
            
            % finalize data preparation
            x = log_transform(mr(ind),handles); % ratios, optionally log10-transformed
            cls = mc(ind); % classes
            tmnt = mt(ind); % treatments
            g = tmnt; % ROI treatment is the group for comparison
            if get(handles.checkbox43,'value')
                sr = ['log(' sr ')']; % selected ratio
            end;
            
            % remove NaN, in case they occur. This may happen when ratios
            % are zero and the data are log-transferred
            ind=find(isnan(x)==0);
            indnan=find(isnan(x)==1);
            if ~isempty(indnan)
                fprintf(1,'Warning: %d NaN values removed from the dataset.\n',length(indnan));
            end;
            x=x(ind);
            cls=cls(ind);
            tmnt=tmnt(ind);
            g=g(ind);
            
            % display raw data to the main window so that the one can copy
            % and paste it nicely organized, if one wishes to do so
            %fprintf(1,'cls\ttmnt\t%s\n',sr);
            fprintf(1,'*********\nALL DATA (comparison of treatments):\ncls\ttmnt\t%s\n',sr);
            for ii=1:length(x)
                %fprintf(1,'%c\t%d\t%.4e\n',cls(ii),g(ii),x(ii));
                fprintf(1,'%c\t%d\t%.4e\n',cls(1),g(ii),x(ii));
            end;
                        
            % calculate means, std, etc.
            [mm,ss,gn,nn,meanci,sem]=grpstats(x,g,{'mean','std','gname','numel','meanci','sem'});
            [mc]=grpstats(cls,g,{'mean'});
            [mt]=grpstats(tmnt,g,{'mean'});
            fprintf(1,'STATISTICS:\t(%c)\t%s\ngroup\tmean     \tsem      \tstd      \tN      \tfrac(%s)\tPr(mean=0)\t(ci)\n',cls(1),sr,'%');
            for ii=1:length(mm)
                % test whether value significantly different from zero
                ind0 = find(g==str2num(gn{ii}));
                [ht,pt,cit]=ttest(x(ind0));
                fprintf(1,'%s\t%.3e\t%.3e\t%.3e\t%d\t%.1f\t%.1e\t\t%.3e\t%.3e\n',gn{ii},mm(ii),sem(ii),ss(ii),nn(ii), 100*nn(ii)/sum(nn),pt,cit);
            end
            
            tt = get(handles.popupmenu3,'value'); % test type       
            % do the actual comparison test
            switch tt
                case 1, test_levene(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'treat',handles,export_flag);
                case 2, test_kw(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'treat',handles,export_flag);
                case 3, test_anova(x,g,sr,cls,tmnt,handles.metafile,handles.axes1,'treat',handles,export_flag);
            end; 
            
        else
            fprintf(1,'ERROR: 1 class must be selected when comparing Treatments\n');
        end;
    else
        fprintf(1,'ERROR: At least 2 treatments must be selected when comparing Treatments\n');
    end;
end;
get_axis_scale(handles);

function log10x = log_transform(x,handles)
if get(handles.checkbox43,'value')
    log10x = log10(x);
    ind = find(~isfinite(log10x));
    log10x(ind) = NaN(size(ind));
else
    log10x = x;
end

function ind = findn(a, b)
% find indices where a==b. b can be a vector
ind = [];
b=unique(b);
a=a(:)';
for ii=1:length(b)
    ind = [ind find(a==b(ii))];
end
ind = unique(ind);

function s=selected_ratio(handles)
s = get(handles.popupmenu1,'value');

function s=selected_compare(handles)
s = get(handles.popupmenu2,'value');

function [nc,c]=selected_classes(handles)
nc = length(handles.class_checkbox);
c = zeros(nc,1);
for ii=1:nc
    s = sprintf('c(ii)=get(handles.checkbox%d,''value'');',ii);
    eval(s);
end
nc = length(find(c==1));

function [nt,c]=selected_treatments(handles)
nt = length(handles.treatment_checkbox);
c = zeros(nt,1);
for ii=1:nt
    s = sprintf('c(ii)=get(handles.checkbox%d,''value'');',ii+25);
    eval(s);
end
nt = length(find(c==1));


% --- Executes on button press in checkbox37.
function checkbox37_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox37

function edit1_Callback(hObject, eventdata, handles)
set_xaxis_scale(handles);

function edit2_Callback(hObject, eventdata, handles)
set_yaxis_scale(handles);

function set_xaxis_scale(handles)
xs=str2num(get(handles.edit1,'String'));
set(handles.axes1,'xlim',xs);

function set_yaxis_scale(handles)
ys=str2num(get(handles.edit2,'String'));
set(handles.axes1,'ylim',ys);

function get_axis_scale(handles)
set(handles.edit2,'String',sprintf('[%.1f %.1f]',get(handles.axes1,'ylim')));
v=get(handles.axes1,'xlim');
omag=round(log10(mean(v)));
if omag>=0
    fmt2='%.2f';
else
    fmt2='%.2e';
end;
if v(1)==0
   fmt=['[%d ' fmt2 ']'];
else
   fmt=['[' fmt2 ' ' fmt2 ']'];    
end;
set(handles.edit1,'String',sprintf(fmt,v));
