function [imfile dname] = choose_im_file(handles, multiple)
% return cells of strings with the cameca image filename (imfile) and the
% corresponding output directory (dname)
% return empty if the filename or pathname contains forbidden characters

% default output values
imfile = [];
dname = [];

% find the last working directory
workdir=get(handles.edit1,'String');
if(isdir(workdir))
    newdir=workdir;
else
    newdir='';
end;
workdir=fixdir(workdir);

global IM_FILE_EXT;
file_types = {'*.im', 'Cameca IM file (*.im)'; ...
        '*.im.zip','Compressed Cameca IM file (*.im.zip)'; ...
        '*.mat','LANS-processed data (*.mat)'};
if contains(IM_FILE_EXT,'zip')
    ft = cell(2,2);
    ft{1,1} = file_types{2,1};
    ft{1,2} = file_types{2,2};
    ft{2,1} = file_types{1,1};
    ft{2,2} = file_types{1,2};    
else
    ft = file_types;
end

% select file(s)

if multiple==0
    [FileName,newdir,newext] = uigetfile(ft, ...
        'Select *.IM or *.IM.zip file', workdir, ...
        'MultiSelect', 'off');
elseif multiple==1
    [FileName,newdir,newext] = uigetfile(ft, ...
        'Select *.IM or *.IM.zip file (+Ctrl for multiple)', workdir, ...
        'MultiSelect', 'on');
elseif multiple==2 % this is used when loading the accumulated data, without the need to have the original im data 
    [FileName,newdir,newext] = uigetfile({'*.mat', 'LANS preferences file (*.mat)'}, ...
        'Select LANS preferences file', workdir, ...
        'MultiSelect', 'off');
    [newdir fname]=fileparts(newdir(1:end-1));
    [newdir]= [newdir filesep];
    FileName = [fname filesep FileName];
elseif multiple==3 % this is used when loading the complete processed dataset, i.e., all planes
    [FileName,newdir,newext] = uigetfile({'*.mat', 'LANS processed file (*.mat)'}, ...
        'Select LANS-generated data file', workdir, ...
        'MultiSelect', 'off');    
end

% parse the selected filenames
if ~iscell(FileName) 
    
    if FileName~=0
        
        if contains(FileName,'zip')
            newext = 2;
        elseif contains(FileName,'mat')
            newext = 3;
        else
            newext = 1;
        end
        
        set(handles.edit1,'String',newdir);
        set(handles.text2,'String',newext); 
        fn = approve_imfile([newdir FileName]);

        if ~isempty(fn) 
           imfile{1} = fn;
           if multiple~=2
               dname{1} = get_outdirectory(fn,newext);
           else
               dname{1} = newdir;
           end
        end
        
    end
        
else
    
    set(handles.edit1,'String',newdir);
    bad_flag = 0;
    for ii=1:length(FileName)
        
        if contains(FileName{ii},'zip')
            newext = 2;
        elseif contains(FileName,'mat')
            newext = 3;
        else
            newext = 1;
        end
        set(handles.text2,'String',newext);    
    
        tmp1{ii} = approve_imfile([newdir FileName{ii}]);
        tmp2{ii} = get_outdirectory(tmp1{ii},newext);
    
        if isempty(tmp1{ii})
            bad_flag = 1;
        end
        
    end
    
    if ~bad_flag
        imfile = tmp1;
        dname = tmp2;
    end
    
end
if newext==2
    IM_FILE_EXT = '.im.zip';
elseif newext==3
    IM_FILE_EXT = '.mat';
else
    IM_FILE_EXT = '.im';
end

function fout = approve_imfile(imfile)
%forbidden_chars = ' *"^][()#%&,;''';
forbidden_chars = '*"^][()#%&,;''';
flag = sum( ismember(imfile,forbidden_chars) );

if flag>0
    fprintf(1,'ERROR: file or path name contains one or more FORBIDDEN characters: SPACE%s\n', forbidden_chars);
    fprintf(1,'You must remove these from the FILE or PATH name to proceed.\n');
    fout=[];
else
    fout=imfile;
end;

function dout = get_outdirectory(imfile, newext)
if isempty(imfile)
    dout=[];
else
    % remove .zip if present
    if newext==2
       ind = findstr(imfile,'.zip');
       ind = max(ind);
       imfile = imfile(1:ind-1);
    end;
    % determine output directory
    [pathstr, name, ext] = fileparts(imfile);
    dout = [pathstr delimiter name];   
end;