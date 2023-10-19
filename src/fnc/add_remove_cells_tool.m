function varargout = add_remove_cells_tool(varargin)
% ADD_REMOVE_CELLS_TOOL M-file for add_remove_cells_tool.fig
%      ADD_REMOVE_CELLS_TOOL, by itself, creates a new ADD_REMOVE_CELLS_TOOL or raises the existing
%      singleton*.
%
%      H = ADD_REMOVE_CELLS_TOOL2 returns the handle to a new ADD_REMOVE_CELLS_TOOL or the handle to
%      the existing singleton*.
%
%      ADD_REMOVE_CELLS_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADD_REMOVE_CELLS_TOOL.M with the given input arguments.
%
%      ADD_REMOVE_CELLS_TOOL('Property','Value',...) creates a new ADD_REMOVE_CELLS_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before add_remove_cells_tool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to add_remove_cells_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help add_remove_cells_tool

% Last Modified by GUIDE v2.5 15-Jun-2010 11:00:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @add_remove_cells_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @add_remove_cells_tool_OutputFcn, ...
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

function select_interactive_channel_Callback(hObject, eventdata, handles, varargin)


% --- Executes just before add_remove_cells_tool is made visible.
function add_remove_cells_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to add_remove_cells_tool (see VARARGIN)

%guidata(hObject, handles);
if nargin>3
    if strcmp(varargin{1},'ButtonDownFnc')
        fprintf(1,'Say hi\n');
    end
    
end

if(nargin>3)
    handles.maskmass = varargin{1};
    handles.maskimg = varargin{2};    
    handles.mass = varargin{3};
    handles.ps = varargin{4};
    handles.fdir = varargin{5};
    handles.coc = varargin{6};

    oc = handles.coc;
    if length(oc)>1
        ind=find((double(oc)>=double('0') & double(oc)<=double('9')) | double(oc)==double('.'));
        ind=setdiff([1:length(oc)],ind);
        handles.coc=oc(ind);
    end

    handles.output = varargin{7};
    [a b c]=fileparts(varargin{7});
    global CELLSFILE 
    CELLSFILE = b;
    
    global shown_rgb;
    shown_rgb=[0 0 0];
    
    handles.bw = varargin{8};
    handles.ic = 1; % default interactive channel
    handles.cellfile = varargin{9};
    if(size(handles.maskmass,3)==1)
        set(handles.select_interactive_channel,'Visible','off');
        % by default, set all values in the image that are <min to min and
        % >max to max, where min=min(ps) and max=max(ps)
        ind=find(handles.maskmass<min(handles.ps));
        handles.maskmass(ind)=min(handles.ps)*ones(size(ind));
        ind=find(handles.maskmass>max(handles.ps));
        handles.maskmass(ind)=max(handles.ps)*ones(size(ind));
        shown_rgb(1)=1;
        fprintf(1,'Scaling of the ROI definition template image: [%f %f]\n',handles.ps);
    else
        ic_set = 0;
        if max(max(squeeze(handles.maskmass(:,:,1))))>0
            shown_rgb(1)=1;
            set(handles.hide_red,'checked','on');
            handles.ic = 1;
            set(handles.ic_red,'checked','on','enable','on');
            ic_set = 1;            
        else
            set(handles.hide_red,'checked','off','enable','off');
            set(handles.ic_red,'checked','off','enable','off');            
        end
        if max(max(squeeze(handles.maskmass(:,:,2))))>0
            shown_rgb(2)=1;
            set(handles.hide_green,'checked','on');
            if ~ic_set
                handles.ic = 2;
                set(handles.ic_green,'checked','on','enable','on');
                ic_set = 1;
            end
        else
            set(handles.hide_green,'checked','off','enable','off');
            set(handles.ic_green,'checked','off','enable','off');
        end
        if max(max(squeeze(handles.maskmass(:,:,3))))>0
            shown_rgb(3)=1;
            set(handles.hide_blue,'checked','on');
            if ~ic_set
                handles.ic = 3;
                set(handles.ic_blue,'checked','on','enable','on');
                ic_set = 1;
            end
        else
            set(handles.hide_blue,'checked','off','enable','off');
            set(handles.ic_blue,'checked','off','enable','off');
        end  
    end
    
    handles.mag_factor = varargin{10};
    
    update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,1);
    set(handles.figure1,'Name',['Define ROIs using image ',handles.mass]);
else
    set(handles.figure1,'Name',['Define ROIs']);
    handles.maskimg = ones(256,256);
    global CELLSFILE;
    handles.output = CELLSFILE;
end

set(handles.auto_class_update,'Checked',~isempty(handles.cellfile));
if ~isempty(handles.cellfile)
    fprintf(1,'NOTE: ROIs and ROI classification file are now linked. Update of ROIs will lead to automated update of ROI classification.\n');
    fprintf(1,'      Use "Action -> Link ROI classification file" to change this behavior.\n');
end

handles.oldmaskimg = handles.maskimg;

%set(handles.axes1,'xtick',[],'ytick',[],'box','on')
set(handles.axes1,'box','on','xcolor',[1 1 1],'ycolor',[1 1 1]);%,'xtick',[0:50:256],'ytick',[0:50:256])

% define default initial threshold for interactive thresholding
handles.thr=0.5;

% cells were saved by default, when entering the tool
handles.cells_saved = 1;

% Choose default command line output for add_remove_cells_tool
%handles.maskfile = 'cells.mat';

handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

%set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes add_remove_cells_tool wait for user response (see UIRESUME)
%%uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = add_remove_cells_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
%%delete(handles.figure1);

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fp=get(handles.figure1,'position');
% when units are characters
if strcmp(get(handles.axes1,'units'),'characters')
    set(handles.axes1,'position',[4.8 1.8461 (min([fp(3) fp(4)*2.6])-4.8*2)*[1 1/2.6]]);
end;
% when units are pixels
if strcmp(get(handles.axes1,'units'),'pixels')
    set(handles.axes1,'position',[30 25 (min(fp(3:4))-50)*[1 1]]);
end;
set(handles.text1,'Position',[30 (min(fp(3:4))-16) (min(fp(3:4))-50) 16]);


% --------------------------------------------------------------------
function quittool_Callback(hObject, eventdata, handles)
% hObject    handle to quittool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=1;

global CELLSFILE MAT_EXT;

if(isfield(handles,'cells_saved') & ~handles.cells_saved)
   a=yes_no_dialog('title','Are you sure you want to quit?',...
    'stringa','No, I want to continue.',...
    'stringb',sprintf('Save ROIs to %s%s and quit.',CELLSFILE,MAT_EXT),...
    'stringc','Quit without saving the ROIs.');
else
    a=2;
end;

if(a==0)
    Maskimg = handles.maskimg;
    eval(['save ',handles.fdir,CELLSFILE,MAT_EXT,' -v6 Maskimg']);
    disp(['ROIs saved as ',handles.fdir,CELLSFILE,MAT_EXT]);
    handles.output = CELLSFILE;
end;

guidata(hObject, handles);

if(a==2 | a==0)    
    %%uiresume(handles.figure1);
    if isempty(handles)
        handles.figure1 = gcf;
    end
    figure1_CloseRequestFcn(handles.figure1, eventdata, handles);
end;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure

%handles.output = handles.maskfile;
if isequal(get(hObject, 'waitstatus'), 'waiting')
    %fprintf(1,'Debug: Figure was waiting, now it is resumed.\n');
    uiresume(hObject);
else
    %fprintf(1,'Debug: figure was not waiting, so it will be just closed.\n');
    delete(hObject);
end
%guidata(hObject, handles);
%disp(['Cells definition tool was finished.']);
%delete(hObject);

function define_grid_Callback(hObject, eventdata, handles)

im=handles.maskmass;
fprintf(1,'Size of the image: %d x %d\n',size(im,1),size(im,2));
a=input('Enter number of (square) grid cells per image width: ');
a=double(a);
if isempty(a)
    a=1;
end
if a>size(im,2), a=size(im,2); end
if a<1, a=1; end
w=size(im,2);
h=size(im,1);
wg=ceil(w/a);
% calculate the positions of the ROI separators
e2=[0:wg:w+10];
e1=[0:wg:h+10];
e=linspace(0,size(im,2)+1,a+1);
ind1=[1:h];
ind2=[1:w];
% mask defined by the grid
maskimg_grid=zeros(size(im));
cellid=0;
for x=1:(length(e2)-1)
    for y=1:(length(e1)-1)
        i=find(ind2>e2(x) & ind2<=e2(x+1));
        j=find(ind1>e1(y) & ind1<=e1(y+1));
        indx=ind2(i);
        indy=ind1(j);
        if ~isempty(indx) & ~isempty(indy)
            cellid=cellid+1; 
            maskimg_grid(indy,indx)=cellid*ones(length(indy),length(indx));
        end
    end
end

if 0
    figure;
    imagesc(maskimg_grid); colorbar; colormap(clut(256));
    a=0;
end

if strcmp(get(handles.auto_class_update,'checked'),'on') && ~isempty(handles.cellfile)
    cellfile = [handles.fdir handles.cellfile];
    fid=fopen(cellfile,'w');
    if fid>0
        for i=1:length(unique(maskimg_grid))
            fprintf(1,'%d\ti\n',i);
        end;
        fclose(fid);
        fprintf(1,'ROI classification updated in %s\n',cellfile);
    end
end

handles.maskimg = maskimg_grid;
handles.cells_saved = 0;
guidata(hObject, handles);

% draw the cell outlines
update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));


function define_rois_logical_Callback(hObject, eventdata, handles)

if size(handles.maskmass,3)==1
    
    fprintf(1,'Scaling of the ROI definition template image: [%.6f %.6f]\n',handles.ps);
    fprintf(1,'-------------------------------------\n');
    fprintf(1,'ROI definition by logical expression.\n');
    fprintf(1,'Examples:\n  r<2 ... selects all pixels with values < 2\n');
    fprintf(1,'  r>=-3 ... selects all pixels with values >= -3\n');
    fprintf(1,'  r>-1 & r<=2 ... selects all pixels with values > -1 AND <= 2\n');
    fprintf(1,'  r<=1 | r>2 ... selects all pixels with values <= 1 OR > 2\n');
    fprintf(1,'-------------------------------------\n');
    
    answer = inputdlg('Define valid logical expression (see Command window for examples):','Define ROI through logic',1,{''});
    if isempty(answer)
        a = [];
    else
        a = answer{1};
    end;

    %a=input('Define valid logical expression (Ctrl+C for interrupt): ','s');
    
    r=handles.maskmass;

else
    
    % when the mask template image is an RGB image
    r(:,:)=handles.maskmass(:,:,1);
    g(:,:)=handles.maskmass(:,:,2);
    b(:,:)=handles.maskmass(:,:,3);
    
    fprintf(1,'Scaling of the ROI definition template image:\n');
    fprintf(1,' RED channel: [%.6f %.6f]\n',min(r(:)),max(r(:)));
    fprintf(1,' GREEN channel: [%.6f %.6f]\n',min(g(:)),max(g(:)));
    fprintf(1,' BLUE channel: [%.6f %.6f]\n',min(b(:)),max(b(:)));
    fprintf(1,'---------------------------------------------------\n');
    fprintf(1,'ROI definition by logical expression.\n');
    fprintf(1,'Examples:\n  r>0.3 ... selects all pixels with RED values > 0.3\n');
    fprintf(1,'  r>0.5 & g<=0.7 ... selects all pixels with RED values > 0.5 AND GREEN values <= 0.7\n');
    fprintf(1,'  r>0.5 | g>0.4 | b>0.8 ... selects all pixels with RED values > 0.5 OR GREEN values > 0.4 OR BLUE values > 0.8\n');
    fprintf(1,'---------------------------------------------------\n');
    
    answer = inputdlg('Define valid logical expression (see Command window for examples):','Define ROI through logic',1,{''});
    if isempty(answer)
        a = [];
    else
        a = answer{1};
    end;
    
    %a=input('Define valid logical expression (Ctrl+C for interrupt): ','s');

end;

if ~isempty(a)
    
    % find the indices of the pixels that satisfy the condition
    ind=eval(['find(',a,');']);

    if isempty(ind)

        fprintf(1,'No pixels satisfying condition %s found.\n',a);
        fprintf(1,'Please verify the syntax and try again.\n');

    else

        fprintf(1,'%d pixels satisfying the condition %s found.\n',length(ind),a);    

        % fill pixels that satisfy the condition with ones
        m=zeros(size(r));
        m(ind)=ones(size(ind)); % m now contains all pixels that satisfy the logical condition given by the user

        % label connected components as ROIs
        L = bwlabel(m,4);

        % add ROIs that contain >4 pixels
        fprintf(1,'%d new ROIs defined.\n',max(L(:)));
        fprintf(1,'Adding only ROIs that contain more than 4 pixels ... ');
        CELLS=handles.maskimg;
        cnt=max(CELLS(:));
    %    added_cell=zeros(size(r));
        for i=1:max(L(:))
            ind=find(L==i);
            if length(ind)>4
                cnt=cnt+1;
                CELLS(ind) = cnt*ones(size(ind));
                % rearrange and sort the cells, auto-update the classification file
                [CELLS, ~, old2new] = rearrange_sort_cells(CELLS);
                autoupdate_cell_classification(CELLS, ind, old2new, ...
                    handles.cellfile, handles.auto_class_update);
            end
        end
        handles.maskimg = CELLS;    
        handles.cells_saved = 0;

        fprintf(1,'Done.\n');        

        guidata(hObject, handles);

        % draw the cell outlines
        update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
                handles.figure1,handles.maskimg, handles.coc, handles.bw,...
                strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));

    end;
end;

b=0;

function draw_ellipse_Callback(hObject, eventdata, handles)

h=add_ellipse(handles.axes1);

boundary_type=yes_no_dialog('title','Add the ellipse to the list of ROIs?',...
    'stringa','Yes', 'stringb','No', 'stringc','');

if(boundary_type==1)
    [added_cell, ind] = roi2cell(h, 0);
    if isempty(handles.maskimg)
        handles.maskimg = zeros(size(handles.maskmass));
    end
    handles.maskimg = add_cell(handles.maskimg, added_cell);
    handles.cells_saved = 0;
    [handles.maskimg, ~, old2new]=rearrange_sort_cells(handles.maskimg);
    autoupdate_cell_classification(handles.maskimg, ind, old2new, ...
            handles.cellfile, handles.auto_class_update);    
    handles.cells_saved = 0;
end

guidata(hObject, handles);

update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
delete(h);
    
%%uiwait(handles.figure1);

function draw_rectangle_Callback(hObject, eventdata, handles)

h=add_rectangle(handles.axes1);

boundary_type=yes_no_dialog('title','Add the rectangle to the list of ROIs?',...
    'stringa','Yes', 'stringb','No', 'stringc','');

if(boundary_type==1)
    [added_cell, ind] = roi2cell(h, 1);
    if isempty(handles.maskimg)
        handles.maskimg = zeros(size(handles.maskmass));
    end
    handles.maskimg = add_cell(handles.maskimg, added_cell);
    handles.cells_saved = 0;
    [handles.maskimg,~,old2new]=rearrange_sort_cells(handles.maskimg);
    autoupdate_cell_classification(handles.maskimg, ind, old2new, ...
            handles.cellfile, handles.auto_class_update);
    handles.cells_saved = 0;
end

guidata(hObject, handles);

update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
delete(h);
    
%%uiwait(handles.figure1);

function take_coarse_Callback(hObject, eventdata, handles)
if(hObject == handles.take_coarse_line)
    set(handles.take_coarse_line,'Checked','on');
    set(handles.take_circum_ellipse,'Checked','off');
    set(handles.always_ask,'Checked','off');
else
    if(hObject == handles.take_circum_ellipse)
        set(handles.take_coarse_line,'Checked','off');
        set(handles.take_circum_ellipse,'Checked','on');
        set(handles.always_ask,'Checked','off'); 
    else
        if(hObject == handles.always_ask)
            set(handles.take_coarse_line,'Checked','off');
            set(handles.take_circum_ellipse,'Checked','off');
            set(handles.always_ask,'Checked','on'); 
        end;
    end;
end;

% --------------------------------------------------------------------
function draw_roi_Callback(hObject, eventdata, handles)
% hObject    handle to draw_roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=add_freehand(handles.axes1,1);

if(strcmp(get(handles.always_ask,'Checked'),'on'))
    boundary_type=yes_no_dialog('title','How should the ROI be drawn?',...
        'stringa','Take the coarse drawn line',...
        'stringb','Take the circumscribing ellipse',...
        'stringc','Do not take anything');
else
    if(strcmp(get(handles.take_coarse_line,'Checked'),'on'))
        boundary_type=1;
    else
        boundary_type = 0;
    end
end

% add the newly defined roi object to the list of all valid roi objects
if boundary_type~=2
    [added_cell, ind] = roi2cell(h, boundary_type);
    if isempty(handles.maskimg)
        handles.maskimg = zeros(size(handles.maskmass));
    end
    handles.maskimg = add_cell(handles.maskimg, added_cell);
    handles.cells_saved = 0;
    [handles.maskimg,~,old2new]=rearrange_sort_cells(handles.maskimg);
    autoupdate_cell_classification(handles.maskimg, ind, old2new, ...
            handles.cellfile, handles.auto_class_update);
    handles.cells_saved = 0;
end

%t1=now();

% Update handles structure
guidata(hObject, handles);

update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
delete(h);

%%uiwait(handles.figure1);
%uiwait(handles.figure1);


%update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
%    handles.figure1,handles.maskimg, handles.coc, handles.bw);

%t2=now();

%fprintf(1,'Took %f seconds\n',(t2-t1)*24*3600);


function zoomin_tool_Callback(hObject,eventdata,handles)

if strcmp(get(hObject,'checked'),'off')
    h = zoom;
%if strcmp(h.Enable,'off')
    fprintf(1,'**************************************************************\n')
    fprintf(1,'Select the zoomed-in region in the image, THEN\n');
    fprintf(1,'Select Zoom -> "Zoom DISABLE" to quit the zoom-in mode, THEN\n');
    fprintf(1,'Continue with other actions.\n');
    fprintf(1,'**************************************************************\n')
    h.ActionPreCallback = @myprecallback;
    h.ActionPostCallback = @mypostcallback;
    h.Enable = 'on';   
    %zoom on;
    %set(hObject,'checked','on');
    set(hObject,'label','Zoom DISABLE');
    set(handles.figure1,'Color',[1 1 1]*0.6);
    set(handles.text1,'BackgroundColor',[1 1 1]*0.6);
    set(hObject,'Checked','on');
else
    %h.Enable = 'off';
    zoom off;
    set(hObject,'checked','off', 'label', 'Zoom ENABLE');
    %set(hObject,'label','Zoom ENABLE');
    set(handles.figure1,'Color',[1 1 1]*0);
    set(handles.text1,'BackgroundColor',[1 1 1]*0);
    global newxLim newyLim;
    xlim(newxLim);
    ylim(newyLim);
    
    % update ROI outlines within the viewed area
    update_ROI_outlines_within_viewed_area(handles,newxLim, newyLim);
    
end

function myprecallback(obj,evd)
global newxLim newyLim;
newxLim = get(evd.Axes,'XLim');
newyLim = get(evd.Axes,'YLim');
%fprintf(1,'PreCall: X-Limits and Y-Limits are [%.2f %.2f] [%.2f %.2f]\n',newxLim,newyLim);

function mypostcallback(obj,evd)
global newxLim newyLim;
newxLim = get(evd.Axes,'XLim');
newyLim = get(evd.Axes,'YLim');
fprintf(1,'New X-Limits and Y-Limits are [%.2f %.2f] [%.2f %.2f]\n',newxLim,newyLim);


function zoomout_tool_Callback(hObject,eventdata,handles)
%fprintf(1,'Click on the image to zoom out\n');
xlim([0.5 size(handles.maskimg,2)+0.5]);
ylim([0.5 size(handles.maskimg,1)+0.5]);
global newxLim newyLim;
newxLim = xlim;
newyLim = ylim;
% update ROI outlines within the viewed area
update_ROI_outlines_within_viewed_area(handles,newxLim, newyLim);


function zoomout_after_ROIdef_Callback(hObject,eventdata,handles)
if(strcmp(get(hObject,'Checked'),'on'))
    set(hObject,'Checked','off');
else
    set(hObject,'Checked','on');
end
% update ROI outlines within the viewed area
update_ROI_outlines_within_viewed_area(handles,newxLim, newyLim);

function hide_rgb_Callback(hObject,eventdata,handles)
if hObject == handles.hide_red
    if strcmp(get(handles.hide_red,'checked'),'on')
        set(handles.hide_red,'Checked','off','Label','Red hidden');
    else
        set(handles.hide_red,'Checked','on','Label','Red shown');
    end
elseif hObject == handles.hide_green
    if strcmp(get(handles.hide_green,'checked'),'on')
        set(handles.hide_green,'Checked','off','Label','Green hidden');
    else
        set(handles.hide_green,'Checked','on','Label','Green shown');
    end
elseif hObject == handles.hide_blue
    if strcmp(get(handles.hide_blue,'checked'),'on')
        set(handles.hide_blue,'Checked','off','Label','Blue hidden');
    else
        set(handles.hide_blue,'Checked','on','Label','Blue shown');
    end
end
global shown_rgb;
shown_rgb = [strcmp(get(handles.hide_red,'checked'),'on'),...
    strcmp(get(handles.hide_green,'checked'),'on'),...
    strcmp(get(handles.hide_blue,'checked'),'on')];
guidata(hObject, handles);
rgb = zeros(size(handles.maskmass));
for i=1:size(rgb,3)
    if sum(shown_rgb)==1
        rgb(:,:,i) = handles.maskmass(:,:,find(shown_rgb==1));
    else
        if shown_rgb(i)
            rgb(:,:,i) = handles.maskmass(:,:,i);
        end
    end
end
ch = handles.axes1.Children;
k=[];
for i=1:length(ch)
    if strcmp(get(ch(i),'type'),'image')
        k=i;
        break;
    end
end
if ~isempty(k)
    ch = ch(k);
    set(ch,'CData',rgb);
end

% update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
%      handles.figure1,handles.maskimg, handles.coc, handles.bw,...
%      strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));

function ic_red_Callback(hObject,eventdata,handles)
set(handles.ic_red,'Checked','on');
set(handles.ic_green,'Checked','off');
set(handles.ic_blue,'Checked','off');
handles.ic = 1;
guidata(hObject, handles);

function ic_green_Callback(hObject,eventdata,handles)
set(handles.ic_red,'Checked','off');
set(handles.ic_green,'Checked','on');
set(handles.ic_blue,'Checked','off');
handles.ic = 2;
guidata(hObject, handles);

function ic_blue_Callback(hObject,eventdata,handles)
set(handles.ic_red,'Checked','off');
set(handles.ic_green,'Checked','off');
set(handles.ic_blue,'Checked','on');
handles.ic = 3;
guidata(hObject, handles);

function auto_class_update_Callback(hObject,eventdata,handles)
global CELLSFILE
def_file = [handles.fdir CELLSFILE '.dat'];
fprintf(1,'\n*** Select ROIs classification file (default %s)\n    Press cancel to unlink the ROI classification file.\n',def_file);
[FileName,newdir,newext] = uigetfile('*.dat',['Select ROIs classification file (e.g. ' CELLSFILE '.dat)'], def_file);    
if(FileName~=0)
   cellfile = [newdir, FileName];
   handles.cellfile = cellfile;
else
   handles.cellfile = [];
end
set(handles.auto_class_update,'Checked',~isempty(handles.cellfile));
if strcmp(get(handles.auto_class_update,'Checked'),'on')
    fprintf(1,'ROIs file: %s\n', [handles.fdir handles.output]);
    fprintf(1,'ROIs classification file: %s\n', handles.cellfile);    
    fprintf(1,'ROIs and ROIs classifications are now LINKED.\n');
else
    fprintf(1,'ROIs and ROIs classifications are now UNLINKED.\n');
end
guidata(hObject, handles);
% activate the main GUI at the end
figure(handles.figure1);

function ButtonDownFcn(hObject, eventdata, handles)
cp = round(get(gca,'CurrentPoint'));
img=handles.maskimg;
if cp(1,1)>0 && cp(1,1)<=size(img,2) && cp(1,2)>0 && cp(1,2)<=size(img,1)
    roi_id = img(cp(1,2),cp(1,1));
    roi_pix = length( find(img==roi_id) );
    on_roi = sprintf(' on PIXEL [x,y]=[%d,%d] (ROI %d, size %d pixels)', cp(1,1:2), roi_id, roi_pix);
else
    on_roi = [];
end
fprintf(1,'Mouse button pressed%s\n',on_roi);


function KeyPressFcn(hObject, eventdata, handles)
character_type=get(handles.figure1,'CurrentCharacter');
global verbose
if verbose
    fprintf(1,'Key %d pressed\n',double(character_type))
end

% --------------------------------------------------------------------
function interactive_thresholding_Callback(hObject, eventdata, handles)
% hObject    handle to interactive_thresholding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Maskimg = handles.maskmass(:,:,handles.ic);
CELLS = handles.maskimg;
if(isempty(CELLS))
    ncells=0;
    CELLS = zeros(size(Maskimg));
else
    ncells=max(CELLS(:));
end;

disp('*** Interactive definition of cells.');
disp(' - Left-click        = select cell center;');
disp(' - Up/Down arrows    = change local threshold for automatic cell selection;');
disp(' - h/l keys          = same as Up/Down;');
disp(' - Left/Right arrows = change axes of the circumscribing ellipse');
disp(' - Enter             = Confirm cell definition');
disp(' - ESC               = Cancel current cell definition');
% define cell center and outline
m=1;
pb=[];
pt1=[];
pt2=[];
cp1=[];
cp2=[];
ptcell=[];
cnum=0;
left_right_arrow_first_time=1;
% define cell center and outline

%uiresume(handles.figure1);

set(gcf, 'pointer', 'cross');

while(m==1 | m==3 | m==30 | m==31 | m==28 | m==29 | m=='h' | m=='l')
    
    [x2 y2 m ax] = my_ginput(handles.figure1);

    if(isempty(m)) % i.e. Enter was pressed
        m=13;
    end
    if(m~=13 & m~=27)

        if(m==1)
            xp=round(x2); yp=round(y2);
            if(isempty(pt1))
                pt1=plot(xp,yp,'wx');
                pt2=plot(xp,yp,'ko');
                set(pt1,'Tag','roi_boundary');
                set(pt2,'Tag','roi_boundary');
            else
                set(pt1,'xdata',xp,'ydata',yp);
                set(pt2,'xdata',xp,'ydata',yp);
            end
            xb=[-1 1 1 -1]'+xp;
            yb=[1 1 -1 -1]'+yp;            
        end
        if(xp<1)
            xp=1;
        end
        if(xp>size(Maskimg,2))
            xp=size(Maskimg,2);
        end
        if(yp<1)
            yp=1;
        end
        if(yp>size(Maskimg,1))
            yp=size(Maskimg,1);
        end
        if(m==30 | m==31 | m=='h' | m=='l')
            if(m==30 | m=='h')
                handles.thr=handles.thr-0.01;
            else
                handles.thr=handles.thr+0.01;
            end
            if(handles.thr>1)
                handles.thr=1;
            end
            if(handles.thr<0.01)
                handles.thr=0.01;
            end
            fprintf(1,'Current threshold: %.2f\n',handles.thr);
        end

        if(m==1 | m==3 | m==30 | m==31 | m=='h' | m=='l')

            v=Maskimg(yp,xp);            
            fprintf(1,'Value in the clicked pixel: %.4f, ',v);
            if(v==0), v=1; end;
            BW = zeros(size(Maskimg));
            thr_value = handles.ps(1)+(v-handles.ps(1))*handles.thr;
            ind_mask = find(Maskimg>=thr_value);            
            fprintf(1,'ROI boundary: %.4f.\n',thr_value);
            BW(ind_mask) = ones(size(ind_mask));
            [BW2,idx] = bwselect(BW,xp,yp,4);
            if(~isempty(idx))
                fprintf(1,'Size of the ROI: %d pixels.\n',length(idx));
                % just before finding the ROI outline, resize ROI by
                % mag_fac, so that the outline will go AROUND the pixels
                mag_fac = 1;
                %BW2=imresize(BW2,mag_fac,'method','nearest');
                %B=bwboundaries(p4,'holes');
                B = bwboundaries(BW2,'noholes');
                boundary = double(B{1}+(mag_fac-1)/2)/mag_fac;
                xb=boundary(:,1); yb=boundary(:,2);
            else
                disp('add_remove_cells warning: Defined cell is empty! Select another pixel.');
                yb=[-1 1 1 -1]+xp;
                xb=[1 1 -1 -1]+yp;
            end
        end

        if(m==28 | m==29)
            if(m==28)
                diam=-1;
            else
                diam= 1;
            end
            if(left_right_arrow_first_time)
                % do not increase diameter of the circumscribed ellipse
                % when the left/right arrow was pressed for the first time
                diam=0;
                left_right_arrow_first_time=0;
            end
            c=[yb,xb]';
            [A, cnt] = MinVolEllipse(c, .01);
            if(sum([isinf(A(:)) isnan(A(:))])==0)
                [U D V] = svd(A);
                a = 1/sqrt(D(1,1));
                b = 1/sqrt(D(2,2));
                a=a+diam;
                b=b+diam;
                if(a<=2)
                    a=2;
                end
                if(b<=2)
                    b=2;
                end
                D(1,1)=1/a^2;
                D(2,2)=1/b^2;
                A=U*D*V';
            end
            c=Ellipse_plot(A,cnt,20,0);
            
            if 0
                [x,y]=meshgrid([1:size(Maskimg,1)],[1:size(Maskimg,2)]);
                %BW2=inpolygon(x,y,c(:,1),c(:,2));
                BW2 = poly2mask(round(c(:,1)),round(c(:,2)),size(Maskimg,1),size(Maskimg,2));
                [B,L] = bwboundaries(BW2,'noholes');
                xb=B{1}(:,1); yb=B{1}(:,2);
            else
                % remember the smoothed elipse (it will be converted into
                % pixelated ellipse when the cell is accepted).
                xb=c(:,2); yb=c(:,1);
            end;
            
        end;


        if(isempty(pb))
            pb=plot(yb,xb,[handles.coc,'-']);
            set(pb,'Tag','roi_boundary');
        else
            set(pb,'xdata',yb,'ydata',xb);
        end
        
    end
    
    % bring the focus back from the command window to the GUI
    figure(handles.figure1);
    
end;

set(gcf, 'pointer', 'arrow');

% add the cell, unless ESC pressed

if(m==13)
    [x,y]=meshgrid([1:size(Maskimg,1)],[1:size(Maskimg,2)]);
    %BW2=inpolygon(x,y,yb,xb);
    BW2 = poly2mask(yb,xb,size(Maskimg,1),size(Maskimg,2));
    % add also the pixels selected by interactive thresholding, if they
    % were missed by the poly2mask algorithm (same as in manual drawing of
    % ROI)
    BW2=adddrawnpixels(BW2,yb,xb);
    ncells=ncells+1;
    ind=find(BW2==1);
    CELLS(ind)=ones(size(ind))*ncells;
    % disp('New cell was added')
    [handles.maskimg, ~, old2new] = rearrange_sort_cells(CELLS);
    autoupdate_cell_classification(handles.maskimg, ind, old2new, ...
        handles.cellfile, handles.auto_class_update);
    handles.cells_saved = 0;
end

% Update handles structure
guidata(hObject, handles);
update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
    handles.figure1,handles.maskimg, handles.coc, handles.bw,...
    strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));

%uiwait(handles.figure1);

function invert_maskmass_Callback(hObject, eventdata, handles)

maskmass = handles.maskmass;
ps = handles.ps;
for ii=1:size(maskmass,3)
    maskmass(:,:,ii) = ps(ii,2)-maskmass(:,:,ii);
    ps(ii,:) = sort(ps(ii,2)-ps(ii,:));
end
handles.maskmass = maskmass;
handles.ps = ps;
global shown_rgb;
rgb = zeros(size(handles.maskmass));
for i=1:size(rgb,3)
    if sum(shown_rgb)==1
        rgb(:,:,i) = handles.maskmass(:,:,find(shown_rgb==1));
    else
        if shown_rgb(i)
            rgb(:,:,i) = handles.maskmass(:,:,i);
        end
    end
end
ch = handles.axes1.Children;
k=[];
for i=1:length(ch)
    if strcmp(get(ch(i),'type'),'image')
        k=i;
        break;
    end
end
if ~isempty(k)
    ch = ch(k);
    set(ch,'CData',rgb);
    if size(rgb,3)==1
        set(handles.axes1,'CLim',ps);
    end
end

% update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
%     handles.figure1,handles.maskimg, handles.coc, handles.bw,...
%     strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
if strcmp(get(hObject,'Checked'),'off')
    set(hObject,'Checked','on');
else
    set(hObject,'Checked','off');
end
guidata(hObject, handles);

function change_coc_Callback(hObject,eventdata,handles)
a=inputdlg('Enter color for ROI outlines (one of: wkrgbcmy)','LANS input',1,{handles.coc});
a=cell2mat(a);
if isempty(intersect(a,'wkrgbcmy')), a = 'w'; end;
handles.coc = a;
guidata(hObject, handles);

ch = handles.axes1.Children;
k=[];
for i=1:length(ch)
    if strcmp(get(ch(i),'type'),'line')
        set(ch(i),'Color',a);
    end
end

% update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
%     handles.figure1,handles.maskimg, handles.coc, handles.bw,...
%     strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));

function split_rois_by_watershed_Callback(hObject, eventdata, handles)
Maskimg = handles.maskmass(:,:,handles.ic);
CELLS = handles.maskimg;
[segm_im nfig]=watershed_segment(CELLS, Maskimg);
figure(nfig(2));
s1=subplot(1,2,1);
addCellNumbers(s1,segm_im,'w');
%colorbar;
a = questdlg('Do you want to keep these segmented+merged ROIs?',...
    'Keep segmented ROIs?','Yes','No','Yes');
switch a
    case 'Yes', a=1;
    case 'No', a=0;
    otherwise, a=0;
end;
if a
    handles.maskimg=segm_im;
    handles.cells_saved = 0;
    guidata(hObject, handles);

    % redraw the cell outlines
    update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
    
    warndlg(sprintf('After segmentation ROI classification\nwill most likely need to be revised.'))
end;


function split_rois_by_grid_Callback(hObject, eventdata, handles)

im=handles.maskmass;
fprintf(1,'Size of the image: %d x %d\n',size(im,1),size(im,2));
a=input('Enter number of (square) grid cells per image width: ');
a=double(a);
if isempty(a)
    a=1;
end
if a>size(im,2), a=size(im,2); end
if a<1, a=1; end
w=size(im,2);
h=size(im,1);
wg=ceil(w/a);
% calculate the positions of the ROI separators
e2=[0:wg:w+1];
e1=[0:wg:h+1];
e=linspace(0,size(im,2)+1,a+1);
ind1=[1:h];
ind2=[1:w];
% mask defined by the grid
maskimg_grid=zeros(size(im));
cellid=0;
for x=1:(length(e2)-1)
    for y=1:(length(e1)-1)
        i=find(ind2>e2(x) & ind2<=e2(x+1));
        j=find(ind1>e1(y) & ind1<=e1(y+1));
        indx=ind2(i);
        indy=ind1(j);
        if ~isempty(indx) & ~isempty(indy)
            cellid=cellid+1; 
            maskimg_grid(indy,indx)=cellid*ones(length(indy),length(indx));
        end
    end
end

if 0
    figure;
    imagesc(maskimg_grid); colorbar; colormap(clut);
    a=0;
end;

if strcmp(get(handles.auto_class_update,'checked'),'on') & ~isempty(handles.cellfile)
    fprintf(1,'*** WARNING: After this operation ROI classifications will not be correct. Please update it.\n');
end;

% generate a new maskimg matrix, calculated by cutting the previously
% defined one with the grid defined above
if ~isempty(handles.maskimg)
    maskimg_orig = handles.maskimg;
    maskimg_new = zeros(size(maskimg_orig));
    Nrois = length(unique(maskimg_orig(:)));
    min_v = 0;
    for ii=1:Nrois 
        ind = find(maskimg_orig~=ii);        
        grid_rois = maskimg_grid;
        grid_rois(ind) = zeros(size(ind));
        tmp_rois=grid_rois;
        v = setdiff(unique(grid_rois(:)), 0);
        for jj=1:length(v)
            indv = find(grid_rois==v(jj));
            tmp_rois(indv) = jj*ones(size(indv));
        end;
        ind = find(maskimg_orig==ii);
        maskimg_new(ind) = maskimg_new(ind) + tmp_rois(ind) + min_v;
        min_v = max(maskimg_new(:));
    end
else
    maskimg_new = maskimg;
end

if 0
    figure;
    imagesc(maskimg_new); colorbar; colormap(clut);
    a=0;
end;

handles.maskimg = maskimg_new;
handles.cells_saved = 0;
guidata(hObject, handles);

% draw the cell outlines
update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));



% --------------------------------------------------------------------
function split_by_line_Callback(hObject, eventdata, handles)
% hObject    handle to split_by_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add a 2-point margin around the image so that it is possible to
% split rois that are extending towards the edge of the image.
xlim1 = get(handles.axes1,'xlim');
ylim1 = get(handles.axes1,'ylim');
set(handles.axes1,'xlim',xlim1+[-2 2], 'ylim',ylim1+[-2 2]);

h=add_freehand(handles.axes1,0);

% remove the margin immediately after drawing the splitting line
set(handles.axes1,'xlim',xlim1, 'ylim',ylim1);

c = getPosition(h);
fprintf(1,'Recognizing which cells were split. Patience please.\n');
t1=clock;

% find out which pixels in c overlap with a defined cell
CELLS = handles.maskimg;
OLDCELLS=CELLS;

% take pixels belonging to the drawn line and find which cells it cut
% through; do it for denser c (because sometimes the drawn points are
% separated by more than one pixel); set the CELLS values to 0 in the drawn
% line pixels to separate the cells; finally, add the pixels from the drawn
% line to the split cell with the lowest id number

tp=0; % set this to 1 if you want to check for the correctness of the algorithm

if(tp)
    figure(1); hold off;
    plot(c(:,1),c(:,2),'rx-');
    hold on
end

origc=zeros(size(CELLS)); % pixels where drawn line and defined cells overlap
for ii=1:(size(c,1)-1)
    a=c(ii+[0 1],1:2);
    dx=diff(a(:,1));
    dy=diff(a(:,2));
    if(dx==0)
        if(dy>0)
            ang=pi/2;
        else
            ang=-pi/2;
        end
    else
        ang=atan(abs(dy/dx));
        if(dx<0 & dy<0)
            ang=ang+pi;
        end
        if(dx<0 & dy>=0)
            ang=pi-ang;
        end
        if(dx>0 & dy<0)
            ang = -ang;
        end
    end
    L=sqrt(dx^2+dy^2);
    v=[linspace(0,L,10); zeros(1,10)];
    m=[cos(ang) -sin(ang); sin(ang) cos(ang)]; 
    v1=m*v;
    v1(1,:)=v1(1,:)+a(1,1);
    v1(2,:)=v1(2,:)+a(1,2);
    v1=v1';
    
    if tp
        figure(1);
        plot(v1(:,1),v1(:,2),'b.');
    end
    
    v1=round(v1);
    
    if tp
        plot(v1(:,1),v1(:,2),'gx');
    end
    
    % make sure there are no neighboring pixels that change x and y
    % simultaneously, that is, the line should always make a step either in x
    % or in y, but not in x and y at the same time. this is to avoid failure of
    % splitting the ROI cut by such a line using bwlabel(p1,8) (see below).

    v2=v1(1,:);
    for jj=2:size(v1,1)
        dx = v1(jj,1)-v1(jj-1,1);
        dy = v1(jj,2)-v1(jj-1,2);
        if abs(dx)>0 & abs(dy)>0
            eind = size(v2,1);
            v2 = [v2; v2(eind,:) + [dx 0]; v2(eind,:) + [dx dy]];
        else
            v2 = [v2; v1(jj,:)];
        end
    end
    
    if tp
        plot(v2(:,1),v2(:,2),'go');
    end
    
    v1 = v2;
    
    % set pixels v1 in CELLS to zero, but remember what the original values
    % were
    for jj=1:size(v1,1)
        if (v1(jj,1)>0 & v1(jj,1)<=size(CELLS,2) ...
                & v1(jj,2)>0 & v1(jj,2)<=size(CELLS,1))
            if(CELLS(v1(jj,2),v1(jj,1))>0)           
                CELLS(v1(jj,2),v1(jj,1))=0;
                origc(v1(jj,2),v1(jj,1))=OLDCELLS(v1(jj,2),v1(jj,1));
            end
        end
    end
end



if tp
    figure(2)
    imagesc(CELLS);
end

% recognize which cells were really split (those that were only touched by
% the line but not split remain unchanged)
ucells=setdiff(unique(CELLS),0);
VCELLS=zeros(size(CELLS));
for ii=1:length(ucells)
    ind=find(CELLS==ucells(ii));
    p1=zeros(size(CELLS));
    p1(ind)=ones(size(ind));
    %p2=bwlabel(p1,4);
    p2=bwlabel(p1,8);
    if(length(unique(p2))>2)
        VCELLS(ind)=max(VCELLS(:))+p2(ind);
        fprintf(1,'ROI %d was split.\n',ucells(ii));
    else
        ind=find(OLDCELLS==ucells(ii));
        p1=zeros(size(OLDCELLS)); 
        p1(ind)=ones(size(ind));
        VCELLS(ind)=max(VCELLS(:))+p1(ind);
    end
end

CELLS=VCELLS;

% fill the pixels that lie exactly on the line with the min CELLS values
% based on the original cells
ind = find(origc>0);
M = size(CELLS,1);
N = size(CELLS,2);
for ii=1:length(ind)
    if rem(ind(ii),M)==0
        x = ind(ii)/M;
    else
        x = floor( ind(ii)/M )+1;
    end
    y = ind(ii) - M*(x-1);
    indx = [-1:1]+x;
    indx = indx(find(indx>0 & indx<=N));
    indy = [-1:1]+y;
    indy = indy(find(indy>0 & indy<=M));    
    surround = CELLS(indy,indx);
    a=setdiff(surround(:),0);
    VCELLS(y,x) = min(a);
end

if tp
    figure(3)
    imagesc(VCELLS);
end
t2=clock;

global verbose
if verbose
    fprintf(1,'split_by_line_Callback: %.3fs\n',etime(t2,t1));
end

hm = rearrange_sort_cells(VCELLS);

if(~isempty(handles.cellfile))
    % new approach (from 10-Dec-2022): 
    % inherit class of the original ROIs to the split ROIs
    uc = setdiff(unique(hm),0);
    [~,~,cid,~,~]=load_cell_classes(handles.cellfile);
    cid2 = char('i'*ones(length(uc),1));
    for ii=1:length(uc)
        % indices belonging to the new cell
        ind = find(hm==uc(ii));
        % find what was the old cell ID
        oldc = median(OLDCELLS(ind));
        % inherit the class of the old cell by the new cell
        cid2(uc(ii)) = cid(oldc);
        % old approach: removed on 10-Dec-2022
        if 0
            oldind = find(OLDCELLS==oldc);
            % if oldind is not equal ind, the cell uc(ii) was split, so change the
            % class to 'i'        
            newind = setdiff(oldind,ind);
            if(~isempty(newind)) % & ii~=oldc)
                %autoupdate_cell_classification(hm, ind, handles.cellfile, handles.auto_class_update);
                cid2(ii)='i';
            end
        end
    end

    % save the new cells IDs and classes 
    % determine the name of the new classification file
    if(strcmp(get(handles.auto_class_update,'checked'),'on'))
        new_cellfile = handles.cellfile;        
    else
        a=yes_no_dialog('title','Auto-update classification?',...
            'stringa','Yes',...
            'stringb','No, I will update it manually.',...
            'stringc','Cancel.');
        if(a==1)
            new_cellfile = handles.cellfile;
        else
            [pathstr, name, ~] = fileparts(handles.cellfile);
            new_cellfile = [pathstr,delimiter,name,'.new'];
        end
    end 

    out=[1:length(cid2); double(cid2')];
    fid=fopen(new_cellfile,'w');
    fprintf(fid,'%d\t%c\n',out);
    fclose(fid);
    fprintf(1,'Classification in %s updated.\n',new_cellfile);
end

handles.maskimg = hm;
handles.cells_saved = 0;

% Update handles structure
guidata(hObject, handles);
update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
    handles.figure1,handles.maskimg, handles.coc, handles.bw,...
    strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
delete(h);

%%uiwait(handles.figure1);

function combine_rois_Callback(hObject, eventdata, handles)
answer = inputdlg('Enter IDs of ROIs that should be merged into one','Merging ROIs',1,{''});
if isempty(answer)
    rc = [];
else
    rc = str2num(answer{1});
end

if ~isempty(rc)
    CELLS = handles.maskimg;
    uc = setdiff(unique(CELLS),0);
    rc = intersect(uc,rc); % cells that are wished to be removed must exist
    rc = sort(rc);
    j=0;
    if length(rc)>1    
        % first remove all selected cells, remembering the pixels, then add
        % them all as one cell. This will be easier to update the
        % classification file
        ind_all = [];
        for ii=1:length(rc)
            ind = find(CELLS==rc(ii)-j);
            if ~isempty(ind)
                CELLS(ind) = zeros(size(ind));            
                [CELLS,~,old2new] = rearrange_sort_cells(CELLS);
                autoupdate_cell_classification(CELLS, ind, old2new, ...
                    handles.cellfile, handles.auto_class_update,rc(ii)-j);
                j=j+1;
                ind_all = [ind_all; ind(:)];            
            end
        end
        % now add cell in pixels ind_all as a cell with the highest ID, and
        % rearrange cells
        uc = setdiff(unique(CELLS),0);
        if isempty(uc)
            uc = 0;
        end
        CELLS(ind_all) = (max(uc)+1)*ones(size(ind_all));
        [CELLS,~,old2new] = rearrange_sort_cells(CELLS);
        autoupdate_cell_classification(CELLS, ind_all, old2new, ...
             handles.cellfile, handles.auto_class_update,max(uc)+1);

        handles.maskimg = CELLS;
        handles.cells_saved = 0;

        guidata(hObject, handles);
        update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
            handles.figure1,handles.maskimg, handles.coc, handles.bw,...
            strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));

    else
        fprintf(1,'Specified ROIs not defined. Nothing done.\n');
    end

else
    
    fprintf(1,'Nothing specified, nothing done.\n');

end

function Remove_all_rois_Callback(hObject, eventdata, handles)
if ~isempty(handles.maskimg)
    
    a = questdlg('This will remove all ROIs and clear their classifications. Are you sure?',...
          'Remove all ROIs', 'Yes', 'No', 'No');
    switch a
        case 'Yes'
            
            handles.maskimg = zeros(size(handles.maskimg));
            fprintf(1,'All ROIs have been removed.\n');

            if ~isempty(handles.cellfile) & strcmp(get(handles.auto_class_update,'checked'),'on')
                % clear also the cell classification file                
                fid=fopen(handles.cellfile,'w');
                fprintf(fid,'');
                fclose(fid);
                fprintf(1,'Classification file %s cleared.\n',[handles.fdir handles.cellfile]);
            end
            
            handles.cells_saved = 0;

            guidata(hObject, handles);
            update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
                handles.figure1, handles.maskimg, handles.coc, handles.bw,...
                strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));

        case 'No'
            fprintf(1,'Ok, I''ll keep them for now.\n');
    end        
    
end

function Remove_rois_size_Callback(hObject, eventdata, handles)
fprintf(1,'Examples:\n  s<10 ... removes ROIs containing <10 pixels\n')
fprintf(1,'  s>10 & s<20 ... removes ROIs containing >10 AND <20 pixels\n')
fprintf(1,'  s<20 | s>1000 ... removes ROIs containing <20 OR >1000 pixels\n')
answer = inputdlg('Enter condition for ROI removal based on size (see Command window for examples):','Removing ROIs by size',1,{''});
if isempty(answer)
    a = [];
else
    a = answer{1};
end

if ~isempty(a)
    % loop over all ROIs and remove them if they satisfy condition A
    CELLS = handles.maskimg;
    rc = 1:max(CELLS(:));
    j=0;
    for ii=1:length(rc)
        ind = find(CELLS==rc(ii)-j); % every time a cell is removed, the ID's of the cell that are to be removed subsequently are by 1 lower
        s=length(ind);
        if eval(a)
            CELLS(ind) = zeros(size(ind));        
            fprintf(1,'ROI %d (size %d) removed.\n',rc(ii),s);
            % update variables and the cells outlines in the image
            [CELLS,~,old2new] = rearrange_sort_cells(CELLS);
            autoupdate_cell_classification(CELLS, ind, old2new, ...
                handles.cellfile, handles.auto_class_update,rc(ii)-j);
            j=j+1;
        end
    end
    
    if j==0
        fprintf(1,'No ROI satisfied the given condition %s\n',a);
    else

        handles.maskimg = CELLS;
        handles.cells_saved = 0;

        % Update handles structure
        guidata(hObject, handles);
        update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
            handles.figure1,handles.maskimg, handles.coc, handles.bw,...
            strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
    end
    
else
    
    fprintf(1,'Nothing specified, nothing done.\n');
    
end

function Remove_multiple_Callback(hObject, eventdata, handles)
answer = inputdlg('Enter IDs of ROIs that should be removed','Removing ROIs',1,{''});
if isempty(answer)
    rc = [];
else
    rc = str2num(answer{1});
end
if ~isempty(rc)
    CELLS = handles.maskimg;
    j=0;
    for ii=1:length(rc)
        ind = find(CELLS==rc(ii)-j); % every time a cell is removed, the ID's of the cell that are to be removed subsequently are by 1 lower
        if(~isempty(ind))
            CELLS(ind) = zeros(size(ind));        
            fprintf(1,'ROI %d removed.\n',rc(ii));
            % update variables and the cells outlines in the image
            [CELLS,~,old2new] = rearrange_sort_cells(CELLS);
            autoupdate_cell_classification(CELLS, ind, old2new, ...
                handles.cellfile, handles.auto_class_update,rc(ii)-j);
            j=j+1;
        else
            fprintf(1,'ROI %d not found. Nothing removed.\n',rc(ii));
        end
    end
    handles.maskimg = CELLS;
    handles.cells_saved = 0;

    % Update handles structure
    guidata(hObject, handles);
    update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));

else
    
    fprintf(1,'Nothing specified, nothing done.\n');
    
end

function copy_ROI_Callback(hObject, eventdata, handles)
CELLS = handles.maskimg;
l3=CELLS;
disp('*** Interactive copy of a ROI.');
disp(' - Left-click        = select ROI;');
disp(' - Right-click       = confirm ROI selection');

% define cell center and outline
m=1;
while(m==1 | m==3)
    [x2,y2,m]=ginputc(1,'Color','w');
    if(isempty(m)) % i.e. Enter was pressed
        m=13;
    end;
    if(m~=13 & m~=27)

        if(m==1)
            xp=round(x2); yp=round(y2);
            if(xp<1), xp=1; end;
            if(xp>size(l3,2)), xp=size(l3,2); end;
            if(yp<1), yp=1; end;
            if(yp>size(l3,1)), yp=size(l3,1); end;
            vc=l3(yp,xp);
            if(vc>0)
                disp(['ROI ',num2str(vc),' selected.']);
            end;
        end;

        if(m==3)
            % calculate the boundary of the selected cell, which will be
            % used as the initial position for impoly
            ind=find(l3==vc);
            BW2 = zeros(size(CELLS));
            BW2(ind)=ones(size(ind));
            [B,L] = bwboundaries(BW2,'noholes');
            xb=B{1}(:,2); yb=B{1}(:,1);
            % take max 15 vertices
            if(length(xb)>15)
                ind = round(linspace(1,length(xb),15));
                xb=xb(ind);
                yb=yb(ind);
            end;
            m=13; % behave as if Enter was pressed now
        end;
    end;
end;

disp(' - Left-click + drag = place the ROI to a new position;');
disp(' - Left-double-click = confirm ROI''s new position;');

% draw polygon with vertices lying on the boundary of the original ROI
h=add_polygon(handles.axes1,[xb(:) yb(:)]);

if 1
    % convert the newly defined polygon to cell
    [added_cell, ind] = roi2cell(h, 1);
    % calculate centroids of the original and new cells
    gd = regionprops(BW2,'basic');
    cc1=gd.Centroid;
    gd = regionprops(added_cell,'basic');
    cc2=gd.Centroid;
    % translate the original roi by the difference cc2-cc1 (this needs to
    % be flipped around, because the meaning of x and y seems to be
    % different)
    se = translate(strel(1),fliplr(round(cc2-cc1)));
    added_cell = imdilate(BW2,se);
    handles.maskimg = add_cell(handles.maskimg, added_cell);
    handles.cells_saved = 0;
    [handles.maskimg,~,old2new]=rearrange_sort_cells(handles.maskimg);
    autoupdate_cell_classification(handles.maskimg, ind, old2new, ...
            handles.cellfile, handles.auto_class_update);
    handles.cells_saved = 0;
end

guidata(hObject, handles);

update_cell_outline(handles.axes1,handles.maskmass, handles.ps, ...
        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
    
%%uiwait(handles.figure1);


% --------------------------------------------------------------------
function Remove_Callback(hObject, eventdata, handles)
% hObject    handle to Remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CELLS = handles.maskimg;
l3=CELLS;
ind=[];
vc=[];
if ~isempty(handles.cellfile)
    [cidu,cc,cid,cnum,ss]=load_cell_classes(handles.cellfile,0);
else
    cid = [];
end
disp('*** Interactive removal of a ROI or a pixel in a ROI.');
disp(' - Left-click        = select ROI (pixel);');
disp(' - Right-click       = remove selected ROI (pixel);');
disp(' - Esc               = cancel action;');

set(gcf, 'pointer', 'hand');

% define cell center and outline
m=1;
while(m==1 | m==3)
    
    pause(0.15)
    
    [x2 y2 m] = my_ginput(handles.figure1);    
    %[x2,y2,m]=ginputc(1,'Color','w');
    
    if(isempty(m)) % i.e. Enter was pressed
        m=13;
    end;
    if(m~=13 & m~=27)

        if(m==1)
            xp=round(x2); yp=round(y2);
            if(xp<1), xp=1; end
            if(xp>size(l3,2)), xp=size(l3,2); end
            if(yp<1), yp=1; end
            if(yp>size(l3,1)), yp=size(l3,1); end
            vc=l3(yp,xp);
            if(vc>0)
                indr=find(CELLS==vc);
                if ~isempty(cid)
                    fprintf(1,'ROI %d (size %d, class %s) @ PIXEL [%d,%d] selected.\n', vc, length(indr), cid(vc),xp,yp);
                else
                    fprintf(1,'ROI %d (size %d) @ PIXEL [%d,%d] selected.\n',vc,length(indr),xp,yp);
                end
            else
                fprintf(1,'No valid ROI selected.\n');
            end
        end

        if(m==3)
            
            if hObject == handles.Remove % remove ROI
                ind=find(l3==vc);  
                if vc>0 & ~isempty(ind)
                    l3(ind)=zeros(size(ind));
                end
                fprintf(1,'ROI %d removed\n',vc);
            
                % remove selected cell and update everything            
                [handles.maskimg,~,old2new] = rearrange_sort_cells(l3);
                autoupdate_cell_classification(handles.maskimg, ind, old2new, ...
                    handles.cellfile, handles.auto_class_update,vc);
                handles.cells_saved = 0;                                                
                update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
                    handles.figure1,handles.maskimg, handles.coc, handles.bw,...
                    strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
                m=13; % behave as if Enter was pressed now; this will quit the loop
            elseif hObject == handles.remove_pixel
                ind=find(l3==vc);
                if length(ind)==1
                    % one pixel that constitutes a ROI cannot be removed
                    % like this, but must be removed through ROI-removal
                    fprintf(1,'WARNING: This pixel forms a ROI.\n');
                    fprintf(1,'  Please use Remove ROI interactively from the menu to remove it.\n');
                else                   
                    l3(yp,xp)=0;
                    % check whether removal of a pixel resulted in a change
                    % of ROIs
                    l3r = bwlabel(l3,8);               
                    [l3r,~,old2new] = rearrange_sort_cells(l3r);
                    changed_rois = setdiff(unique(l3r(ind)),0);
                    ind1 = (xp-1)*size(CELLS,1)+yp;
                    handles.maskimg = l3r;
                    autoupdate_cell_classification(handles.maskimg, ind1, old2new, ...
                        handles.cellfile, handles.auto_class_update,vc,changed_rois);
                    handles.cells_saved = 0;
                    update_cell_outline(handles.axes1,handles.maskmass, handles.ps,...
                        handles.figure1,handles.maskimg, handles.coc, handles.bw,...
                        strcmp(get(handles.zoom_out_after_ROI_definition,'checked'),'on'));
                    m=13; % behave as if Enter was pressed now; this will quit the loop
                end                
            end
            
        end
       
    else
        fprintf(1,'Finished with no ROI removed.\n');
    end
end

set(gcf, 'pointer', 'arrow');

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function save_cells_Callback(hObject, eventdata, handles)
% hObject    handle to save_cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Maskimg=handles.maskimg;
fdir = handles.fdir;
global CELLSFILE MAT_EXT;

if hObject == handles.save_resized_cells
    % first, account for magnification, if needed
    mf = handles.mag_factor;
    if mf~=1
        Maskimg = imresize(Maskimg,1/mf,'method','nearest');
        % some small cells may have been removed, so make sure that the
        % final Maskimg contains properly sorted cells
        Maskimg = rearrange_sort_cells(Maskimg);
    end
end

% default output
handles.output = CELLSFILE;

if ~isempty(Maskimg)
    
    a=yes_no_dialog('title','Should the ROIs really be saved?',...
        'stringa',sprintf('Yes, store them as %s',[CELLSFILE MAT_EXT]),...
        'stringb','Yes, but under a different name.',...
        'stringc','Cancel.');
            
    if(a==1)
        % save in the default file
        fout=[fdir CELLSFILE MAT_EXT];
        if exist(fout)
            options.Default = 'Cancel';
            options.Interpreter = 'none';
            choice = questdlg(sprintf('File %s already exists. What do you want to do?',[CELLSFILE MAT_EXT]),...
                'LANS warning',...
                'Overwrite','Cancel',options);
                
        else
            choice = 'Overwrite';
        end
        
        switch choice
            case 'Overwrite'
                save(fout,'Maskimg','-v6');
                fprintf(1,'ROIs saved as %s\n',fout);
                handles.cells_saved = 1;
                if hObject == handles.save_cells
                    CELLSFILE=handles.output;
                end
                % export also in PNG
                [p f]=fileparts(fout);
                fout=[p delimiter f '.png'];
                % convert indexed image to rgb, otherwise saving as png will fail
                % if number of ROIs>256
                rgb=ind2rgb(uint16(Maskimg),clut(max(Maskimg(:))+1));
                imwrite(rgb,fout);
                fprintf(1,'ROIs exported as %s\n',fout);
            case 'Cancel'
                fprintf(1,'ROIs not saved.\n');
        end        
        
    end
    
    if(a==2)
        % make a backup, just in case, and do nothing
        fout=[fdir '_' CELLSFILE MAT_EXT];
        save(fout,'Maskimg','-v6');
        fprintf(1,'As a precaution, ROIs were backed up in %s\n',fout);
        handles.cells_saved = 0;
        %handles.output = ['_' CELLSFILE];        
    end
    
    if(a==0)
        % save the cells into a user specified file
        [FileName,newdir,newext] = uiputfile(['*' MAT_EXT], 'Choose ROIs output file', fdir);
        if(FileName~=0)
            fout = [newdir, FileName]; %fout=[fdir CELLSFILE MAT_EXT];
%             if exist(fout)
%                 options.Default = 'Cancel';
%                 options.Interpreter = 'none';
%                 choice = questdlg(sprintf('File %s already exists. What do you want to do?',[FileName]),...
%                     'LANS warning',...
%                     'Overwrite','Cancel',options);
% 
%             else
%                 choice = 'Overwrite';
%             end
%             
%             switch choice
%                 case 'Overwrite'
                    save(fout,'Maskimg','-v6');
                    fprintf(1,'ROIs saved in %s\n',fout);
                    handles.cells_saved = 1;
                    [p f]=fileparts(fout);
                    handles.output = f;                                
                    % export also in PNG
                    fout=[p delimiter f '.png'];
                    % convert indexed image to rgb, otherwise saving as png will fail
                    % if number of ROIs>256
                    rgb=ind2rgb(uint16(Maskimg),clut(max(Maskimg(:))+1));
                    imwrite(rgb,fout);
                    fprintf(1,'ROIs exported as %s\n',fout);
                % case 'Cancel'
        else
            fprintf(1,'ROIs not saved.\n');
        end
    end
    
    % Update handles structure
    guidata(hObject, handles);
    %uiwait(handles.figure1);
else
    disp(['No cells defined as yet.']);
end
% activate the main GUI at the end
figure(handles.figure1);

function add_remove_rgb_channel(hObject, eventdata, handles)
% get to the image data
% c=hObject.Parent.Parent.Children;
% im=c(2).Children;
% imdata = im(3).CData;
% 
% fprintf(1,'Hello\n');

% --------------------------------------------------------------------
function display_cells_Callback(hObject, eventdata, handles)
% hObject    handle to display_cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

be_verbous = 1;

if hObject == handles.display_roi_outlines
    % display cell outlines in a separate window, together with the maskimg.

    % first, account for magnification, if needed
    mf = handles.mag_factor;
    mi = handles.maskimg;
    if mf~=1
        if be_verbous
            fprintf(1,'Accounting for magnification...');
        end
        mi = imresize(mi,1/mf,'method','nearest');
        mi = imresize(mi,mf,'method','nearest');
        if be_verbous
            fprintf(1,'done.\n');
        end
    end

    % find which cells are in the present possibly zoomed-in view. I do
    % to speed up the drawing of the ROI outlines, which may take long if
    % there are many cells.
    xl=round(get(handles.axes1,'xlim'));
    yl=round(get(handles.axes1,'ylim'));
    xl=[xl(1):xl(2)];
    xl = xl(xl>0); xl = xl(xl<=size(mi,2));
    yl=[yl(1):yl(2)];
    yl = yl(yl>0); yl = yl(yl<=size(mi,1));
    % crop mi and maskmass, again, to speed up the process and save memory
    mi = mi(yl,xl);
    maskmass = handles.maskmass;
    maskmass = maskmass(yl,xl,:);
    ucells = setdiff(unique(mi),0);
    miu = zeros(size(mi));
    for i=1:length(ucells)
        ind = find(mi==ucells(i));
        miu(ind) = ucells(i);
    end
    % display the outlines of the cells in current view in a separate window, together with the maskmass    
    fig11=figure(111); set(fig11,'color',[0 0 0]); ax1=subplot(1,1,1);
    update_cell_outline(ax1,maskmass, handles.ps, ...
            fig11, miu, handles.coc, handles.bw,1);
    set(ax1,'XtickLabel',num2str(get(ax1,'Xtick')'+xl(1)-1));
    set(ax1,'YtickLabel',num2str(get(ax1,'Ytick')'+yl(1)-1));
    xlabel('Pixels in zoomed-in image','color',[1 1 1])
    ylabel('Pixels in zoomed-in image','color',[1 1 1])    
    title(sprintf('ROI outlines, corrected for magnification (m=%.2f)',mf),...
        'color',[1 1 1]);
% tests
%     m11 = uimenu(fig11,'Text','View RGB');
%     mitem1 = uimenu(m11,'Text','Hide red','Checked','off','Accelerator','1',...
%         'Tag','show_red');
%     mitem1.MenuSelectedFcn = @(hObject,eventdata,handles)add_remove_cells_tool('add_remove_rgb_channel',hObject,eventdata,guidata(hObject));
%     mitem2 = uimenu(m11,'Text','Hide green','Checked','off','Accelerator','2',...
%         'Tag','show_green');
%     mitem2.MenuSelectedFcn = @(hObject,eventdata,handles)add_remove_cells_tool('add_remove_rgb_channel',hObject,eventdata,guidata(hObject));
%     mitem3 = uimenu(m11,'Text','Hide blue','Checked','off','Accelerator','3',...
%         'Tag','show_blue');
%     mitem3.MenuSelectedFcn = @(hObject,eventdata,handles)add_remove_cells_tool('add_remove_rgb_channel',hObject,eventdata,guidata(hObject));
    

elseif hObject == handles.display_cells
    
    if isfield(handles,'maskimg')
        oldcells=handles.maskimg;
    else
        oldcells = [];
    end

    cf = handles.cellfile;
    if ~isempty(cf)
        [unique_classes,cc,cid,cnum,ss]=load_cell_classes(cf);
    else
        unique_classes='i';
        cnum = setdiff(unique(handles.maskimg(:)),0);
        cid = char(unique_classes*ones(size(cnum)));
        %unique_classes=[];
    end

    if(~isempty(oldcells))
        %[handles.maskimg indc] = rearrange_sort_cells(oldcells);
        if(sum(abs(oldcells(:)-handles.maskimg(:)))>0)
            % if rearranging cells returned different cells (e.g., because the small
            % ones were removed), set the saved-flag to 0, so that the user will be
            % prompted with the save/don't save question.
            handles.cells_saved = 0;
        end

        guidata(hObject, handles);

        mim = handles.maskimg;
        b=[];
        if ~isempty(unique_classes)

            if strcmp(char(unique_classes(:)),'i')
                uc = '';
            else
                uc = char(unique_classes(:))';
            end

            x=inputdlg('Enter ROI classes (letters) or ROI IDs (numbers), separated by space. Empty for all.',...
                'ROI ID''s or ROI classes to be displayed',1,{uc});
            if isempty(x)
                a = num2str(cnum');
            else
                a = x{1};
                if isempty(a)
                    a = num2str(cnum');
                end
            end

            b = strsplit(a,' ');

            % gather ID's of ROIs that will be displayed
            ind = [];
            for ii=1:length(b)
                [bnum, bstat] = str2num(b{ii});
                % in case b{ii} was 'i', which is an imaginary unit, correct
                % the output of str2num
                if strcmp(b{ii},'i')
                    bnum = [];
                    bstat = 0;
                end
                if bstat
                    % b{ii} contains numbers
                    ind = [ind; bnum(:)];
                else
                    % b{ii} contains letters
                    for jj=1:length(b{ii})
                        ind = [ind; find(cid==b{ii}(jj))];
                    end
                end
            end
            ind = unique(ind);

            % remove pixels with ROIs whose class was not selected
            b = setdiff(cnum,ind);
            if ~isempty(b)
                for ii=1:length(b)
                    ind = find(mim==b(ii));
                    mim(ind) = zeros(size(ind));
                end
            end

        end

        % display the rois
        f10=findobj('tag','fig_current_rois');
        f10_was_open = ~isempty(f10);        
        %f10_was_open = ~(ishandle(fignum) && strcmp(get(fignum, 'type'), 'figure'));
        if ~f10_was_open
            % if figure 110 was not yet created, create a new one and place
            % it right next to the ROI definition tool
            fpos = get(handles.figure1,'Position');
            f10 = my_figure(110);
            f10pos = get(f10,'Position');
            f10pos(1) = fpos(1)+fpos(3)+1;
            f10pos(2:4) = fpos(2:4);
            set(f10,'Position',f10pos,'tag','fig_current_rois');
            set(f10,'color',[0 0 0]); 
            ax1=subplot(1,1,1);            
        else
            % if figure 110 was already created, assume it's placement is
            % fine, and just return a handle to it
            %f10=figure(fignum);
            %f10=findobj('tag','fig_current_rois');
            ax1=get(f10,'Children');
        end        
        
        imr = findobj(ax1,'tag','roi_image');
        cmap2=clut(max(mim(:))+1);
        if isempty(imr)
            imr=imagesc(mim,[0 max(mim(:))+1]); 
            set(imr,'tag','roi_image','HandleVisibility','on');
        else
            set(imr,'CData', mim);
        end
        set(ax1,'Colormap',cmap2);
        set(ax1,'CLim', [0 max(mim(:))+1]);
        %set(imr,'CDataMapping','direct');
            
        if isempty(b)
            addCellNumbers(ax1,handles.maskimg); 
        else
            addCellNumbers(ax1,mim);
        end
        
        set(ax1,'xcolor',[1 1 1],'ycolor',[1 1 1],...
            'DataAspectRatio',[1 1 1],'FontSize',8,'color',0.0*[1 1 1]);    
        title(ax1,'Currently defined ROIs (same color=same ROI)','color',[1 1 1]);%,'FontSize',8);
        xlabel(ax1,'Pixels','color',[1 1 1])
        ylabel(ax1,'Pixels','color',[1 1 1])
        
    else
        disp(['No cells defined as yet.']);
    end
    
    if ~f10_was_open
        % for some reason, when f10 was not open, activating of the main
        % GUI window did not work without this pause
        pause(0.1);
    end
    figure(handles.figure1);
    
end

            
% --------------------------------------------------------------------
function Action_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Action_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function add_cells_help_Callback(hObject, eventdata, handles)
if hObject == handles.what_do_they_show
    helpdlg({'ROI outlines connect the *middle points* of the pixels at the edge of the defined ROIs. Therefore,';
        '1. If a ROI consists of one pixel, it''s outline will not be visible.';
        '2. If a ROI consists of 2 pixels, it''s outline will be a line connecting the middle points of these two pixels.';
        '3. If a ROI consists of 3 pixels that do not lie on a line, it''s outline will be a triangle, etc.',
        '',
        'To display the *actual pixels* of the defined ROIs, select *Display ROIs with ROI ID''s* from the *Display ROIs* menu.',
        '1. You can specify ID numbers of the ROIs that you want to display.',
        '2. If you have defined and seleted ROI classification, you can specify the classes of ROIs that you want to display.',
        '3. To save these ROIs, choose *Save ROIs* from the *Save* menu.',
        '',
        'If you *enlarged the resolution* of the images used as the ROI definition template, the ROI outlines will be displayed with this magnification factor accounted for.',
        '1. Note that ROIs with size lower than the magnification factor will disappear. This is correct, as such ROIs would not consitute valid ROIs in the original (un-resized) nanoSIMS data.',
        '2. To display these ROIs, choose *Display magnification-corrected ROI outlines* from the *Display ROIs* menu.',
        '3. To save these ROIs, choose *Save magnification-corrected ROIs* from the *Save* menu.'
        },...
        'What do ROI outlines show?');
elseif hObject == handles.what_to_do    
    helpdlg({'1. Use the Action menu to access the various ways for defining, drawing, splitting, removing and merging ROIs.';
        '2. Note that presently there is NO *undo* function implemented.';
        '3. When needed, *display* the presently defined ROIs using the Display ROIs item from the menu. As a rule, the ROIs are colored and sorted so that their centers increase from left to right.';
        '4. When satisfied with the defined ROIs, use Save ROIs from the menu to *save them to disk*. This will make it possible to calculate things in the newly defined ROIs using the main Look@nanoSIMS window.'},...
        'What to do?'); 
elseif hObject == handles.how_to_use_interactive_thresholding
    helpdlg({'Interactive thresholding is a convenient and fast method to define regions of interest (ROIs) interactively and semi-objectively.';
        '1. Select Interactive thresholding from the Action menu or press Ctrl+A.';
        '2. Click with the *left* mouse button somewhere on a bright spot or area in the image to define a value *V*. This will draw a *contour* that encloses a continuous area in the image, i.e., the ROI, with values >= Thr*V, where Thr is a *threshold* level (initially 0.5).';
        '3a. Use *arrow-down* or *l* and *arrow-up* or *h* to *increase* and *decrease* this threshold level, respectively. This will result in the *shrinking* and *expanding* of the ROI, respectively.';
        '3b. Alternatively, click with the *left* mouse button on *another point* in the image to define a new value V, and thus a new, slightly different, ROI.';
        '4. If satisfied with the presently drawn ROI contour, press *enter* to *confirm* it.';
        '5. Anytime you can press *Esc* to finish interactive thresholding without defining a ROI.';
        'IMPORTANT NOTES:';
        '1. You *must finish* the interactive thresholding action *properly*, that is, either by confirming the suggested ROI (enter) or by canceling the action (Esc). Specifically, do NOT click on any other item in the Menu while the interactive thresholding is active. If you do, you are risking that the tool window will freeze.';
        '2. If you are using an RGB image as the template for ROI definition, you can select the channel - red, green or blue - that is active when defining the value V. This is done through the Menu item Select interactive channel.'; 
        '3. Interactive thresholding selects an area where the values are >= Thr*V (see above). To select an area where the values are <= Thr*V, first choose *Invert template image* from the Action menu and then continue as described above.';
        '4. Check the Matlab command window for further help and useful information.'},...
        'How to use interactive thresholding?');
elseif hObject == handles.how_to_use_zoom
    helpdlg({'Matlab''s implementation of zoom is somewhat awkward and requires diligence. You need to remember that you either are, or are not, in the zoom mode, which will influence what happens when you click on an image.';
        '1. Select Zoom ENABLE from the Zoom menu (or press Ctrl+Z) to *invoke* the zoom mode.';
        '2. Use mouse to *define* the *zoomed-in region* in the image. REMEMBER that even after you define a zoomed-in region, you are still in the zoom mode.';
        '3. Select Zoom DISABLE from the Zoom menu to *stop* the zooming mode. You must do this using the mouse!';
        'REMEMBER: Only *after* you disabled the zoom mode can you proceed with further actions from the Action menu.'},...
        'How to use the zoom function?');
elseif hObject == handles.how_to_remove_roi
    helpdlg({'1. Select Remove ROI Interactively from the Action menu, or press Ctrl+R.';
        '2. Use *left* mouse click to *select* a ROI for removal.';
        '3. Use *right* mouse click to *remove* it.';
        '4. Press Esc to cancel the action without removing the ROI.'},...
        'How to remove a ROI interactively?');
elseif hObject == handles.how_to_split_by_line
    helpdlg({'1. Select Split ROIs by line from the Action menu, or press Ctrl+P.';
        '2. Click with the *left* mouse button to define the *starting point* of the line.';
        '3. *Hold* the left mouse button clicked and *drag it* along a path do *define* the line.';
        '4. *Releasing* the button will define the *end point* of the line.';
        '5. If desired, *drag* the line just drawn while holding the left mouse button to fine-tune the line''s position.';
        '6. Double-click on the line to confirm it''s position.';
        'IMPORTANT NOTES:';
        '1. You can draw the splitting line across several ROIs. Each ROI that is cut through by the line will be split.';
        '2. If Automatically update classification file in the Action menu is checked, and the classification file was selected before opening the ROIs definition tool, ROI classification will be automatically updated when a ROI is split. Specifically, ROIs that result from splitting a previously defined ROI will be classified as *i* (stands for "inserted"), while classification of the remaining ROIs will be unchanged.'},...
        'How to remove a ROI interactively?');
elseif hObject == handles.draw_roi_inside_roi
    helpdlg({'When a new ROI is drawn over a previously defined ROI, pixels from the old ROI that fall within the contour of the newly defined ROI will belong to the new ROI. In other words, the last drawn ROI takes precedence over the previously defined ROIs.';
        'Therefore, if you want to draw *a ROI within a ROI*, you should draw the larger "outside" ROI *before* drawing the smaller "inside" ROI.'},...
        'How to draw a ROI inside a ROI?');
end;

function move_view_Callback(hObject,eventdata,handles)
fprintf(1,'*** Interactive centering of view field of view\n');
fprintf(1,'Left-click on the image to center the view to the clicked point.\n');
fprintf(1,'Right-click, Esc or Enter to stop.\n');

global newxLim newyLim
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
        dx = diff(newxLim);
        dy = diff(newyLim);
        newxLim = x+dx/2*[-1 1];
        newyLim = y+dx/2*[-1 1];
        set(ax,'xlim',newxLim,'ylim',newyLim);
        
        % update ROI outlines within the viewed area
        update_ROI_outlines_within_viewed_area(handles,newxLim, newyLim)
        
    end
    
end

set(gcf, 'pointer', 'arrow');


function update_ROI_outlines_within_viewed_area(handles,newxLim, newyLim)
maskimg_cropped = zeros(size(handles.maskimg));
yint = [round(newyLim(1)):round(newyLim(2))];
xint = [round(newxLim(1)):round(newxLim(2))];
yint = yint(find(yint>0 & yint<=size(handles.maskimg,1)));
xint = xint(find(xint>0 & xint<=size(handles.maskimg,2)));
maskimg_cropped(yint, xint) = handles.maskimg(yint, xint);
b=findobj(handles.axes1,'Tag','roi_boundary');
if ~isempty(b)
    delete(b);
end
addCellOutline(handles.axes1,maskimg_cropped,handles.coc,1);
%addCellOutline(handles.axes1,maskimg_cropped,handles.coc,handles.mag_factor);
