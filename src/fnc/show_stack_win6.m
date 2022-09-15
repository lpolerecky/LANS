function varargout = show_stack_win6(varargin)
% SHOW_STACK_WIN6 M-file for show_stack_win6.fig
%      SHOW_STACK_WIN6, by itself, creates a new SHOW_STACK_WIN6 or raises the existing
%      singleton*.
%
%      H = SHOW_STACK_WIN6 returns the handle to a new SHOW_STACK_WIN6 or the handle to
%      the existing singleton*.
%
%      SHOW_STACK_WIN6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW_STACK_WIN6.M with the given input arguments.
%
%      SHOW_STACK_WIN6('Property','Value',...) creates a new SHOW_STACK_WIN6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show_stack_win6_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show_stack_win6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show_stack_win6

% Last Modified by GUIDE v2.5 29-Nov-2009 19:03:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show_stack_win6_OpeningFcn, ...
                   'gui_OutputFcn',  @show_stack_win6_OutputFcn, ...
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

% --- Executes just before show_stack_win6 is made visible.
function show_stack_win6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show_stack_win6 (see VARARGIN)

% Update handles structure
guidata(hObject, handles);
if(nargin>3)
    imagestack=varargin{1};
    imscales = varargin{2};
    immasses = varargin{3};
    fdir = varargin{4};
    name_prefix = varargin{5};
    if length(varargin)>5
        imagestack_conf = varargin{6};
    else
        imagestack_conf = 1;
    end;
    nom=min([length(imagestack), 6]);
    for ii=1:nom
        if(isempty(imscales{ii}))
            imscales{ii}=[min(imagestack{ii}(:)) max(imagestack{ii}(:))];
        end;
    end;
    handles.imagestack = imagestack;
    handles.imagestack_conf = imagestack_conf;
    handles.imscales = imscales;
    handles.immasses = immasses;
    handles.fdir = fdir;
    handles.name_prefix = name_prefix;
    handles.flag = 0;
    handles.fid = handles.figure1;
    set(handles.popupmenu2,'value',1);
    set(handles.text3,'string',num2str(size(handles.imagestack{1},3)));
    display_images(imagestack,imscales,immasses,1,handles,hObject,1, imagestack_conf);
end;

if name_prefix == 'm'
    set(handles.figure1,'Name','Mass display')
else
    set(handles.figure1,'Name','Ratio display')
end;

handles = update_gui_fontsize(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show_stack_win6 wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = show_stack_win6_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [];
if(isfield(handles,'figure1'))
    delete(handles.figure1);
end;

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



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmax=str2num(get(handles.text3,'String'));
nstep=1;
if hObject == handles.pushbutton12
    nstep = round(nmax/10);
end;
n=str2num(get(handles.text1,'String'))-nstep;
if(n>nmax)
    n=nmax;
end;
if(n<1)
    n=1;
end;
set(handles.text1,'string',num2str(n));
display_images(handles.imagestack,handles.imscales,handles.immasses,n,handles,hObject,0,handles.imagestack_conf);
a=0;

function fid=pushbutton7_Callback(hObject, eventdata, handles)
set(handles.text1,'string','1');
fid=display_images(handles.imagestack,handles.imscales,handles.immasses,1,handles,hObject,0,handles.imagestack_conf);

function pushbutton9_Callback(hObject, eventdata, handles)
nmax=str2num(get(handles.text3,'String'));
set(handles.text1,'string',num2str(nmax));
display_images(handles.imagestack,handles.imscales,handles.immasses,nmax,handles,hObject,0,handles.imagestack_conf);

% --- Executes on button press in pushbutton5.
function fid=pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmax=str2num(get(handles.text3,'String'));
nstep=1;
if hObject == handles.pushbutton11
    nstep = round(nmax/10);
end;
n=str2num(get(handles.text1,'String'))+nstep;
if(n>nmax)
    n=nmax;
end;
if(n<1)
    n=1;
end;
set(handles.text1,'string',num2str(n));
fid=display_images(handles.imagestack,handles.imscales,handles.immasses,n,handles,hObject,0,handles.imagestack_conf);
a=0;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles.output.deselected = handles.deselected;
%handles.output.region_x = get(handles.axes1,'xlim');
%handles.output.region_y = get(handles.axes1,'ylim');

guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmax=str2num(get(handles.text3,'String'));
n=str2num(get(handles.text1,'String'));
fid=display_images(handles.imagestack,handles.imscales,handles.immasses,n,handles,hObject,0,handles.imagestack_conf);

function fid=display_images(im,scales,masses,n,handles,hObject,sr,im_conf)

fid=handles.figure1;
if(sr)
    disp('---');
end

global additional_settings;
fontsize = additional_settings.defFontSize;
font_gap = 1;

% display masses in the array of plots predifined by the GUI
for ii=1:min([length(im) 8])
    switch ii
        case 2, ax=handles.axes2;
        case 3, ax=handles.axes3;
        case 4, ax=handles.axes4;
        case 5, ax=handles.axes5;
        case 6, ax=handles.axes6;
        case 7, ax=handles.axes7;
        case 8, ax=handles.axes8;            
        otherwise, ax=handles.axes1;
    end
    %axes(ax);
    if scales{ii}(1)==scales{ii}(2)
        scales{ii}(2)=scales{ii}(1)+1;
    end
    a = im{ii}(:,:,n);
    if iscell(im_conf)
        a_conf = im_conf{ii}(:,:,n);
    else
        a_conf = ones(size(a));
    end
    s = scales{ii};
    t = masses{ii};
    % if log-scale requested, adjust the scale so that 0 will become 1
    if get(handles.checkbox2,'value')==1
        if s(1)==0
            if handles.name_prefix=='m'
                s(1)=1;
                if s(2)<10, s(1)=0.5; end
            else
                s(1)=1e-4;
            end
        end
        %imagesc(log10(double(a)), log10(double(s)));
        %cmap = get(handles.popupmenu2,'value');
        cmap = get(handles.popupmenu2,'value');
        [~, ~, ~, cmap2] = imagesc_conf(log10(double(a)), log10(double(s(1))), log10(double(s(2))), a_conf, cmap, 0, ax);
        title(ax,['log(', t, ')'], 'FontSize',fontsize,'fontweight','normal');
    else
        %imagesc(a, s);
        %cmap = get(handles.popupmenu2,'value');
        cmap = get(handles.popupmenu2,'value');
        [~, ~, ~, cmap2] = imagesc_conf(a, s(1), s(2), a_conf, cmap, 0, ax);
        title(ax,t,'FontSize',fontsize,'fontweight','normal');
    end
    if(sr)
        a=im{ii};
        s1=sprintf('%s:\trange=[%.3f, %.3f]\tscale=[%.3f, %.3f]',masses{ii}, min(a(:)), max(a(:)),min(s),max(s));
        disp(s1);
    end
    %set(handles.axes1,'xtick',[],'ytick',[],'dataaspectratio',[1 1 1]);
    %set(ax,'dataaspectratio',[1 1 1],'xtick',[],'ytick',[],'box','on'); %,'FontSize',10);
    %b=colorbar('location','SouthOutside','FontSize',8);
    %set(b,'OuterPosition',[0.105 0.005 0.8 0.0467]);
end

% display masses in a separate window that will be then exported as PNG
if handles.flag
    nim=length(im);
    if nim>4
        noc=ceil(nim/2);
        jmax=2;
    else
        noc=nim;
        jmax=1;
    end
    
    w=size(im{1},2);    
    h=size(im{1},1);    
    immat=zeros(jmax*h,noc*w);
    immat_conf=ones(jmax*h,noc*w);
    
    % assemble images into a big matrix
    k=0;
    for jj=1:jmax
        for ii=1:noc
            k=k+1;
            if k<=nim
                a=double(im{k}(:,:,n));
                if iscell(im_conf)
                    a_conf = double(im_conf{k}(:,:,n));
                else
                    a_conf = ones(size(a));
                end
                s=double(scales{k});
                if get(handles.checkbox2,'value')==1
                    if s(1)==0
                        if handles.name_prefix=='m'
                            s(1)=1;
                            if s(2)<10
                                s(1)=0.5;
                            end
                        else
                            s(1)=1e-4;
                        end
                    end
                    a=log10(a);
                    s=log10(s);
                end
                ims=size(cmap2,1)*(a-min(s))/(max(s)-min(s));
                ind=find(ims<0);
                if ~isempty(ind)
                    ims(ind)=zeros(size(ind)); 
                end
                ind=find(ims>size(cmap2,1));
                if ~isempty(ind)
                    ims(ind)=size(cmap2,1)*ones(size(ind));
                end
                immat((jj-1)*h+[1:h],(ii-1)*w+[1:w])=ims;
                immat_conf((jj-1)*h+[1:h],(ii-1)*w+[1:w])=a_conf;
            end
        end
    end
    
    % convert from indexed image to rgb, so that we can apply hue
    % modulation and recolor the annotation areas to white    
    im2=ind2rgb(round(immat),cmap2);
    
    % add hue modulation
    for jj=1:size(im2,3)
        im2(:,:,jj) = im2(:,:,jj).*immat_conf;
    end
    immat = im2;
    
    % add white areas for annotations
    %fac = round(h/128);
    fac = (h/128);
    im2 = ones(size(immat,1)+round((jmax+1)*(fontsize+2*font_gap)*fac),size(immat,2), size(immat,3));
    for jj=1:size(immat,3)
        im2([1:h]+round((fontsize+2*font_gap)*fac),:,jj) = immat([1:h],:,jj);
        if jmax>1
            im2([1:h]+h+round(2*(fontsize+2*font_gap)*fac),:,jj) = immat([1:h]+h,:,jj);
        end
    end
    %immat = im2;
    % display the assembled image
    %cmap = get(handles.popupmenu2,'value');
    %def_cmat = get_colormap(cmap);
    % convert from indexed image to rgb, so that we can recolor the
    % annotation areas to white
    %im2=ind2rgb(round(immat),def_cmat);
    % recolor the annotation areas to white
    %for jj=1:(jmax+1)
    %    ind = [1:round((fontsize+2*font_gap)*fac)] + round((jj-1)*(h+(fontsize+2*font_gap)*fac));
    %    im2(ind,:,1)=1;
    %    im2(ind,:,2)=1;
    %    im2(ind,:,3)=1;
    %end
    im = im2;
    [f31, ax31] = my_figure(31);
    fpos=get(f31,'position');
    %a = imagesc_conf(immat, min(immat(:)), max(immat(:)), immat_conf, cmap);
    im31 = findall(ax31,'type','Image');
    if isempty(im31)
        if isempty(ax31)
            ax31=subplot(1,1,1);
        end
        image(im);
        %colormap(cmap);    
        set(ax31,'xtick',[],'ytick',[],'box','off',...
            'xcolor',0.999*[1 1 1],'ycolor',0.999*[1 1 1]);
        % add mass names and scale
        k=0;
        for jj=1:jmax
            for ii=1:noc
                k=k+1;
                if k<=nim
                    t=text((ii-1)*w+w/2,...
                        round((jj-1)*(h+fac*(fontsize+2*font_gap))+(fontsize/2+font_gap)*fac+0),...
                        sprintf('%s [%d %d]',masses{k},[floor(scales{k}(1)) ceil(scales{k}(2))]),...
                        'HorizontalAlignment','center','VerticalAlignment','middle',...
                        'Fontsize',fontsize,'FontName','Helvetica');
                end
            end
        end
        pf = additional_settings.print_factors(1);
        ww=7;
        set(f31,'PaperPosition',[0.25 0.5 pf*1.3*ww pf*ww]);
        set(f31,'Position',[fpos(1:2) 200*[noc size(im,1)/h]]);
        set(f31,'toolbar','none');
        set(ax31,'position',[0.0 0.0 1 1]);
        set(ax31,'DataAspectRatio',[1 1 1]);
        set(f31,'PaperPositionMode','auto')        
    else
        set(im31,'CData',im);
    end
    s=sprintf('%dx%dpix n=%d',w,h,n);
    t31 = findobj(ax31,'tag','bottom_title');    
    if isempty(t31)
        t=text(noc/2*w,...
               round(jmax*(h+fac*(fontsize+2*font_gap))+(fontsize/2+font_gap)*fac+0),...
               s,...
               'HorizontalAlignment','center','VerticalAlignment','middle',...
               'Fontsize',fontsize,'FontName','Helvetica','tag','bottom_title');
    else
        set(t31,'String',s);
    end
    fid = f31;    
end
a=0;


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



function popupmenu2_Callback(hObject,eventdata,handles)
i=str2num(get(handles.text1,'String'));
display_images(handles.imagestack,handles.imscales,handles.immasses,i,handles,hObject,0,handles.imagestack_conf);


function pushbutton10_Callback(hObject, eventdata, handles)
% set the flag for displaying images in a separate window, when exporting
% as PNG, to 1.
handles.flag=1;
% create output dir
outdir = [handles.fdir 'frames' filesep];
if ~isfolder(outdir)
    mkdir(outdir);
    fprintf(1,'Directory %s created\n',outdir);
end
% export mass images
if get(handles.checkbox3,'value')==1
    % export all, starting from the first frame
    fid=pushbutton7_Callback(hObject, eventdata, handles);
    i=str2num(get(handles.text1,'String'));
    nmax=str2num(get(handles.text3,'String'));
    %print_factor=1;
    %pp=get(handles.figure1,'PaperPosition');
    %set(handles.figure1,'PaperPosition',[pp(1:2) print_factor*pp(3:4)]);
    while i<nmax
        %display_images(handles.imagestack,handles.imscales,handles.immasses,i,handles,0);
        if get(handles.checkbox2,'value')==1
            fout = [outdir handles.name_prefix '-log-' getid(i,3,1) '.png'];
        else
            fout = [outdir handles.name_prefix '-' getid(i,3,1) '.png'];
        end
        print(fid,fout,'-dpng');
        %print_figure(f1,fout,additional_settings.print_factors(6));
        fprintf(1,'Frame %d exported as %s\n',i,fout);
        fid=pushbutton5_Callback(hObject, eventdata, handles);
        i=str2num(get(handles.text1,'String'));
    end
    % export last frame and jump to the start
    fid=display_images(handles.imagestack,handles.imscales,handles.immasses,i,handles,hObject,0,handles.imagestack_conf);
    if get(handles.checkbox2,'value')==1
        fout = [outdir handles.name_prefix '-log-' getid(i,3,1) '.png'];
    else
        fout = [outdir handles.name_prefix '-' getid(i,3,1) '.png'];
    end
    print(fid,fout,'-dpng');
    fprintf(1,'Frame %d exported as %s\n',i,fout);
    fid=pushbutton7_Callback(hObject, eventdata, handles);
else
    % export the currently shown frame
    i=str2num(get(handles.text1,'String'));
    fid=display_images(handles.imagestack,handles.imscales,handles.immasses,i,handles,hObject,0,handles.imagestack_conf);
    if get(handles.checkbox2,'value')==1
        fout = [outdir handles.name_prefix '-log-' getid(i,3,1) '.png'];
    else
        fout = [outdir handles.name_prefix '-' getid(i,3,1) '.png'];
    end
    print(fid,fout,'-dpng');
    fprintf(1,'Frame %d exported as %s\n',i,fout);
end

handles.flag = 0;
guidata(hObject, handles);
close(fid);

function hide_controls(h,s)
set(h.text1,'visible',s);
set(h.text2,'visible',s);
set(h.text3,'visible',s);
set(h.text5,'visible',s);
set(h.pushbutton7,'visible',s);
set(h.pushbutton4,'visible',s);
set(h.pushbutton5,'visible',s);
set(h.pushbutton9,'visible',s);
set(h.pushbutton10,'visible',s);
set(h.pushbutton1,'visible',s);
set(h.popupmenu2,'visible',s);