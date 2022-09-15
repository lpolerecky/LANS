function varargout = overlay_external_nanosims_gui(varargin)
% MATLAB code for overlay_external_nanosims_gui.fig

% Last Modified by GUIDE v2.5 30-Oct-2011 21:47:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @overlay_external_nanosims_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @overlay_external_nanosims_gui_OutputFcn, ...
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


% --- Executes just before overlay_external_nanosims_gui is made visible.
function overlay_external_nanosims_gui_OpeningFcn(hObject, eventdata, handles, varargin)

global additional_settings;

if isfield(additional_settings,'defFontSize')
    defFontSize = additional_settings.defFontSize;
else 
    defFontSize=10;
end;

% Choose default command line output for lateral_profile_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if(nargin>3)
    handles.images = varargin{1};
    handles.scales = varargin{2};
    handles.ratios = varargin{3};   
    handles.fdir = varargin{4};
    handles.ext_im = varargin{5};
end;

% keep only non-empty images
jj=0;
for ii=1:length(handles.images)
    if ~isempty(handles.images{ii})
        jj=jj+1;
        im{jj} = handles.images{ii};
        s{jj} = handles.scales{ii};
        r{jj} = handles.ratios{ii};
    end;
end;
handles.images = im;
handles.scales = s;
handles.ratios = r;

set(handles.listbox1,'string',r);
    
handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lateral_profile_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = overlay_external_nanosims_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sk=str2num(my_get(handles.edit1,'string'));
if sk>1
    ext_im = wiener2(handles.ext_im,sk*[1 1]);
else
    ext_im = handles.ext_im;
end;

m=my_get(handles.listbox1,'value');
if length(m)>3
    fprintf(1,'Warning: more than 3 masses selected. Selecting first 3.\n');
    m=m(1:3);
end;

% assemble the rgb image
rgb_im = zeros(size(handles.images{1},1), size(handles.images{1},2),3);
for ii=1:length(m)
    rgb_im(:,:,ii) = (handles.images{m(ii)}-handles.scales{m(ii)}(1))/diff(handles.scales{m(ii)});
end;
ind = find(rgb_im<0);
rgb_im(ind)=zeros(size(ind));
ind = find(rgb_im>1);
rgb_im(ind)=ones(size(ind));

if isfield(handles,'fig')
    if ishandle(handles.fig)
        f1=figure(handles.fig);    
        s1=subplot(1,1,1);    
        curview=get(s1,'view');
    else
        f1=figure(50);
        s1=subplot(1,1,1);
        curview=[-30 60];
    end;
else
    f1=figure(50); 
    s1=subplot(1,1,1);
    curview=[-30 60];
end;
hold off;

[x,y]=meshgrid(1:size(rgb_im,1),1:size(rgb_im,2));
%tri=delaunay(x,y);
%trisurf(tri,x,y,ext_im,rgb_im);
if length(m)>1
    surf(x,y,ext_im,rgb_im);
else
    surf(x,y,ext_im,rgb_im(:,:,1));
    global additional_settings;
    colormap(get_colormap(additional_settings.colormap));
%    cmi=get(handles.popupmenu1,'value');
%    switch cmi
%        case 1, colormap(clut);
%        case 2, colormap(jet);
%        case 3, colormap(hsv);
%        case 4, colormap(hot);
%        case 5, colormap(cool);
%        case 6, colormap(spring);
%         case 7, colormap(summer);
%         case 8, colormap(autumn);
%         case 9, colormap(winter);
%         case 10, colormap(gray);
%         case 11, colormap(bone);
%         case 12, colormap(copper);
%         case 13, colormap(pink);            
%     end;
end;
% it is important to set the shading to flat to reduce the size of the
% output. setting it to interp does not make the output so much better
% anyway
shading flat

% add mesh lines to improve visibility of the hills and valleys
if get(handles.checkbox1,'value')==1
    gap=str2num(get(handles.edit2,'string'));
    col=get(handles.edit3,'string');
    meshlines_x = [1:gap:size(ext_im,1)];
    meshlines_y = [1:gap:size(ext_im,2)];
    hold on;
    for ii=1:length(meshlines_x)
        plot3(x(:,meshlines_x(ii)),y(:,meshlines_x(ii)),ext_im(:,meshlines_x(ii)),[col '-']);
    end;
    for ii=1:length(meshlines_y)
        plot3(x(meshlines_y(ii),:),y(meshlines_y(ii),:),ext_im(meshlines_y(ii),:),[col '-']);
    end;
end;

% add 3D contour lines to improve visibility of the hills and valleys
if get(handles.checkbox5,'value')==1
    nol=str2num(get(handles.edit9,'string'));
    col=get(handles.edit10,'string');
    hold on;
    contour3(x,y,ext_im,nol,[col '-']);
end;

% set the view
if sum(abs(curview-[0 90]))==0
    set(s1,'view',[-30 60]);
else
    set(s1,'view',curview);
end;
    
% tidy up the limits and ticks on the axes
[mi ma step]=get_scaling(x-1);
if get(handles.checkbox2,'value')==0
    set(s1,'xtick',[]);
else
    set(s1,'xtick',[mi : step : ma]);
end;
xlim([mi ma]);

[mi ma step]=get_scaling(y-1);
if get(handles.checkbox3,'value')==0
    set(s1,'ytick',[]);
else
    set(s1,'ytick',[mi : step : ma]);
end;
ylim([mi ma]);

[mi ma step]=get_scaling(ext_im);
if get(handles.checkbox4,'value')==0
    set(s1,'ztick',[]);
else
    set(s1,'ztick',[mi : step : ma]);
end;
zlim([mi ma]);

% add title
titstr = [handles.fdir ': ext(h)'];
rgbstr='rgb';
for ii=1:length(m)
    titstr = [titstr '+' handles.ratios{m(ii)}];
    if length(m)>1
        titstr = [titstr '(' rgbstr(ii) ')'];
    end;
end;
global additional_settings;
add_title(titstr, additional_settings.title_length, additional_settings.defFontSize);

handles.fig = f1;

guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global additional_settings;

% assemble the output filename
m=my_get(handles.listbox1,'value');
if length(m)>3
    fprintf(1,'Warning: more than 3 masses selected. Selecting first 3.\n');
    m=m(1:3);
end;
outf = 'ext';
for ii=1:length(m)
    outf = [outf '-vs-' handles.ratios{m(ii)}];
end;
outf=convert_string_for_texoutput(outf);

fdir = [handles.fdir,'eps'];
fname1 = [fdir delimiter outf '.eps'];
if ~isdir(fdir)
    mkdir(fdir);
    fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
end;

fdir = [handles.fdir,'tif'];
fname2 = [fdir delimiter outf '.tif'];
if ~isdir(fdir)
    mkdir(fdir);
    fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
end;

% export the graph as EPS+PDF or TIF
if isfield(handles,'fig')
    f1=handles.fig;
    figure(f1);
    rr=get(f1,'renderer');
    % export as EPS/PDF
    if length(m)==1
        % this is very important for proper rendering of the eps output!
        set(f1,'renderer','painters')
        fprintf(1,'*** Exporting figure as EPS/PDF.\nPatience please, this may take a few seconds if the resolution of the image is large.\n');
        print_figure(f1,fname1,additional_settings.print_factors(1));
        mepstopdf(fname1,'epstopdf');
        fprintf(1,'Export done.\n');
    end;
    % export also as TIF
    set(f1,'renderer','zbuffer');
    print(f1,fname2,'-dtiff');
    fprintf(1,'Overlay exported in %s\n',fname2);
    % set the renderer to what it was originally
    set(f1,'renderer',rr);        
end;

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
