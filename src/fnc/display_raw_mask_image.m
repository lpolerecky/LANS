function [maskmass,Maskimg,mass,ps,bw,rgb_true,labs] = display_raw_mask_image(handles,flag,cellname)

if(nargin>1)
    flag_ = flag;
else
    flag_ = 1;
end;

if nargin<3
    global CELLSFILE MAT_EXT;
    cellname=[CELLSFILE MAT_EXT];
end;

% default output
maskmass = [];
Maskimg = [];
mass=[];
ps=[0 1];
bw = 0;
rgb_true = [];
labs = [];
                
if isfield(handles,'p')
    p = handles.p;
    p = load_masses_parameters(handles);

    global additional_settings;
    
    fdir = p.fdir;
    Mask = p.Mask;

    if p.planes_aligned

        if ~isfield(p,'Maskimg')
            fname=[fdir,cellname];

            % fill the Maskimg field from the disk, if it was previously saved,
            % or with zeros if it wasn't.
            if exist(fname) == 2
                fprintf(1,'File %s found on the disk, and used as cells image.\n',fname);
                a=load(fname);
                Maskimg = a.Maskimg;
            else
                Maskimg = zeros(size(p.im{1},1),size(p.im{1},2));
            end;
            
        else
            Maskimg = load_cells_from_disk(handles,0,cellname);
            %Maskimg = p.Maskimg;
        end;

        p.Maskimg = Maskimg;
        
        fignum=51;

        % find out which image is used as template for ROI definition
        [op,opind]=my_intersect(Mask,'/*+-');
        if isempty(op)
                        
            k=identifyMass(p.mass,Mask);
            
            if k>0
                
                % one of the masses will be used as template
                
                maskmass=p.accu_im{k};
                ps=p.imscale{k};
                mass=p.mass{k};
                [opt1,opt3,opt4]=load_options(handles, 1);
                
                % log-transform image, if requested
                if opt1(4)
                    mi=ps(1);
                    ma=ps(2);
                    if(mi==0)
                        mi=1e-3*ma;
                        fprintf(1,'*** Warning: minimum scale was 0, but was set to %.3e due to logarithm scaling of the image.\n',mi);
                    end;
                    logIM=log10(mi)*ones(size(maskmass));
                    ind=find(maskmass>0);
                    logIM(ind)=log10(maskmass(ind));
                    mi=log10(mi);
                    ma=log10(ma);
                    ps=[mi ma];
                    maskmass=logIM;    
                    mass = ['log(',mass,')'];
                end;
                
                bw=opt3(k);
                fprintf(1,'Setting %s as a template for ROI definition.\n',mass);
                
            elseif ~isempty(strfind(lower(Mask),'ext'))
                    
                % external image will be used as template
                % it can be a B&W image, or an RGB image, in which case
                % ps will be a 3x2 matrix
                
                mass=Mask; 
                [FileName,PathName,FilterIndex] = uigetfile({'*.tif';'*.bmp';'*.png';'*.jpg';'*.*'},...
                    'Select external image (B&W or RGB).',fdir);
                fname=[fixdir(PathName),FileName];
                if FileName~=0 & exist(fname)==2                
                    maskmass=double(imread(fname));
                    maskmass=maskmass/max(maskmass(:));
                    ps=[zeros(size(maskmass,3),1) ones(size(maskmass,3),1)];
                    bw = (size(maskmass,3)==1);
                    fprintf(1,'Setting %s:%s as a template for ROI definition.\n',mass,fname);                        
                else
                    maskmass = zeros(size(p.im{1},1),size(p.im{1},2));
                    mass=Mask;
                    ps=[0 1];
                    bw=0;
                    disp('*** Error: No image found. Setting template to zero.');
                end;
                    
            elseif strcmp(lower(Mask),'rgb') | strcmp(lower(Mask),'rgb1')
                
                % an RGB image constructed from the _mass_ images will be
                % used as a template
                
                [opt1,opt3,opt4]=load_options(handles,1);
                % make sure that RGB channels are combined
                opt1(9)=0; opt1(8)=0; opt1(5)=1; opt1(7)=1;
                % construct the RGB image
                [rgb7, rgb8, xl, yl, zl] = ...
                    construct_RGB_image(handles,p.mass,p.imscale,p.Maskimg,p.accu_im,p.accu_im,opt1);
                fignum=51;
                maskmass = rgb7;
                mass = Mask;
                ps = [0 1; 0 1; 0 1];
                bw = 0;
                
            elseif strcmp(lower(Mask),'rgb2')
                
                % an RGB image constructed from the _mass_ images will be
                % used as a template
                
                [opt1,opt3,opt4]=load_options(handles,0);
                % make sure that RGB channels are combined 
                opt1(9)=0; opt1(8)=0; opt1(5)=1; opt1(7)=1;
                
                [R,Ra,Raim,o] = calculate_R_images(p, opt4, 0, 0, p.mask_kernel);
                [rgb7, rgb8, xl, yl, zl, xs, ys, zs, rgb_true] = ...
                    construct_RGB_image(handles,p.special,p.special_scale,p.Maskimg,R,Raim,opt1);
                labs = {xl, yl, zl};
                fignum=52;
                maskmass = rgb7;
                mass = Mask;
                ps = [0 1; 0 1; 0 1];
                bw = 0;
                
            else
                
                % no supported template recognized 
                fprintf(1,'*** Error: No supported template identified. Setting to zero.\n');

            end;
            
        else
            
            % a ratio image is used as template
            k=identifyMass(p.special,Mask);
            
            if k>0
                
                % make sure that only the k^th ratio is calculated
                opt4 = zeros(1,8);
                opt4(k) = 1;
                maskmass = calculate_R_images(p, opt4, 0, 0, p.mask_kernel);
                maskmass = maskmass{k};
                ps = p.special_scale{k};
                [opt1,opt3,opt4]=load_options(handles,0);
                
                mass = Mask;
                
                % log-transform image, if requested
                if opt1(4)
                    mi=ps(1);
                    ma=ps(2);
                    if(mi==0)
                        mi=1e-3*ma;
                        fprintf(1,'*** Warning: minimum scale was 0, but was set to %.3e due to logarithm scaling of the image.\n',mi);
                    end;
                    logIM=log10(mi)*ones(size(maskmass));
                    ind=find(maskmass>0);
                    logIM(ind)=log10(maskmass(ind));
                    mi=log10(mi);
                    ma=log10(ma);
                    ps=[mi ma];
                    maskmass=logIM; 
                    mass = ['log(',mass,')'];
                end;

                bw = opt3(k);
                
                fprintf(1,'Setting %s as a template for ROI definition.\n',mass);
                
            else
                
                % no supported template recognized 
                fprintf(1,'*** Error: Ratio defined as template not recognized in the list of ratios.\n');
                fprintf(1,'Setting template to zero.\n');
            
            end;
            
        end;

        if 1 & ~isempty(maskmass) & sum(p.mask_kernel)>2
            
            % apply smoothing kernel on the template
            fprintf(1,'*** Smoothing template for ROI definition with wiener2 filter, kernel-size [%d] ... ',p.mask_kernel(1));
            for ii=1:size(maskmass,3)
                maskmass(:,:,ii) = wiener2(maskmass(:,:,ii),p.mask_kernel(1)*[1 1]);
            end;
            if ~isempty(rgb_true)
                for ii=1:size(rgb_true,3)
                    rt = squeeze(rgb_true(:,:,ii));
                    rtw = wiener2(rt,p.mask_kernel(1)*[1 1]);
                    ind = find(isnan(rtw) & ~isnan(rt));
                    rtw(ind) = rt(ind);
                    rgb_true(:,:,ii) = rtw;
                end;
                % wiener2 filter increases the patches with NaN values.
                % patch it back based on the original image
            end;
            % after smoothing the values can sometimes go out of allowed
            % range, which can be a problem for displaying it if the
            % maskmass is an RGB image
            if size(maskmass,3)>1
                ind=find(maskmass>1);
                if ~isempty(ind)
                    maskmass(ind)=ones(size(ind));
                end;
                ind=find(maskmass<0);
                if ~isempty(ind)
                    maskmass(ind)=zeros(size(ind));
                end;
            end;
            fprintf(1,'Done.\n*** Set smoothing kernel to 1 if you do not want the template image to be smoothed.\n');
            
        end;

        if flag_ & ~isempty(maskmass)
            [opt1,opt3,opt4]=load_options(handles,1);
            plotImageCells(fignum,maskmass,Maskimg,fdir,mass,...
                [my_get(handles.edit62,'string'),'-'],ps,...
                [1 0 0 0 0 1 0 0 0 0 0 0 0 0 opt1(15) 0],bw,...
                0,p.scale,'Template for ROI definition',[],[],[]);
            % export mask image if it is ext, so that one can have it
            % nicely printed also with the cell outlines
            [opt1,opt3,opt4]=load_options(handles,1);
            if opt1(11)==1 & strcmp(mass,'ext')==1
                fn = [fdir 'eps' delimiter];
                if ~isdir(fn)
                    mkdir(fn);
                    fprintf(1,'Directory %s did not exist, so it was created.\n',fn);
                end;
                fn = [fn mass '.eps'];
                print_figure(fignum,fn,additional_settings.print_factors(1));
                %fprintf(1,'Figure exported as %s\n',fn);
                mepstopdf(fn,'epstopdf');
                % export also the external image data averaged over ROIS
                if opt1(10)
                    p2=p;
                    p2.mass{1}='ext_r';
                    p2.mass{2}='ext_g';
                    p2.mass{3}='ext_b';
                    p2.special{1}='ext_r';
                    p2.special{2}='ext_g';
                    p2.special{3}='ext_b';
                    %p2.im{1}=squeeze(maskmass(:,:,1));
                    %p2.im{2}=squeeze(maskmass(:,:,2));
                    %p2.im{3}=squeeze(maskmass(:,:,3));
                    p2.accu_im{1}=squeeze(maskmass(:,:,1));
                    if size(maskmass,3)>1
                        p2.accu_im{2}=squeeze(maskmass(:,:,2));
                    else
                        p2.accu_im{2}=squeeze(maskmass(:,:,1));
                    end;
                    if size(maskmass,3)>2
                        p2.accu_im{3}=squeeze(maskmass(:,:,3));
                    else
                        p2.accu_im{3}=squeeze(maskmass(:,:,1));
                    end;
                    [R2,Ra2,Raim2,o2] = calculate_R_images(p2, [1 1 1 0 0 0 0 0]);
                    % because after this step, o2{:}(:,4) contains the
                    % accumulated signal in ROIs, divide it by ROI size to
                    % make it independent of ROI size and thus comparable
                    % between different ROIs
                    if ~isempty(o2)
                        o2{1}(:,4) = o2{1}(:,4)./o2{1}(:,8);
                        o2{2}(:,4) = o2{2}(:,4)./o2{2}(:,8);
                        o2{3}(:,4) = o2{3}(:,4)./o2{3}(:,8);                    
                        export_ascii_data_for_ROIS(o2{1}, fdir, 'ext_r', '.dac', 'f');
                        export_ascii_data_for_ROIS(o2{2}, fdir, 'ext_g', '.dac', 'f');
                        export_ascii_data_for_ROIS(o2{3}, fdir, 'ext_b', '.dac', 'f');
                    else
                        fprintf(1,'*** WARNING: no ROIs defined, no values exported.\n');
                    end;
                end;
            end;
        end;

    else
        fprintf(1,'*** Error: Align and accummulate planes before proceeding.\n');
    end;

else
    
    fprintf(1,'*** Error: Nothing loaded, nothing done.\n');
    
end;
