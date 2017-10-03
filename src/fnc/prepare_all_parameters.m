function p = prepare_all_parameters(handles)

if(isfield(handles,'p'))
    p=handles.p;
    if strcmp(p.fdir(end),delimiter)
        p.filename = p.fdir(1:end-1);
    else
        p.filename = p.fdir;
    end;
else
    p=[];
end;

if ~isempty(p)
    
    % reload the raw data file if p.im is missing or size(p.im{1},3)==1
    a = 0;
    if ~isfield(p,'im')
        a = 1;
    else
        if size(p.im{1},3)==1
            a = 1;
        end;
    end;
    if a
        nmass=0;
        for ii=1:length(p.mass)
            if ~isempty(p.mass{ii})
                nmass = nmass+1;
            end;
        end;
        p.im=read_cameca_image([p.filename,'.im'],nmass,[],p.width,p.height,[1:nmass],0);
        p.noplanes = size(p.im{1},3);
    end;
    
    % load alignment from 'xyalign.mat'
    afile = [p.fdir 'xyalign.mat'];
    if ~exist(afile,'file')
        [FileName,newdir,newext] = uigetfile('*.mat', 'Select XY-ALIGNMENT (*.MAT) file', p_im.fdir);
        if(FileName~=0)
            afile = [newdir, FileName];
            fprintf(1,'Alignment information loaded from %s\n',afile);
            load(afile);
            p.xyalign = xyalign;
        else
            p.xyalign = [];
        end;
    else
        fprintf(1,'Alignment information loaded from %s\n',afile);
        load(afile);
        p.xyalign = xyalign;
    end;
    
    % load ROI definition
    roifile = [p.fdir 'cells.mat'];
    if ~exist(roifile,'file')
        [FileName,newdir,newext] = uigetfile('*.mat', 'Select ROI DEFINITION (*.MAT) file', p.fdir);
        if(FileName~=0)
            roifile = [newdir, FileName];
            fprintf(1,'ROI definition loaded from %s\n',roifile);
            load(roifile);
            p.Maskimg = Maskimg;
        else
            p.Maskimg = ones(size(p.im{1},1),size(p.im{1},2));
        end;
    else
        fprintf(1,'ROI definition loaded from %s\n',roifile);
        load(roifile);
        p.Maskimg = Maskimg;
    end;
    
end;    
    
%     [im,imfile]=choose_chk_im_file(handles);
%     if(isempty(im))
%         cancel_pressed=1;
%         p_im=[];
%     else
%         cancel_pressed=0;
%         h=fillinfo_detected_masses(im, imfile, handles);
%         p_im = load_masses_parameters(h);
%         p_im.filename = imfile;
%     end;
% else
%     cancel_pressed=0;
%     p_im = p;
%     h = [];
% end;

% always load preferences file ('prefs.mat') if it exists
% this is mostly used for images and scales. 
% if ~cancel_pressed
%     pfile = [p_im.fdir 'prefs.mat'];
%     if ~exist(pfile,'file')
%        [FileName,newdir,newext] = uigetfile('*.mat', 'Select PREFERENCES (*.MAT) file', p.fdir);
%        if(FileName~=0)
%            imfile = [newdir, FileName];        
%        else
%            cancel_pressed = 1;
%        end;
%     end;
%     if ~cancel_pressed        
%         if isfield(h,'im_chk')
%             im_chk = h.im_chk;
%         else
%             im_chk = [];
%         end;
%         h = load_settings(handles,pfile,0);
%         set(h.checkbox58,'value',opt1(10));
%         set(h.checkbox59,'value',opt1(11));
%         if ~isfield(h,'im_chk')
%             h.im_chk = im_chk;
%         end;
%         p_im = load_masses_parameters(h);
%     else 
%         p_im = p;
%     end;
% else
%     p_im = p;
% end;
% 
% % load alignment file ('xyalign.mat')
% if (a & ~cancel_pressed) | ~isfield(p,'xyalign')
%     afile = [p_im.fdir 'xyalign.mat'];
%     if ~exist(afile,'file')
%         [FileName,newdir,newext] = uigetfile('*.mat', 'Select XY-ALIGNMENT (*.MAT) file', p_im.fdir);
%         if(FileName~=0)
%             afile = [newdir, FileName];
%         else
%             cancel_pressed = 1;
%         end;
%     end;
%     if ~cancel_pressed
%         fprintf(1,'Alignment information loaded from %s\n',afile); 
%         load(afile);
%         p_im.xyalign = xyalign;
%     end;
% end;
% 
% % load ROI definition file ('cells.mat')
% if (a & ~cancel_pressed) | ~isfield(p,'Maskimg')
%     roifile = [p_im.fdir 'cells.mat'];
%     if ~exist(roifile,'file')
%         [FileName,newdir,newext] = uigetfile('*.mat', 'Select ROI DEFINITION (*.MAT) file', p.fdir);
%         if(FileName~=0)
%             roifile = [newdir, FileName];
%         else
%             cancel_pressed = 1;
%         end;
%     end;
%     if ~cancel_pressed
%         fprintf(1,'ROI definition loaded from %s\n',roifile);
%         load(roifile);
%         p_im.Maskimg = Maskimg;
%     end;
% end;
% 
% % p is empty if the first action the user did in the program was going
% % straight into the 'Depth profiles' functions
% if isempty(p)
%     p=p_im;
% end;
% 
% % update IM properties
% if ~cancel_pressed
%     for ii=1:length(p_im.images)
%         if ~isempty(setdiff(p_im.images{ii},p.images{ii}))
%             p.images{ii} = p_im.images{ii};
%         end;
%     end;
%     p.pos = assign_if_different(p_im, p, 'pos');
%     p.date = assign_if_different(p_im, p, 'date');
%     p.time = assign_if_different(p_im, p, 'time');
%     p.width = assign_if_different(p_im, p, 'width');
%     p.height = assign_if_different(p_im, p, 'height');
%     p.scale = assign_if_different(p_im, p, 'scale');
%     p.filename = assign_if_different(p_im, p, 'filename');
% end;
% 
% pause(0.1); % to refresh the window
% 
% % read raw image data
% if ~cancel_pressed
%     nmass=0;
%     for ii=1:length(p.mass)
%         if ~isempty(p.mass{ii})
%             nmass = nmass+1;
%         end;
%     end;    
%     if ~isfield(p,'im')
%         p.im=read_cameca_image([p.filename,'.im'],nmass,[],p.width,p.height,[1:nmass],0);
%         p.noplanes = length(p.images{1});
%     else
%         if size(p.im{1},3)==1
%             p.im=read_cameca_image([p.filename,'.im'],nmass,[],p.width,p.height,[1:nmass],0);
%             p.noplanes = length(p.images{1});
%         end;
%     end;
%     % p.im now contains the raw images, either loaded freshly, or passed
%     % from the input
% end;
