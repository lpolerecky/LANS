function varargout = display_transparent_overlay_gui(varargin)
% DISPLAY_TRANSPARENT_OVERLAY_GUI MATLAB code for display_transparent_overlay_gui.fig
%      DISPLAY_TRANSPARENT_OVERLAY_GUI, by itself, creates a new DISPLAY_TRANSPARENT_OVERLAY_GUI or raises the existing
%      singleton*.
%
%      H = DISPLAY_TRANSPARENT_OVERLAY_GUI returns the handle to a new DISPLAY_TRANSPARENT_OVERLAY_GUI or the handle to
%      the existing singleton*.
%
%      DISPLAY_TRANSPARENT_OVERLAY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAY_TRANSPARENT_OVERLAY_GUI.M with the given input arguments.
%
%      DISPLAY_TRANSPARENT_OVERLAY_GUI('Property','Value',...) creates a new DISPLAY_TRANSPARENT_OVERLAY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before display_transparent_overlay_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to display_transparent_overlay_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help display_transparent_overlay_gui

% Last Modified by GUIDE v2.5 04-Jun-2018 13:19:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @display_transparent_overlay_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @display_transparent_overlay_gui_OutputFcn, ...
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


% --- Executes just before display_transparent_overlay_gui is made visible.
function display_transparent_overlay_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to display_transparent_overlay_gui (see VARARGIN)

% Choose default command line output for display_transparent_overlay_gui
handles.output = hObject;

if nargin>3
    rgb=varargin{1};
    bw=varargin{2};
    rgb_points = varargin{3};
    bw_points = varargin{4};  
    rgb_points_color_symbol = varargin{5};
    bw_points_color_symbol = varargin{6};
    alpha = 0.5;
    tit=varargin{7};
else
    a = zeros(3,3,3);
    a(:,:,1) = [1 2 3; 1 2 3; 1 2 3];
    a(:,:,2) = [1 1 1; 2 2 2; 3 3 3];
    a(:,:,3) = [1 2 3; 2 3 2; 3 2 1];
    rgb = a/max(a(:));
    bw = ones(size(a));
    rgb_points = [1 2 3];
    bw_points = [1 2 3];
    rgb_points_color_symbol = 'kx';
    bw_points_color_symbol = 'k+';
    alpha = 0.5;
    tit='Empty title';
end

figpos = get(handles.figure1,'Position');
if isempty(handles.axes1.Children)
    figpos(1:2) = 100;
    set(handles.figure1,'Position',figpos);
end
handles.output = handles.figure1;
        
axes(handles.axes1);
hold off;
imagesc(rgb);
hold on
handles.h = imagesc(bw);
colormap(gray);
plot(rgb_points(:,1),rgb_points(:,2),rgb_points_color_symbol,...
    'markerfacecolor',[1 1 1],'markersize',12,'linewidth',2);
plot(bw_points(:,1),bw_points(:,2),bw_points_color_symbol,...
    'markerfacecolor',[1 1 1],'markersize',12,'linewidth',2);
hold off;
set(handles.h, 'AlphaData', alpha);

set(handles.text2,'String',tit);
set(handles.axes1,'xcolor',[1 1 1],'ycolor',[1 1 1],...
            'FontSize',8,'color',0.0*[1 1 1]);    
handles.xlim_orig = xlim;
handles.ylim_orig = ylim;
handles.alpha = 0.5;
global rgb_newxLim rgb_newyLim;
rgb_newxLim = xlim;
rgb_newyLim = ylim;
handles.shown_rgb = [1 1 1];
handles.rgb = rgb;
handles.bw = bw;

handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes display_transparent_overlay_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = display_transparent_overlay_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% function update_image(hObject, eventdata, handles)
% origa = handles.image;
% shown_rgb = handles.shown_rgb;
% ax=handles.axes1;
% imdata = ax.Children.CData;
% for dim=1:length(shown_rgb)
%     if shown_rgb(dim)==1
%         imdata(:,:,dim) = origa(:,:,dim);
%     else
%         imdata(:,:,dim) = 0;
%     end
% end
% origa=0;
% ax.Children.CData = imdata;
% guidata(hObject, handles);


% --------------------------------------------------------------------
%function view_rgb_Callback(hObject, eventdata, handles)
% hObject    handle to view_rgb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% function hide_rgb_Callback(hObject,eventdata,handles)
% if hObject == handles.hide_red
%     if strcmp(get(handles.hide_red,'checked'),'on')
%         set(handles.hide_red,'Checked','off','Text','Red hidden');
%     else
%         set(handles.hide_red,'Checked','on','Text','Red shown');
%     end
% elseif hObject == handles.hide_green
%     if strcmp(get(handles.hide_green,'checked'),'on')
%         set(handles.hide_green,'Checked','off','Text','Green hidden');
%     else
%         set(handles.hide_green,'Checked','on','Text','Green shown');
%     end
% elseif hObject == handles.hide_blue
%     if strcmp(get(handles.hide_blue,'checked'),'on')
%         set(handles.hide_blue,'Checked','off','Text','Blue hidden');
%     else
%         set(handles.hide_blue,'Checked','on','Text','Blue shown');
%     end
% end
% handles.shown_rgb = ...
%     [strcmp(get(handles.hide_red,'checked'),'on'),...
%     strcmp(get(handles.hide_green,'checked'),'on'),...
%     strcmp(get(handles.hide_blue,'checked'),'on')];
% update_image(hObject, eventdata, handles);
% 
% guidata(hObject, handles);

% --------------------------------------------------------------------
%function hide_red_Callback(hObject, eventdata, handles)
% hObject    handle to hide_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hide_rgb_Callback(hObject,eventdata,handles);

% --------------------------------------------------------------------
%function hide_green_Callback(hObject, eventdata, handles)
% hObject    handle to hide_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hide_rgb_Callback(hObject,eventdata,handles);

% --------------------------------------------------------------------
%function hide_blue_Callback(hObject, eventdata, handles)
% hObject    handle to hide_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hide_rgb_Callback(hObject,eventdata,handles);

% --------------------------------------------------------------------
function zoom_menu_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function zoomin_tool_Callback(hObject,eventdata,handles)

if strcmp(get(hObject,'checked'),'off')
    h = zoom;
    fprintf(1,'**************************************************************\n')
    fprintf(1,'Select the zoomed-in region in the image, THEN\n');
    fprintf(1,'Select Zoom -> "Zoom DISABLE" to quit the zoom-in mode, THEN\n');
    fprintf(1,'Continue with other actions.\n');
    fprintf(1,'**************************************************************\n')
    h.ActionPreCallback = @myprecallback;
    h.ActionPostCallback = @mypostcallback;
    h.Enable = 'on';   
    set(hObject,'label','Zoom DISABLE');
    set(handles.figure1,'Color',[1 1 1]*0.6);
    set(handles.text2,'BackgroundColor',[1 1 1]*0.6);
%    set(handles.text3,'BackgroundColor',[1 1 1]*0.6);
    set(hObject,'Checked','on');
else
    zoom off;
    set(hObject,'checked','off', 'label', 'Zoom ENABLE');
    set(handles.figure1,'Color',[1 1 1]*0);
    set(handles.text2,'BackgroundColor',[1 1 1]*0);
%    set(handles.text3,'BackgroundColor',[1 1 1]*0);
    global rgb_newxLim rgb_newyLim;
    xlim(rgb_newxLim);
    ylim(rgb_newyLim);    
end

function myprecallback(obj,evd)
global rgb_newxLim rgb_newyLim;
rgb_newxLim = get(evd.Axes,'XLim');
rgb_newyLim = get(evd.Axes,'YLim');
%fprintf(1,'PreCall: X-Limits and Y-Limits are [%.2f %.2f] [%.2f %.2f]\n',rgb_newxLim,rgb_newyLim);

function mypostcallback(obj,evd)
global rgb_newxLim rgb_newyLim;
rgb_newxLim = get(evd.Axes,'XLim');
rgb_newyLim = get(evd.Axes,'YLim');
fprintf(1,'New X-Limits: [%.2f %.2f]; new Y-Limits: [%.2f %.2f];\n',rgb_newxLim,rgb_newyLim);

function zoomout_tool_Callback(hObject,eventdata,handles)
%fprintf(1,'Click on the image to zoom out\n');
xlim(handles.xlim_orig);
ylim(handles.ylim_orig);
global rgb_newxLim rgb_newyLim;
rgb_newxLim = handles.xlim_orig;
rgb_newyLim = handles.ylim_orig;
fprintf(1,'New X-Limits: [%.2f %.2f]; new Y-Limits: [%.2f %.2f];\n',rgb_newxLim,rgb_newyLim);

% --------------------------------------------------------------------
function transparency_menu_Callback(hObject, eventdata, handles)
% hObject    handle to transparency_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function increase_t_Callback(hObject, eventdata, handles)
% hObject    handle to increase_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.alpha = handles.alpha + 0.1;
if handles.alpha>1
    handles.alpha=1;
end
%set(handles.h,'AlphaData', handles.alpha*handles.bw);
set(handles.h,'AlphaData', handles.alpha);
guidata(hObject, handles);
fprintf(1,'Transparency set to %.2f\n',handles.alpha);

% --------------------------------------------------------------------
function decrease_t_Callback(hObject, eventdata, handles)
% hObject    handle to decrease_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.alpha = handles.alpha - 0.1;
if handles.alpha<0
    handles.alpha=0;
end
%set(handles.h,'AlphaData', handles.alpha*handles.bw);
set(handles.h,'AlphaData', handles.alpha);
guidata(hObject, handles);
fprintf(1,'Transparency set to %.2f\n',handles.alpha);


% --------------------------------------------------------------------
function set_t_1_Callback(hObject, eventdata, handles)
% hObject    handle to set_t_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.h,'AlphaData', 1);

% --------------------------------------------------------------------
function set_t_0_Callback(hObject, eventdata, handles)
% hObject    handle to set_t_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.h,'AlphaData', 0);


% --------------------------------------------------------------------
function move_view_Callback(hObject, eventdata, handles)
% hObject    handle to move_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global rgb_newxLim rgb_newyLim;

fprintf(1,'*** Interactive centering of view field of view\n');
fprintf(1,'Left-click on the image to center the view to the clicked point.\n');
fprintf(1,'Right-click, Esc or Enter to stop.\n');

set(gcf, 'pointer', 'cross');

m=1; p=[];
while m~=3 & m~=13 & m~=27
        
    [x y m ax] = my_ginput(handles.figure1);
    x=round(x);
    y=round(y);
    if isempty(m)
        m=3;
    end

    if m==1
        dx = diff(rgb_newxLim);
        dy = diff(rgb_newyLim);
        rgb_newxLim = x+dx/2*[-1 1];
        rgb_newyLim = y+dx/2*[-1 1];
        set(ax,'xlim',rgb_newxLim,'ylim',rgb_newyLim);
    end
    
end

set(gcf, 'pointer', 'arrow');
