function handles=load_cameca_image(handles,load_accumulated)

if nargin<2
   load_accumulated = 0;
end

[imfile, dname] = choose_im_file(handles, load_accumulated);

if isempty(imfile)
    p = [];
else
            
    if load_accumulated == 3
        
        % feature added on 2020-05-04:
        
        % read the processed data exported in a mat file
        fprintf(1,'Loading %s ... ', imfile{1});
        load(imfile{1});
        fprintf(1,'done\n');
        
    else
        
        ask_for_planes = strcmp(get(handles.ask_for_range,'checked'),'on');
    
        % create the directory where all the output will be stored
        if ~exist(dname{1},'dir')
            mkdir(dname{1});
        end
    
        % read the raw data
        p = read_cameca_image(imfile{1}, ask_for_planes, load_accumulated, handles);        

        if ~load_accumulated
            % apply dead-time correction
            p.im = apply_dtc(p.im, handles.dtc, p.dwell_time);
        end

        % the ESI image can sometimes have signal spikes in some
        % pixels, which makes the accumulated ESI image look ugly.
        % here we remove these spikes.
        global additional_settings;
        if prod(additional_settings.smooth_esi_kernelsize)>1
            kesi = identifyMass(p.mass,'Esi');
            if ~isempty(kesi)
                for kk=1:size(p.im{kesi},3)
                    if kk==1
                        fprintf(1,'WARNING: Signal spikes removed from %s data (medfilt2 kernel size [%d %d]).\n',...
                            p.mass{kesi}, additional_settings.smooth_esi_kernelsize);
                        fprintf(1,'         (see Preferences -> Additional output options -> Smooth Esi image during import)\n')
                    end
                    tmp = double(squeeze(p.im{kesi}(:,:,kk)));
                    tmp2 = medfilt2(tmp, additional_settings.smooth_esi_kernelsize);
                    p.im{kesi}(:,:,kk) = tmp2;
                end
            end
        end

        % set as not aligned
        p.planes_aligned = 0;
    
        % if only one plane was read, then set aligned to 1 and fill the
        % p.accu_im variable
        if ~isempty(p.im)
            if size(p.im{1},3)==1
                p.planes_aligned=1;            
                for ii=1:length(p.im)
                    p.accu_im{ii}=double(p.im{ii});
                end
            end
        end
        
    end
    
    if load_accumulated == 3
        p.filename = dname{1};
        p.fdir = [dname{1} filesep];
    end
    
    % fill GUI objects based on what was read
    fillinfo_detected_masses(handles, p, dname);        
        
    % fix issue for 1 plane
    if ~isempty(p.im)
	if size(p.im{1}) == 1
		set(handles.edit12,'String','[1]');
	end
    end

    % fill additional paramters from the GUI, such as scaling
    if load_accumulated ~= 3
        handles.p = p;
        p = load_masses_parameters(handles);       
    end
    
end

% remember everything
handles.p = p;
