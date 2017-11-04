function varargout = depth_profiles_masses_gui(varargin)
% DEPTH_PROFILES_MASSES_GUI MATLAB code for depth_profiles_masses_gui.fig
%      DEPTH_PROFILES_MASSES_GUI, by itself, creates a new DEPTH_PROFILES_MASSES_GUI or raises the existing
%      singleton*.
%
%      H = DEPTH_PROFILES_MASSES_GUI returns the handle to a new DEPTH_PROFILES_MASSES_GUI or the handle to
%      the existing singleton*.
%
%      DEPTH_PROFILES_MASSES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEPTH_PROFILES_MASSES_GUI.M with the given input arguments.
%
%      DEPTH_PROFILES_MASSES_GUI('Property','Value',...) creates a new DEPTH_PROFILES_MASSES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before depth_profiles_masses_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to depth_profiles_masses_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help depth_profiles_masses_gui

% Last Modified by GUIDE v2.5 03-Jul-2011 12:59:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @depth_profiles_masses_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @depth_profiles_masses_gui_OutputFcn, ...
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


% --- Executes just before depth_profiles_masses_gui is made visible.
function depth_profiles_masses_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to depth_profiles_masses_gui (see VARARGIN)

if(nargin>3)
    handles.data = varargin{1};
    set(handles.popupmenu1,'string',handles.data.ratio);
    set(handles.popupmenu1,'value',1);
    m_initialize_listbox(handles);
else
    handles.data = [];
end;

apos=get(handles.axes1,'Position');
%set(handles.axes1,'Position',[145 60 400 400]);

handles = display_selected_mass(hObject,handles,1);

% Choose default command line output for depth_profiles_masses_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes depth_profiles_masses_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function m_initialize_listbox(handles)
% fill the listbox with defined ROI IDs, deselect all 
Nc = size(handles.data.y{1},2);
v = [1:Nc]';
s = num2str(v);
set(handles.listbox1,'String',s,'value',[]);

function handles = display_selected_mass(hObject, handles,ri)

global additional_settings;

if isfield(additional_settings,'defFontSize')
    defFontSize = additional_settings.defFontSize;
else 
    defFontSize=10;
end;

if ~isempty(handles.data)
    data = handles.data;
    set(handles.figure1,'Name',['Depth profile of ', data.ratio{ri}]);
    Nc = size(data.y{ri},2);
    % plot the data
    axes(handles.axes1);
    hold off;
    colors=get_colors;    
    for ii=1:Nc        
        x=data.x{ri};
        y=data.y{ri}(:,ii);
        dy=data.dy{ri}(:,ii);
        p=data.pol{ri}(ii);
        if get(handles.checkbox102,'value')
            eb(ii)=errorbar(x,y,dy/2,colors{ii});
        else
            eb(ii)=plot(x,y,colors{ii});
        end;
        hold on;
        tt(ii)=text(max(x)+1, y(end), num2str(ii), 'FontSize',defFontSize,'Color',colors{ii}(1));
        if p>0
            if p<4
                pfit(ii)=plot(x,polyval(polyfit(x,y,p),x),[colors{ii}(1) '-'],'LineWidth',1);
            else
                pfit(ii)=plot(x,exp(polyval(polyfit(x,log(y),1),x)),[colors{ii}(1) '-'],'LineWidth',1);
            end;
        else
            pfit(ii)=0;
        end;
        sel=get(handles.listbox1,'value');
        set(handles.checkbox101,'value',0);
        if isempty(intersect(sel,ii))
            set(eb(ii),'visible','off');
            set(tt(ii),'visible','off');
            if pfit(ii)~=0, set(pfit(ii),'visible','off'); end;
            %set(pfit(ii),'visible','off');
        end;
    end;
    
    % remember the plot/text handles
    handles.eb = eb;
    handles.tt = tt;
    handles.pfit = pfit;
    
    % make the graph look nicer for printing
    set(handles.axes1,'xlim',[0 max(x)+1]);
    xlabel('plane number', 'FontSize',defFontSize);
    title('total counts accumulated over ROI', 'FontSize',defFontSize, 'fontweight','normal');
    if get(handles.checkbox102,'value')
        ylabel(sprintf('%s: (mean +/- Poisson error) per ROI',data.ratio{ri}),'FontSize',defFontSize);
    else
        ylabel(sprintf('%s: mean per ROI',data.ratio{ri}),'FontSize',defFontSize);
    end;
    set(handles.axes1, 'FontSize',defFontSize);
    
    %set(handles.axes1,'TickLabelInterpreter', 'latex');
    
    % make the export eps button invisible, if export not requested
    %if ~data.plot_flag
        %set(handles.pushbutton3,'visible','off');
    %end;
    
    get_axis_scale(handles);
            
else
    handles.eb = [];
    handles.tt = [];
    handles.pfit = [];
end;
guidata(hObject, handles);

function listbox1_Callback(hObject, eventdata, handles)
m_toggle_profile(handles);

function set_xaxis_scale(handles)
xs=str2num(get(handles.edit1,'String'));
set(handles.axes1,'xlim',xs);

function set_yaxis_scale(handles)
ys=str2num(get(handles.edit2,'String'));
set(handles.axes1,'ylim',ys);

function get_axis_scale(handles)
set(handles.edit1,'String',sprintf('[%.0f %.0f]',get(handles.axes1,'xlim')));
v=get(handles.axes1,'ylim');
omag=round(log10(mean(v)));
if omag>=0
    fmt2='%.1f';
else
    fmt2='%.1e';
end;
if v(1)==0
   fmt=['[%d ' fmt2 ']'];
else
   fmt=['[' fmt2 ' ' fmt2 ']'];    
end;
set(handles.edit2,'String',sprintf(fmt,v));

% --- Outputs from this function are returned to the command line.
function varargout = depth_profiles_masses_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function m_toggle_profile(handles)
global additional_settings;
sel=get(handles.listbox1,'value');
% Matlab seems to crash if more than 100 plots are displaed in axes.
% Prevent this from happening by ensuring that sel contains <=100 ones
Nmax = 50;
if length(sel)>Nmax
    ind = [1:Nmax];
    sel = sel(ind);
    fprintf(1,'*** WARNING: More than %d depth profiles cannot be displayed. Displaying ROIs:\n',Nmax);
    fprintf(1,'%d ',sel);
    fprintf(1,'\n');
    % make sure that the same profiles are displayed when a different ratio
    % is selected
    set(handles.listbox1,'value',sel);
end;
ri = get(handles.popupmenu1,'value');
Nc = size(handles.data.y{ri},2);  
for ii=1:Nc        
    if isempty(intersect(sel,ii))
        set(handles.eb(ii),'visible','off');
        set(handles.tt(ii),'visible','off');
        if handles.pfit(ii)~=0, set(handles.pfit(ii),'visible','off'); end;
        %set(handles.pfit(ii),'visible','off');
    else
        set(handles.eb(ii),'visible','on');
        set(handles.tt(ii),'visible','on');
        if handles.pfit(ii)~=0
            if additional_settings.display_trend_lines
                set(handles.pfit(ii),'visible','on'); 
            end;
            fprintf(1,'Significant trend with depth in ROI %d exists.\n',ii);
        end;
    end;
end;
get_axis_scale(handles);
    
function edit1_Callback(hObject, eventdata, handles)
set_xaxis_scale(handles);

function edit2_Callback(hObject, eventdata, handles)
set_yaxis_scale(handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Nc = length(handles.eb);
v = [1:Nc]';
set(handles.listbox1,'value',v);
m_toggle_profile(handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.listbox1,'value',[]);
m_toggle_profile(handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% make all handles except axes1 invisible, then print it, and make them all
% visible again
m_make_handles_visible(handles,'off');
ri = get(handles.popupmenu1,'value');
a=convert_string_for_texoutput(handles.data.ratio{ri});
fdir = handles.data.fdir;
fname = [fdir,'eps',delimiter,a,'-z.eps'];
outdir = [fdir, 'eps', delimiter];
if ~isdir(outdir)
    mkdir(outdir);
    fprintf(1,'Directory %s did not exist, so it was created.\n',outdir);
end;
print_figure(handles.figure1,fname,handles.data.print_factor);
%fprintf(1,'Depth profiles of %s saved as %s\n',handles.data.ratio{ri},fname);
% create also PDF file, so that it can be included by pdflatex 
mepstopdf(fname,'epstopdf');
m_make_handles_visible(handles,'on');

function m_make_handles_visible(handles,vis)
set(handles.pushbutton1,'visible',vis);
set(handles.pushbutton2,'visible',vis);
set(handles.pushbutton3,'visible',vis);
set(handles.popupmenu1,'visible',vis);
set(handles.listbox1,'visible',vis);
set(handles.text1,'visible',vis);
set(handles.checkbox101, 'visible',vis);
set(handles.checkbox102, 'visible',vis);
set(handles.text2,'visible',vis);
set(handles.edit1,'visible',vis);
set(handles.text3,'visible',vis);
set(handles.edit2,'visible',vis);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

ri = get(handles.popupmenu1,'value');
handles = display_selected_mass(hObject,handles,ri);


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

function checkbox101_Callback(hObject, eventdata, handles)
if get(handles.checkbox101, 'value')
    set(handles.axes1,'yscale','log');
else
    set(handles.axes1,'yscale','lin');
end;
get_axis_scale(handles);
