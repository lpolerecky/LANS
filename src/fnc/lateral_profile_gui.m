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
end

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
    handles.image_stack = varargin{6};
    handles.mass_names = varargin{7};
    handles.mass_ratio_flag = varargin{8};
end

% keep only non-empty images
jj=0;
for ii=1:length(handles.images)
    if ~isempty(handles.images{ii})
        jj=jj+1;
        im{jj} = handles.images{ii};
        s{jj} = handles.scales{ii};
        r{jj} = handles.ratios{ii};
    end
end
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
    set(handles.edit2,'string', num2str(handles.scales{1}(1)));
    set(handles.edit3,'string', num2str(handles.scales{1}(2)));    
end
    
handles = update_gui_fontsize(handles);

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

% chil = handles.axes1.Children;
% ind_img = [];
% for ii=1:length(chil)
%     if strcmp(chil(ii).Type,'image'), ind_img=ii; end
%     if strcmp(chil(ii).Type,'image'), ind_img=ii; end
%     
% end
% imdata = chil(ind).CData;
% fig = figure;
% ax = subplot(1,1,1); hold off;
% imagesc(imdata, quantile(imdata(:), additional_settings.autoscale_quantiles));
% set(ax, 'DataAspectRatio',[1 1 1])

fprintf(1,'Draw polygon within the image\n');
fprintf(1,'* Left-click to add a point.\n');
fprintf(1,'* Double-click to define last point.\n');
fprintf(1,'* Double-click on the line to add a point.\n');
fprintf(1,'* Click and drag to move the polygon.\n');

% define polygon within the current image
ax = handles.axes1;
polygon = images.roi.Polyline(ax, 'Color', 'w', 'Tag', 'lans_polygon');
draw(polygon);
handles.polygon = polygon;

% wait(roi);

% define profile using a mouse
% [h,pos]=add_lans_line(handles.axes1);
% pos=round(pos);
% handles.pos = pos;
% fprintf(1,'Line defined: from [%d %d] to [%d %d]\n',pos(1,:),pos(2,:));
% % fill the line coordinates in the gui, for later use
% set(handles.edit2,'string',num2str(pos(1,1)))
% set(handles.edit3,'string',num2str(pos(1,2)))
% set(handles.edit4,'string',num2str(pos(2,1)))
% set(handles.edit5,'string',num2str(pos(2,2)))
% delete(h);
% [x,y,handles]=plot_lateral_profile(pos,hObject,handles);
guidata(hObject, handles);

function [x,y,handles]=plot_lateral_profile(pos, hObject, handles)
[x y] = get_points_lateral_profile(pos);
if ~isfield(handles,'line') | (isfield(handles,'line') & isempty(handles.line))
    axes(handles.axes1); hold on;
    line = plot(x,y,'w-');
    handles.line = line;
else
    set(handles.line,'xdata',x,'ydata',y);
end
%guidata(hObject, handles);

function pushbutton5_Callback(hObject, eventdata, handles)
if isfield(handles,'polygon')
%if ishandle(handles.polygon)
    xy = handles.polygon.Position;
    
    workdir=handles.fdir;
    if(isfolder(workdir))
        newdir=workdir;
    else
        newdir='';
    end

    def_file = [workdir 'polygon_xy'];
    fprintf(1,'Specify a file name for storing the polygon coordinates (default %s.dat)\n',def_file);

    [FileName,newdir,~] = uiputfile('*.dat', 'Select *.DAT file', def_file);
    if(FileName~=0)
        polygonfile = [newdir, FileName];
        save(polygonfile,'xy','-ascii');
    end

end

function pushbutton6_Callback(hObject, eventdata, handles)
workdir=handles.fdir;
if(isfolder(workdir))
    newdir=workdir;
else
    newdir='';
end
def_file = [workdir 'polygon_xy.dat'];
fprintf(1,'Select a file with polygon coordinates (default %s)\n',def_file);

[FileName,newdir,~] = uigetfile('*.dat', 'Select *.DAT file', def_file);
if(FileName~=0)
    polygonfile = [newdir, FileName];
    fid=fopen(polygonfile,'r');
    xy = fscanf(fid,'%f %f',[2,inf]);
    fclose(fid);
    xy = xy';
end
if isfield(handles,'polygon') 
    if isvalid(handles.polygon)
        handles.polygon.Position = xy;
    else
        ax = handles.axes1;
        polygon = images.roi.Polyline(ax, 'Color', 'w', 'Tag', 'lans_polygon');
        polygon.Position = xy;
        handles.polygon = polygon;
    end
else
    ax = handles.axes1;
    polygon = images.roi.Polyline(ax, 'Color', 'w', 'Tag', 'lans_polygon');
    polygon.Position = xy;
    handles.polygon = polygon;
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global additional_settings;

% get the thickness of the profile from the gui
lw = str2num(get(handles.edit1,'string'));        
if lw<1, lw=1; end
set(handles.edit1,'string', num2str(lw));

%% obsolete from 2020-03-28
if 0
% get the line coordinates from the gui and plot it
pos(1,1) = str2num(get(handles.edit2,'string'));
pos(1,2) = str2num(get(handles.edit3,'string'));
pos(2,1) = str2num(get(handles.edit4,'string'));
pos(2,2) = str2num(get(handles.edit5,'string'));

% plot the lateral profile within the image

% get the x-y coordinates of each point on it along the way
[x,y,handles]=plot_lateral_profile(pos,hObject,handles);

% make sure that the pixels lie inside the image
[h,w]=size(handles.images{1});
ind = find(x>=1 & x<=w & y>=1 & y<=h);
x = x(ind);
y = y(ind);
end

%% for all masses, calculate the mean counts and ratios along a profile

% extract the relevant variables from the handles
ratios=handles.ratios;
images=handles.images;
scales=handles.scales;
image_stack=handles.image_stack;
mass=handles.mass_names;

if isfield(handles,'polygon')
%if ishandle(handles.polygon)
    xy = handles.polygon.Position; 
    
    % store lateral profiles (dim 1) for each plane (dim 2) and mass
    % {imass}, and also accumulated over all planes
    lprofiles = cell(1,length(image_stack));
    lprofiles_accu1 = lprofiles;
    lprofiles_accu2 = lprofiles;
    fprintf(1,'Extracting data along the profile...');
    for imass = 1:length(image_stack)
        ims_i = image_stack{imass};
        for iplane = 1:size(ims_i,3)
            [pos, accuval, allval] = get_lateral_profile(xy(:,1), xy(:,2), ...
                ims_i(:,:,iplane), lw, handles.scale);
            if imass==1 && iplane==1
                lprofiles{imass} = zeros(length(pos), size(ims_i,3));
                lprofiles_accu1{imass} = zeros(length(pos), size(ims_i,3), lw);
            end
            lprofiles{imass}(:, iplane) = accuval;  % accumulated over profile width
            lprofiles_accu1{imass}(:, iplane, :) = allval; % complete data (all profile pixels, all plances)
        end
        lprofiles_accu1{imass} = squeeze(sum(lprofiles_accu1{imass},2));
        lprofiles_accu2{imass} = sum(lprofiles_accu1{imass},2);
    end
    fprintf(1,'done\n');
         
    % calculate lateral profiles of ratios for each plane and also for the
    % accumulated data
    ratio_planes=cell(1,length(ratios));
    ratio_accu = ratio_planes;
    sd_ratio_accu = ratio_planes;
    for ir=1:length(ratios)
        % find the formula in r        
        [formula PoissErr mass_index] = parse_formula_lans(ratios{ir},mass);
        if ~isempty(formula)            
            warning('off');
            % for each plane
            m = lprofiles;
            cell_sizes = ones(size(m{1}));
            LWratio = ones(size(m{1}));
			Np = lw;
            eval(formula);
            if handles.mass_ratio_flag==1
                r = r/lw;
            end
            ratio_planes{ir} = r;
            % for each profile within the parallel profiles (profile
            % thickness)
            m = lprofiles_accu1;
            Np = size(image_stack{imass},3);
            cell_sizes = ones(size(m{1}));
            LWratio = ones(size(m{1}));
            eval(formula);
            sd_ratio_accu{ir} = std(r,0,2);
            % for accumulated
			Np = size(image_stack{imass},3)*lw;
            m = lprofiles_accu2;
            cell_sizes = ones(size(m{1}));
            LWratio = ones(size(m{1}));
            eval(formula);
            if handles.mass_ratio_flag==1
                r = r/lw;
            end
            ratio_accu{ir} = r;            
            warning('on');
            
            if 0 && ir==7
                % debug
                figure;
                subplot(3,1,1);
                plot(ratio_planes{ir})
                subplot(3,1,2);
                plot(lprofiles_accu1{ir})
                subplot(3,1,3);
                plot(ratio_accu{ir})
            end
        end
    end
    
    % if everything went well, here we have lateral profiles for 
    % - each mass and plane (lprofiles)
    % - each mass, accumulated over planes (lprofiles_accu)
    % - each ratio and plane (ratio_planes)
    % - each ratio, accumulated over planes (ratio_accu)
    % pos = position along the profile (in um)
 
else
    fprintf(1,'ERROR: Please draw a polyline first.\n');
end

if hObject == handles.pushbutton2  % display lateral profiles   
    
    if get(handles.checkbox3,'value')==0 % plot only for the selected mass or ratio

        jj = get(handles.popupmenu1,'value');
        jj_range = get(handles.listbox1,'Value');
        if length(jj_range)==1
            jj_range = jj;
        end

        if get(handles.checkbox1,'value')
            if get(handles.checkbox7,'value')
                f60=figure;
            else
                f60=figure(160+jj); 
            end
            njj=length(jj_range);
            for ii=1:njj
                sjj=subplot(njj,1,ii); hold off;
                meanv(:,:,ii) = ratio_planes{jj_range(ii)};
                stdv = zeros(size(meanv));
                if handles.mass_ratio_flag==1
                    imsc = scales{jj_range(ii)}/size(ratio_planes{jj_range(ii)},2);
                else
                    imsc = scales{jj_range(ii)};
                end
                imagesc(pos, [1:size(meanv,2)], meanv(:,:,ii)', imsc);
                
                title(ratios{jj_range(ii)}, 'FontSize',additional_settings.defFontSize);
                if njj<5
                    ylabel('depth (block)', 'FontSize',additional_settings.defFontSize);
                end
                if ii<njj
                    set(sjj,'xticklabel',[]);
                end
                if ii==njj
                    xlabel('distance (micron)', 'FontSize',additional_settings.defFontSize);            
                end
                cb=colorbar;
            end
            colormap(get_colormap(additional_settings.colormap));
        else
            if get(handles.checkbox7,'value')
                f60=figure;
            else
                f60=figure(60+jj); 
            end
            njj=length(jj_range);
            for ii=1:njj
                sjj=subplot(njj,1,ii); hold off;
                meanv(:,ii) = ratio_accu{jj_range(ii)};
                stdv(:,ii) = sd_ratio_accu{jj_range(ii)};
                global additional_settings;
                if additional_settings.display_error_bars
                    errorbar(pos,meanv(:,ii),stdv(:,ii),'sk-');
                    fprintf(1,'ERROR-BAR length = SD over profile pixels (N=%d)\n',lw);
                else
                    plot(pos, meanv(:,ii), 'sk-');
                end
                xlim([min(pos) max(pos)]);
                title(ratios{jj_range(ii)}, 'FontSize',additional_settings.defFontSize);                
                if ii<njj
                    set(sjj,'xticklabel',[]);
                end
                if ii==njj
                    xlabel('distance (micron)', 'FontSize',additional_settings.defFontSize);            
                end
            end
            
        end
        
        export_lateral_profile(hObject,eventdata,handles,jj,jj_range,pos,meanv,stdv,xy,lw,f60);       

    else

        % plot normalized values in one graph. normalization is done such that
        % the corresponding handles.scales will transform to [0 1]

        jj_range = get(handles.listbox1,'Value');
        
        if get(handles.checkbox1,'value')
            if length(jj_range)>3
                fprintf(1,'WARNING: max 3 ratios can be combined.\n');
                jj_range = jj_range(1:3);
                set(handles.listbox1,'Value',jj_range);
            end
        end        

        if length(jj_range)<2
            fprintf(1,'Error: Please select at least TWO masses or ratios in the left listbox.\n');
        else
            
            for ii=1:length(jj_range)                                
                
                jj = jj_range(ii);
                
                % normalize each profile
                fac = diff(handles.scales{jj});
                if get(handles.checkbox1,'value')                   
                    mv = (ratio_planes{jj}-handles.scales{jj}(1))/fac;
                    sv = sd_ratio_accu{jj}/fac;
                    mv(mv<0)=0; mv(mv>1)=1;
                    if ii==1
                        meanv = zeros(size(mv,1),size(mv,2),3);
                        stdv = meanv;
                        meanv_norm = meanv;
                        tit = sprintf('R=%s',ratios{jj});
                    elseif ii==2
                        tit = sprintf('%s, G=%s', tit, ratios{jj});
                    elseif ii==3
                        tit = sprintf('%s, B=%s', tit, ratios{jj});
                    end
                    meanv_norm(:,:,ii) = mv;
                    stdv_norm(:,:,ii) = sv*ones(1,size(mv,2));
                    meanv(:,:,ii) = ratio_planes{jj};
                    stdv(:,:,ii) = zeros(size(ratio_planes{jj}));
                else
                    mv = (ratio_accu{jj}-handles.scales{jj}(1))/fac;
                    sv = sd_ratio_accu{jj}/fac;
                    if ii==1
                        meanv = zeros(size(mv,1),length(jj_range));
                        stdv = meanv;
                        meanv_norm = meanv;
                    end
                    meanv_norm(:,ii) = mv;
                    stdv_norm(:,ii) = sv;
                    meanv(:,ii) = ratio_accu{jj};
                    stdv(:,ii) = sd_ratio_accu{jj};
                end
                
            end
            
            % create figure
            if get(handles.checkbox7,'value')
                f60=figure;
            else
                f60=figure(160+jj); 
            end
            subplot(1,1,1); hold off;

            % display lateral profiles
            if get(handles.checkbox1,'value')
                image(pos, [1:size(meanv_norm,1)], permute(meanv_norm,[2 1 3]));
                title(tit, 'FontSize',additional_settings.defFontSize);
                ylabel('depth (block)', 'FontSize',additional_settings.defFontSize);
                xlabel('distance (micron)', 'FontSize',additional_settings.defFontSize);
            else
                col = {'r.-','g.-','b.-','m.-','c.-','k.-','ro-','go-'};
                for jj=1:length(jj_range)
                    if jj>1, hold on; end
                    global additional_settings;
                    if additional_settings.display_error_bars
                        errorbar(pos,meanv_norm(:,jj),stdv_norm(:,jj),col{jj});
                        fprintf(1,'ERROR-BAR length = SD over profile pixels (N=%d)\n',lw);
                    else
                        plot(pos,meanv_norm(:,jj),col{jj});
                    end
                end
                legend(ratios(jj_range), 'FontSize',additional_settings.defFontSize);
                legend('boxoff');
                ylabel('normalized values: [min max]->[0 1]', 'FontSize',additional_settings.defFontSize);                
            end
           
            export_lateral_profile(hObject,eventdata,handles,jj,jj_range,pos,meanv,stdv,xy,lw,f60);
            
        end                

    end
end

if hObject == handles.pushbutton3  % perform pairwise regression analysis
    
    jj_range = get(handles.listbox1,'Value');    

    if length(jj_range)<2
        fprintf(1,'Error: Please select at least TWO masses or ratios in the left listbox.\n');
    else
        
        fprintf(1,'Pair-wise regression analysis of values along the profile\n')
        % create figure
        if get(handles.checkbox7,'value')
            f70=figure;
        else
            f70=figure(70); 
        end
        
        Nvar = length(jj_range);
        Ngraphs = Nvar*(Nvar-1)/2;
        splot_x = ceil(sqrt(Ngraphs));
        splot_y = ceil(Ngraphs/splot_x);    
        if Nvar>1
            k=1;
            for jj=1:(Nvar-1)
                for ii=(jj+1):Nvar
                    subplot(splot_y,splot_x,k); hold off;
                    if get(handles.checkbox1,'value')
                        xk = ratio_planes{jj_range(jj)};
                        yk = ratio_planes{jj_range(ii)};
                    else
                        xk = ratio_accu{jj_range(jj)};
                        dxk = sd_ratio_accu{jj_range(jj)};
                        yk = ratio_accu{jj_range(ii)};
                        dyk = sd_ratio_accu{jj_range(ii)};
                    end
                    r = get(handles.popupmenu1,'string');
                    
                    x=xk(:); y=yk(:); dx=dxk(:); dy=dyk(:);                   
                    global additional_settings;
                    if additional_settings.display_error_bars
                        pl1=errorbar(x,y,dy,dy,dx,dx,'x','Markersize',3);
                        fprintf(1,'ERROR-BAR length = SD over profile pixels (N=%d)\n',lw);
                    else
                        pl1=plot(x,y,'x','Markersize',3);
                    end
                    % test for significant correlation
                    [R,P] = corrcoef(x,y);
                    fprintf(1,'** %s versus %s:\n',r{jj_range(jj)}, r{jj_range(ii)});
                    fprintf(1,'Correlation coefficient: R = %.2e (p=%.2e)\n', R(1,2),P(1,2));                    
                    % fit with a line
                    p = polyfit(x,y,1);
                    hold on;
                    pl2=plot(sort(x),polyval(p,sort(x)),'k-','LineWidth',2);
                    fprintf(1,'Linear fit (y=ax+b): a = %.2e b = %.2e\n',p);                 
                    xlabel(r{jj_range(jj)});
                    ylabel(r{jj_range(ii)});
                    k=k+1;                    
                end
            end
        end
        colormap(get_colormap(additional_settings.colormap));
    end
end

function export_lateral_profile(hObject,eventdata,handles,jj,jj_range,pos,meanv,stdv,xy,lw,f60)

global additional_settings;

defFontSize = additional_settings.defFontSize;

figure(f60);
%xlabel('distance (micron)', 'FontSize',defFontSize);
%set(gca,'xlim',[min(pos) max(pos)], 'FontSize',defFontSize);

% export profile as ASCII text into files with suggested filenames
if get(handles.checkbox2,'value')
    for j=1:length(jj_range)
        if size(meanv,3)>1
            out = [pos, meanv(:,:,j), stdv(:,:,j)];
        else
            if length(jj_range)>1
                out = [pos meanv(:,j) stdv(:,j)];
            else
                out = [pos meanv stdv];
            end
        end
        a = get(handles.popupmenu1,'string');
        a1 = a{jj_range(j)};
        a=convert_string_for_texoutput(a1);
        fdir = [handles.fdir,'dat'];
        if ~isfolder(fdir)
            mkdir(fdir);
            fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
        end
        fname = [fdir, delimiter, a,'.dap'];
        [FileName,PathName] = uiputfile('*.dap',['Save lateral profile for ',a1,' as'],fname);
        if length(PathName)~=1 % if cancel was not pressed
            a = [PathName FileName];
            fid = fopen(a,'w');
            global LANS_version;
            fprintf(fid,'%c Generated by Look@NanoSIMS (version %s) on %s\n','%',LANS_version,datestr(now));
            fprintf(fid,'%c Polyline properties:\n');
            fprintf(fid,'%c x:','%');
            fprintf(fid,'\t%.2f',xy(:,1));
            fprintf(fid,'\n');
            fprintf(fid,'%c y:','%');
            fprintf(fid,'\t%.2f',xy(:,2));
            fprintf(fid,'\n');
            fprintf(fid,'%c w: %d (pix)\n','%',lw);
            if size(out,2)>2
                fprintf(fid,'%c pos\tmean in blocks\tSD in blocks\n','%');
            else
                fprintf(fid,'%c pos\tmean\tSD\n','%');
            end
            fmt = '%.3f';
            for ii=1:(size(out,2)-1)
                fmt = [fmt '\t%.3e'];
            end
            fmt = [fmt '\n'];
            fprintf(fid,fmt,out');
            fclose(fid);
            fprintf(1,'Lateral profile(s) saved to %s\n',a);
        end
    end
end

% export the graph as EPS
if get(handles.checkbox2,'value') %&& jj==max(jj_range)
    if get(handles.checkbox3,'value')==0
        a = get(handles.popupmenu1,'string');
        a1 = a{jj};
        a=convert_string_for_texoutput(a1);
        fname = [handles.fdir, 'eps', delimiter, a,'-lp'];
    else
        fname = [handles.fdir, 'eps', delimiter, 'all-lp'];
    end
    if get(handles.checkbox1,'value')
        fname = [fname 'd'];
    end
    fname = [fname '.eps'];
    if ~isfolder([handles.fdir 'eps'])
        mkdir([handles.fdir 'eps']);
        fprintf(1,'Directory %s did not exist, so it was created.\n',[handles.fdir 'eps']);
    end
    [FileName,PathName] = uiputfile('*.eps',['Export lateral profile as'],fname);
    if length(PathName)~=1 % if cancel was not pressed
        a = [PathName FileName];
        print_figure(f60,a,additional_settings.print_factors(4));
        mepstopdf(a,'epstopdf');
        %fprintf(1,'Profile exported to %s\n',a);
    end
end

% export the image with the profile line as EPS
if get(handles.checkbox4,'value')
    % redraw the image and the profile in the gui
    %set(handles.popupmenu1,'value',jj);
    %popupmenu1_Callback(hObject, eventdata, handles);
    a = get(handles.popupmenu1,'string');
    a1 = a{jj};
    a=convert_string_for_texoutput(a1);
    fname = [handles.fdir, 'eps', delimiter, a,'-ilp.eps'];
    if ~isfolder([handles.fdir 'eps'])
        mkdir([handles.fdir 'eps']);
        fprintf(1,'Directory %s did not exist, so it was created.\n',[handles.fdir 'eps']);
    end
    [FileName,PathName] = uiputfile('*.eps',['Export image with the lateral profile as'],fname);
    if length(PathName)~=1 % if cancel was not pressed
        a = [PathName FileName];
        % pretty print the image together with the profile
        [~, f]=plotImageCells(10+jj,handles.images{jj},[],handles.fdir,handles.ratios{jj},...
                ['w-'],handles.scales{jj},...
                [0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0],0,0, handles.scale, handles.fdir, [], [],[]);
        hold on;
        [cx, cy, ~] = improfile(handles.images{jj}, xy(:,1), xy(:,2), 'bicubic');
        plot(cx,cy,'w:','LineWidth',2);
        % print it to eps and pdf
        print_figure(f,a,additional_settings.print_factors(1));
        mepstopdf(a,'epstopdf');
        delete(f);
        %fprintf(1,'Profile exported to %s\n',a);
    end   
end

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

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
min_scale = str2num(get(handles.edit2,'string'));
max_scale = str2num(get(handles.edit3,'string'));
jj = get(handles.popupmenu1,'value');
if min_scale<max_scale
    handles.scales{jj} = [min_scale max_scale];
end
set(handles.axes1,'CLim', handles.scales{jj});
guidata(hObject, handles);


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
chil = handles.axes1.Children;
if length(chil)>1
    for ii=1:length(chil)
        if strcmp(chil(ii).Type,'image')
            chil = chil(ii);
            break;
        end
    end
end
set(chil, 'CData', handles.images{jj});
set(handles.axes1, 'CLim', handles.scales{jj});
%axes(handles.axes1); hold off;
%imagesc(handles.images{jj},handles.scales{jj});
title(handles.ratios{jj});
%set(handles.axes1,'dataaspectratio',[1 1 1],'FontSize',defFontSize);
%b=colorbar('FontSize',10);
%colormap(clut);
%colormap(get_colormap(additional_settings.colormap));

set(handles.edit2,'string', num2str(handles.scales{jj}(1)))
set(handles.edit3,'string', num2str(handles.scales{jj}(2)))

% add the profile, if it exists
%pos(1,1) = str2num(get(handles.edit2,'string'));
%pos(1,2) = str2num(get(handles.edit3,'string'));
%pos(2,1) = str2num(get(handles.edit4,'string'));
%pos(2,2) = str2num(get(handles.edit5,'string'));
% because the image was redrawn with hold off, the profile does not exist
% any more, so delete the handles.line field
%if isfield(handles,'line')
%    handles=rmfield(handles,'line');
%end;
%[x,y,handles]=plot_lateral_profile(pos,hObject,handles);
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

function window_resized_Callback(hObject, eventdata, handles)

wpos = get(hObject,'Position');
% ensure that window size does not go below design values
if wpos(3)<85.71 || wpos(4)<45.375
    wpos(3)=85.71;
    wpos(4)=45.375;
    set(hObject,'Position',wpos);
    fprintf(1,'Warning: size of the window cannot be below w=85.71 and h=45.375. Reseting.\n');
end

p1pos = handles.uipanel1.Position;
p1pos(2) = wpos(4)-p1pos(4) - 0.07;
handles.uipanel1.Position = p1pos;
p2pos = handles.uipanel2.Position;
p2pos(2) = 0.07;
handles.uipanel2.Position = p2pos;

%apos = handles.axes1.Position;
%apos(1) = 0.03;
% apos(2) = p2pos(2)+p2pos(4) + 1.37;
% %apos(4) = wpos(4) - p1pos(4) - p2pos(4) - 2*1.37;
% apos(3) = wpos(3);
%handles.axes1.Position = apos;
a=0;
