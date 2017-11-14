function varargout = lateral_profile_gui(varargin)
% LATERAL_PROFILE_GUI MATLAB code for lateral_profile_gui.fig
%      LATERAL_PROFILE_GUI, by itself, creates a new LATERAL_PROFILE_GUI or raises the existing
%      singleton*.
%
%      H = LATERAL_PROFILE_GUI returns the handle to a new LATERAL_PROFILE_GUI or the handle to
%      the existing singleton*.
%
%      LATERAL_PROFILE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LATERAL_PROFILE_GUI.M with the given input arguments.
%
%      LATERAL_PROFILE_GUI('Property','Value',...) creates a new LATERAL_PROFILE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lateral_profile_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lateral_profile_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lateral_profile_gui

% Last Modified by GUIDE v2.5 30-Oct-2011 21:47:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lateral_profile_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @lateral_profile_gui_OutputFcn, ...
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


% --- Executes just before lateral_profile_gui is made visible.
function lateral_profile_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lateral_profile_gui (see VARARGIN)


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
    handles.scale = varargin{5};
    %handles.print_factor = varargin{6};
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
handles.x = [];
handles.y = [];

% display the first image
set(handles.popupmenu1,'string',r);
set(handles.listbox1,'string',r);
if jj>0
    axes(handles.axes1); hold off;
    imagesc(handles.images{1},handles.scales{1});
    title(handles.ratios{1});
    set(handles.popupmenu1,'value',1);
    set(handles.axes1,'dataaspectratio',[1 1 1],'FontSize',defFontSize);
    b=colorbar('FontSize',defFontSize);
    %colormap(clut);
    colormap(get_colormap(additional_settings.colormap));
end;
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lateral_profile_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lateral_profile_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% define profile using a mouse
[h,pos]=add_lans_line(handles.axes1);
pos=round(pos);
handles.pos = pos;
fprintf(1,'Line defined: from [%d %d] to [%d %d]\n',pos(1,:),pos(2,:));
% fill the line coordinates in the gui, for later use
set(handles.edit2,'string',num2str(pos(1,1)))
set(handles.edit3,'string',num2str(pos(1,2)))
set(handles.edit4,'string',num2str(pos(2,1)))
set(handles.edit5,'string',num2str(pos(2,2)))
delete(h);
[x,y,handles]=plot_lateral_profile(pos,hObject,handles);
guidata(hObject, handles);

function [x,y,handles]=plot_lateral_profile(pos, hObject, handles)
% connect the beginning and end points with a line and get the coordinates
% of the pixels on the line
k = diff(pos,1);
if abs(k(1))>abs(k(2))
    dx = diff(pos(:,1))/abs(diff(pos(:,1)));
    x = [pos(1,1):dx:pos(2,1)];
    y = round((x-x(1))*k(2)/k(1) + pos(1,2));
else
    dy = diff(pos(:,2))/abs(diff(pos(:,2)));
    y = [pos(1,2):dy:pos(2,2)];
    x = round((y-y(1))*k(1)/k(2) + pos(1,1));
end;
if ~isfield(handles,'line') | (isfield(handles,'line') & isempty(handles.line))
    axes(handles.axes1); hold on;
    line = plot(x,y,'w-');
    handles.line = line;
else
    set(handles.line,'xdata',x,'ydata',y);
end;
%guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if matversion==2015
	defFontSize=10;
else
  defFontSize=14;
end;

% read the line coordinates from the gui and plot it
pos(1,1) = str2num(get(handles.edit2,'string'));
pos(1,2) = str2num(get(handles.edit3,'string'));
pos(2,1) = str2num(get(handles.edit4,'string'));
pos(2,2) = str2num(get(handles.edit5,'string'));
[x,y,handles]=plot_lateral_profile(pos,hObject,handles);

% calculate the mean and std of images along the profile
      
% make sure that the pixels lie inside the image
[w,h]=size(handles.images{1});
ind = find(x>=1 & x<=w & y>=1 & y<=h);
x = x(ind);
y = y(ind);

Nx = length(x);
pos = sqrt((x-x(1)).^2 + (y-y(1)).^2);  % position along the profile

r=handles.ratios;
im=handles.images;
pos=pos(:)/(size(im{1},1)-1)*handles.scale; % position in um

% thickness of the profile
lw = str2num(get(handles.edit1,'string'));        
if lw<1, lw=1; end;
set(handles.edit1,'string', num2str(lw));

%if get(handles.checkbox3,'value')==1 | get(handles.checkbox5,'value')==1
%    jj_range = [1:length(r)]; % display profiles for all images
%else
%    jj_range = get(handles.popupmenu1,'value'); % display profile only for the selected image
%end;       

%global additional_settings;

for jj = 1:length(r)

    N = size(im{jj},1);
    M = size(im{jj},2);                               

    dx = x(Nx)-x(1);
    dy = y(Nx)-y(1);

    % find the values along the (thick) profile

    if abs(dx)>abs(dy) 
        % the profile is more in the horizontal direction
        v = NaN(Nx,lw);
        for ii = 1:lw
            if ii==1
                dj=0;
            else
                if mod(ii,2)==0
                    dj=floor(ii/2);
                else
                    dj=-floor(ii/2);
                end;
            end;                
            % move the profile up and down, depending on the profile thickness
            new_y = y + dj;
            % move the profile also left and right, to account for the
            % fact that it is not completely horizontal
            di = -dy*dj/dx;
            new_x = x + round(di);
            ind = (new_x-1)*N + new_y;               
            inside = find(new_y>=1 & new_y<=N & new_x>=1 & new_x<=M);
            v(inside,ii) = im{jj}(ind(inside));
            % check whether the pixels along the (thick) profile are
            % correctly calculated
            if 0
                figure(70); if ii==1, hold off; else, hold on; end;
                plot(new_x,new_y,'bo',new_x(inside),new_y(inside),'r.');
            end;
        end;            
    else
        % the profile is more in the vertical direction
        v = NaN(Nx,lw);
        for ii = 1:lw
            if ii==1
                di=0;
            else
                if mod(ii,2)==0
                    di=floor(ii/2);
                else
                    di=-floor(ii/2);
                end;
            end;
            % move the profile left and right, depending on the profile thickness
            new_x = x + di;
            % move the profile also up and down, to account for the
            % fact that it is not completely vertical
            dj = -dx*di/dy;
            new_y = y + round(dj);
            ind = (new_x-1)*N + new_y;
            inside = find(new_y>=1 & new_y<=N & new_x>=1 & new_x<=M);
            v(inside,ii) = im{jj}(ind(inside));
            % check whether the pixels along the (thick) profile are
            % correctly calculated
            if 0
                figure(70); if ii==1, hold off; else, hold on; end;
                plot(new_x,new_y,'bo',new_x(inside),new_y(inside),'r.');
            end;
        end;
    end;

    % calculate the mean and std of the values along the profile; do
    % not use the NaN values
    meanv=zeros(Nx,1); stdv=zeros(Nx,1);
    for ii=1:Nx
        val = v(ii,:);
        indnan = find(~isnan(val)==1);
        if ~isempty(indnan)
            meanv(ii)=mean(val(indnan));
            stdv(ii)=std(val(indnan));
        end;
    end;
    
    % remember the values for later plotting and regression analysis
    meanv_all{jj}=meanv;
    stdv_all{jj}=stdv;
    r_all{jj}=r{jj};
    
end;

%if get(handles.checkbox3,'value')==1
%    jj_range = [1:length(r)]; % display profiles for all images
%else
%    jj_range = get(handles.popupmenu1,'value'); % display profile only for the selected image
%end; 

% display values along the profile
% if get(handles.checkbox3,'value')==1
%     f60=figure(60);
% else            
%     
% end;    

if hObject == handles.pushbutton2  % display lateral profiles   
    
    if get(handles.checkbox3,'value')==0 % plot only for the selected mass or ratio

        jj = get(handles.popupmenu1,'value');
        meanv = meanv_all{jj};
        stdv = stdv_all{jj};
        f60=figure(60+jj);

        if get(handles.checkbox1,'value')
            errorbar(pos,meanv,stdv,'sk-');
        else
            plot(pos,meanv,'sk-');
        end;
        ylabel(r{jj}, 'FontSize',defFontSize);

        export_lateral_profile(hObject, eventdata, handles, jj, jj, pos,Nx, meanv,stdv, x,y,lw, f60);

    else

        % plot normalized values in one graph. normalization is done such that
        % the corresponding handles.scales will transform to [0 1]

        jj_range = get(handles.listbox1,'Value');    

        if length(jj_range)<2
            fprintf(1,'Error: Please select at least TWO masses or ratios in the left listbox.\n');
        else
            for ii=1:length(jj_range)
                
                jj=jj_range(ii);
                meanv = meanv_all{jj};
                stdv = stdv_all{jj};
                f60=figure(60);
                if jj==min(jj_range)
                    hold off;
                else
                    hold on;
                end;

                fac = (handles.scales{jj}(2)-handles.scales{jj}(1));
                meanv2=(meanv-handles.scales{jj}(1))/fac;
                %meanv2=(meanv)/fac;
                stdv2=stdv/fac;
                col = {'r.-','g.-','b.-','m.-','c.-','k.-','ro-','go-'};

                if get(handles.checkbox1,'value')
                    errorbar(pos,meanv2,stdv2,col{jj});
                else
                    plot(pos,meanv2,col{jj});
                end;

                if jj==max(jj_range) & get(handles.checkbox3,'value')==1
                    legend(handles.ratios(jj_range), 'FontSize',defFontSize);
                    legend('boxoff');
                    ylabel('normalized values: [min max]->[0 1]', 'FontSize',defFontSize);
                end;
                export_lateral_profile(hObject, eventdata, handles, jj,jj_range, pos,Nx, meanv,stdv, x,y,lw, f60);
                
            end;
        end;

    end;
end;

%figure(f60);
%xlabel('position (micron)', 'FontSize',14);
%set(gca,'xlim',[min(pos) max(pos)], 'FontSize',14);

if hObject == handles.pushbutton3  % perform pairwise regression analysis
    
    jj_range = get(handles.listbox1,'Value');    

    if length(jj_range)<2
        fprintf(1,'Error: Please select at least TWO masses or ratios in the left listbox.\n');
    else
        
        fprintf(1,'Pair-wise regression analysis of values along the profile\n')
        f70=figure(70);
        Nvar = length(jj_range);
        Ngraphs = Nvar*(Nvar-1)/2;
        splot_x = ceil(sqrt(Ngraphs));
        splot_y = ceil(Ngraphs/splot_x);    
        if Nvar>1
            k=1;
            for jj=1:(Nvar-1)
                for ii=(jj+1):Nvar
                    subplot(splot_y,splot_x,k); hold off;
                    x = meanv_all{jj_range(jj)};
                    y = meanv_all{jj_range(ii)};
                    plot(x,y,'k.');
                    xlabel(r{jj_range(jj)});
                    ylabel(r{jj_range(ii)});
                    k=k+1;
                    
                    % test for significant correlation
                    [R,P] = corrcoef(x,y);
                    fprintf(1,'** %s versus %s:\n',r{jj_range(jj)}, r{jj_range(ii)});
                    fprintf(1,'Correlation coefficient: R = %.2e (p=%.2e)\n', R(1,2),P(1,2));                    
                    
                    % fit with a line
                    p = polyfit(x,y,1);
                    hold on;
                    plot(sort(x),polyval(p,sort(x)),'r-');
                    fprintf(1,'Linear fit (y=ax+b): a = %.2e b = %.2e\n',p);
                    
                end;
            end;
        end;
        
    end;
end;

function export_lateral_profile(hObject, eventdata, handles, jj, jj_range, pos,Nx, meanv,stdv, x,y,lw, f60)

global additional_settings;

if isfield(additional_settings,'defFontSize')
    defFontSize = additional_settings.defFontSize;
else 
    defFontSize=10;
end;

figure(f60);
xlabel('position (micron)', 'FontSize',defFontSize);
set(gca,'xlim',[min(pos) max(pos)], 'FontSize',defFontSize);

% export profile as ASCII text into files with suggested filenames
if get(handles.checkbox2,'value')
    out = [pos(:) meanv(:) stdv(:)];
    a = get(handles.popupmenu1,'string');
    a1 = a{jj};
    a=convert_string_for_texoutput(a1);
    fdir = [handles.fdir,'dat'];
    if ~isdir(fdir)
        mkdir(fdir);
        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
    end;
    fname = [fdir, delimiter, a,'.dap'];
    [FileName,PathName] = uiputfile('*.dap',['Save lateral profile for ',a1,' as'],fname);
    if length(PathName)~=1 % if cancel was not pressed
        a = [PathName FileName];
        fid = fopen(a,'w');
        global LANS_version;
        fprintf(fid,'%c Generated by Look@NanoSIMS (version %s) on %s\n','%',LANS_version,datestr(now));
        fprintf(fid,'%c Profile from [%d %d] to [%d %d], width=%d\n',...
            '%',x(1),y(1),x(Nx),y(Nx),lw);
        fprintf(fid,'%c position\tmean\tstd\n','%');
        fprintf(fid,'%.2f\t%.3e\t%.3e\n',out');
        fclose(fid);
        fprintf(1,'Profile saved to %s\n',a);
    end;    
end;

% export the graph as EPS
if get(handles.checkbox2,'value') & jj==max(jj_range)
    if get(handles.checkbox3,'value')==0
        a = get(handles.popupmenu1,'string');
        a1 = a{jj};
        a=convert_string_for_texoutput(a1);
        fname = [handles.fdir, 'eps', delimiter, a,'-lp.eps'];
    else
        fname = [handles.fdir, 'eps', delimiter, 'all-lp.eps'];
    end;
    if ~isdir([handles.fdir 'eps'])
        mkdir([handles.fdir 'eps']);
        fprintf(1,'Directory %s did not exist, so it was created.\n',[handles.fdir 'eps']);
    end;
    [FileName,PathName] = uiputfile('*.eps',['Export lateral profile as'],fname);
    if length(PathName)~=1 % if cancel was not pressed
        a = [PathName FileName];
        print_figure(f60,a,additional_settings.print_factors(4));
        mepstopdf(a,'epstopdf');
        %fprintf(1,'Profile exported to %s\n',a);
    end;   
end;

% export the image with the profile line as EPS
if get(handles.checkbox4,'value')
    % redraw the image and the profile in the gui
    set(handles.popupmenu1,'value',jj);
    popupmenu1_Callback(hObject, eventdata, handles);
    a = get(handles.popupmenu1,'string');
    a1 = a{jj};
    a=convert_string_for_texoutput(a1);
    fname = [handles.fdir, 'eps', delimiter, a,'-ilp.eps'];
    if ~isdir([handles.fdir 'eps'])
        mkdir([handles.fdir 'eps']);
        fprintf(1,'Directory %s did not exist, so it was created.\n',[handles.fdir 'eps']);
    end;
    [FileName,PathName] = uiputfile('*.eps',['Export image with the lateral profile as'],fname);
    if length(PathName)~=1 % if cancel was not pressed
        a = [PathName FileName];
        % pretty print the image together with the profile
        [CELLS, f]=plotImageCells(10+jj,handles.images{jj},[],handles.fdir,handles.ratios{jj},...
                ['w-'],handles.scales{jj},...
                [0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0],0,0, handles.scale, handles.fdir, [], [],[]);
        hold on;
        plot(x,y,'w-');
        % print it to eps and pdf
        print_figure(f,a,additional_settings.print_factors(1));
        mepstopdf(a,'epstopdf');
        delete(f);
        %fprintf(1,'Profile exported to %s\n',a);
    end;   
end;

function set_handles_visible(handles,v)
set(handles.popupmenu1,'visible',v);
set(handles.pushbutton1,'visible',v);
set(handles.pushbutton2,'visible',v);
set(handles.text1,'visible',v);
set(handles.text2,'visible',v);
set(handles.text3,'visible',v);
set(handles.text4,'visible',v);
set(handles.text5,'visible',v);
set(handles.edit1,'visible',v);
set(handles.edit2,'visible',v);
set(handles.edit3,'visible',v);
set(handles.edit4,'visible',v);
set(handles.edit5,'visible',v);
set(handles.checkbox1,'visible',v);
set(handles.checkbox2,'visible',v);
set(handles.checkbox3,'visible',v);
set(handles.checkbox4,'visible',v);

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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% redraw the image
global additional_settings;

if isfield(additional_settings,'defFontSize')
    defFontSize = additional_settings.defFontSize;
else 
    defFontSize=10;
end;

jj=get(handles.popupmenu1,'value');
axes(handles.axes1); hold off;
imagesc(handles.images{jj},handles.scales{jj});
title(handles.ratios{jj});
set(handles.axes1,'dataaspectratio',[1 1 1],'FontSize',defFontSize);
b=colorbar('FontSize',10);
%colormap(clut);
colormap(get_colormap(additional_settings.colormap));

% add the profile, if it exists
pos(1,1) = str2num(get(handles.edit2,'string'));
pos(1,2) = str2num(get(handles.edit3,'string'));
pos(2,1) = str2num(get(handles.edit4,'string'));
pos(2,2) = str2num(get(handles.edit5,'string'));
% because the image was redrawn with hold off, the profile does not exist
% any more, so delete the handles.line field
if isfield(handles,'line')
    handles=rmfield(handles,'line');
end;
[x,y,handles]=plot_lateral_profile(pos,hObject,handles);
guidata(hObject, handles);

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
