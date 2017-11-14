function [im,pp,p]=read_accu_im_file(ff,handles)

% Read the accumulated mat data produced by LANS
% L.P. 04-11-2017
    
% default values, in case something goes wrong
im = [];
pp = [];
p = [];

% load settings in the preferences file
h = load_settings(handles,ff,0);

% find out which masses should be loaded
he(1) = handles.edit3;
he(2) = handles.edit4;
he(3) = handles.edit5;
he(4) = handles.edit6;
he(5) = handles.edit7;
he(6) = handles.edit8;
he(7) = handles.edit9;
he(8) = handles.edit74;

kk=0;
for ii=1:length(he)
    s=get(he(ii),'string');
    if ~isempty(s)
        kk=kk+1;
        mass_name{kk} = s;
    end;
end;

% load the masses, which should be in the corresponding mat files stored in
% the mat folder
[pathstr, name]=fileparts(ff);
indir = [pathstr delimiter 'mat' delimiter];
loading_successful=1;
nb_mass = length(mass_name);
for i=1:nb_mass
    infile=[indir mass_name{i} '.mat'];
    if exist(infile,'file')
        a=load(infile);
        im_tmp{i}(:,:,1) = a.IM;
        fprintf(1,'File %s loaded successfully.\n',infile);
    else
        loading_successful=0;
        fprintf(1,'ERROR: File %s could not be loaded.\n',infile);
        fprintf(1,'Please reprocess the RAW file to generate it.\n');
    end;
end;
if loading_successful 
    im=im_tmp;        
    pp=1;
else
    fprintf('ERROR: Some of the accumulated masses were not detected. Returning empty output.\n');
    im=[];
    pp=0;
end;
p.filename = [pathstr];

% put the additional parameters to the structure p
p.reverse_bytes = [];
p.pos = [0 0 0];
p.mass = mass_name;
p.mass_precise = [];
p.date = [];
p.time = [];

if isempty(im)
    fprintf(1,'No data loaded.\n');
else
    
    p.width = size(im{1},2);
    p.height = size(im{1},1);

    % calculate also dwell time, estimated from the analysis duration
    p.dwell_time = [];

    if isfield(handles,'text46')
        s = get(handles.text46,'string');
        if ~isempty(s)
            p.scale = str2num(s);
        else
            p.scale = 10;
            fprintf(1,'Warning: raster set to 10 um by default.\n');
        end;
    else
        p.scale = 10;
        fprintf(1,'Warning: raster set to 10 um by default.\n');
    end;
    
end;

% left for debugging
a=0;