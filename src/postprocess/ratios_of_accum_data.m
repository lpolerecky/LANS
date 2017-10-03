function ratios_of_accum_data
% Function for calculating mass ratios from total number of counts
% _accumulated _ over all planes in regions of interest defined 
% for a particular data-set. ROI's were defined using the GUI program, and
% should be stored in the cells.mat file. The data output will be stored in
% *.dac files (ac refers to the fact that it originates from accumulated
% counts) in the same directory as the *.dat files. 
% This is a post-processing utility, so can be applied on many data-sets at
% once. The data-sets on which it should be applied are specified in the
% same metafile as those for, e.g., PDF generation.
% (c) Lubos Polerecky, 04.11.2009, MPI Bremen


% load settings from the ini file
load nanosimsini.mat

% get default base_dir
base_dir = h.edit1.string;

% ask for the base directory with all the processed files
disp('Select base directory with all the raw and processed data');
dname = uigetdir(base_dir,'Select base directory with all raw and processed data');
if(dname~=0)
    base_dir=dname;
end;
base_dir=fixdir(base_dir);

% specify the meta-file with the meta-instructions
disp('Select file with the meta-instructions');
[FileName,newdir,newext] = uigetfile({'*.txt';'*.meta';'*.dat'}, 'Select metafile', base_dir);
if(FileName~=0)
    metafname = [newdir, FileName];
else
    % default
    metafname = [base_dir,delimiter,'summary9.txt'];
end;

% get instructions from the meta file
[id,fname,tmnt,ct,xs,ys,zs,nf,all]=getmetainstructions(metafname);

% default mat file containing the CELLS (ROI's) definition
cells_file='cells.mat';
% default mat file containing the preferences
prefs_file='prefs.mat';
% default mat file containing the alignments
align_file='xyalign.mat';

j=1;
% ask the user which file will be used for ROI's definition
while 1
    disp('Select file with ROI (cells) definitions');
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select file with ROI definitions',...
        [base_dir, fname{j},delimiter]);
    if(FileName~=0)
        cells_file = FileName;
    end;
    c=load([newdir,cells_file]);
    if(isfield(c,'Maskimg'))
        break;
    else
        disp(['File ',cells_file,' doesn''t seem to contain ROI definition. Please select another one.']);
    end;
end;

% ask the user which file will be used for preferences definition
while 1
    disp('Select file with the remaining preferences');
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select preferences file',...
        [base_dir, fname{j},delimiter]);
    if(FileName~=0)
        prefs_file = FileName;
    end;
    c=load([newdir,prefs_file]);
    if(isfield(c,'h'))
        break;
    else
        disp(['File ',prefs_file,' doesn''t seem to contain preferences. Please select another one.']);
    end;
end;

% ask the user which file will be used for alignments definition
while 1
    disp('Select file with the xy-alignment information')
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select xy-alignment file',...
        [base_dir, fname{j},delimiter]);
    if(FileName~=0)
        align_file = FileName;
    else
        align_file = 'xyalign.mat';
    end;
    if(~isempty(align_file))
        c=load([newdir,align_file]);
        if(isfield(c,'xyalign'))
            break;
        else
            disp(['File ',align_file,' doesn''t seem to contain xy-alignment. Please select another one.']);
        end;
    else
        break;
    end;
end;

% calculate for all image-sets in the metafile
for j=1:nf
    
    % load ROIs
    fncells = [base_dir, fname{j}, delimiter, cells_file];
    if(exist(fncells)==2)
        c=load(fncells);
    else
        disp(['ERROR: file ',fncells,' not found']);
    end;
    
    % load preferences
    fnprefs = [base_dir, fname{j}, delimiter, prefs_file];
    if(exist(fnprefs)==2)
        a=load(fnprefs);
        prefs=load_masses_parameters(a.h);
    else
        disp(['ERROR: file ',fnprefs,' not found']);
    end;
    
    % load alignment data
    if(prefs.find_alignments)
        fnalign = [base_dir, fname{j}, delimiter, align_file];
        load(fnalign);
    else
        xyalign=[];
    end;
    
    % load the image-set chk-file
    fn=[base_dir,fname{j},'.chk_im'];
    if(exist(fn)==2)
        p = readimchk(fn);
    else
        disp(['ERROR: file ',fn,' not found']);
    end;
    
    % load the actual data
    fn=[base_dir,fname{j},'.im'];
    if(exist(fn))
        p.im=read_cameca_image(fn,length(p.mass),[],p.width,p.height);
    else
        disp(['ERROR: file ',fn,' not found']);
    end;
    
    % accumulate images
    accu_images=accumulate_images(p.im,xyalign,prefs.find_alignments,prefs.mass,prefs.images);
    
    % fill some handles so that display_all_masses(h) can be called
    for ii=1:length(all{j})
        h.p=prefs;
        h.p.fdir=[base_dir, fname{j}, delimiter];
        h.p.special{1}=all{j}{ii};
        h.p.special{2}='';
        h.p.special{3}='';
        h.p.special{4}='';
        h.p.special{5}='';
        h.p.special{6}='';
        h.p.special{7}='';
        h.p.im=accu_images;
        h.p.Maskimg=c.Maskimg;
        if(ii==1)
            % display all accu masses
            display_all_masses(h);
            % display detected cells
            display_detected_cells(h,0);
        end;
        disp(['Calculating ',h.p.special{1}]);
        % display special images, which will export the data as a dac file
        % (because of the flag 1 at the end)
        display_ratios_through_mask(h,0,1);
    end;
end;
