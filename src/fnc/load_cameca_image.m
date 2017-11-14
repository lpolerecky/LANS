function handles=load_cameca_image(handles,load_accumulated)

if nargin<2
   load_accumulated = 0;
end;

[imfile dname] = choose_im_file(handles, load_accumulated);

if isempty(imfile)
    p = [];
else
    
    ask_for_planes = strcmp(get(handles.ask_for_range,'checked'),'on');
    
    % create the directory where all the output will be stored
    if ~exist(dname{1},'dir')
        mkdir(dname{1});
    end;
    
    % read the raw data
    p = read_cameca_image(imfile{1}, ask_for_planes, load_accumulated, handles);        
        
    if ~load_accumulated
        % apply dead-time correction
        p.im = apply_dtc(p.im, handles.dtc, p.dwell_time);
    end;
        
    % set as not aligned
    p.planes_aligned = 0;
    
    % if only one plane was read, then set aligned to 1 and fill the
    % p.accu_im variable
    if ~isempty(p.im)
        if size(p.im{1},3)==1
            p.planes_aligned=1;            
            for ii=1:length(p.im)
                p.accu_im{ii}=double(p.im{ii});
            end;
        end;
    end;
    
    % fill GUI objects based on what was read
    fillinfo_detected_masses(handles, p, dname);
    
    % fill additional paramters from the GUI, such as scaling
    handles.p = p;
    p = load_masses_parameters(handles);       
    
end;

% remember everything
handles.p = p;
