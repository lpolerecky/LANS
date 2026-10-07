function [imfile, dname] = choose_im_file(handles, multiple)
% return cells of strings with the cameca image filename (imfile) and the
% corresponding output directory (dname)
% return empty if the filename or pathname contains forbidden characters
%
% updates:
% LP, 05-10-2026: loading of IMP files possible

% default output values
imfile = [];
dname = [];

% find the last working directory
workdir=get(handles.edit1,'String');
if isfolder(workdir)
    newdir=workdir;
else
    newdir='';
end
workdir=fixdir(workdir);

file_types = {'*.im', 'Cameca 50L IM file (*.im)'; ...
        '*.im.zip','Compressed Cameca 50L IM file (*.im.zip)'; ...
        '*.imp','Cameca IMS 1280 file (*.imp)'; ...
        '*.mat','LANS-processed data (*.mat)'}; 

% select file(s)
if ismac

    % because of the bug in Matlab2024 on MacOS, selection of the file
    % extension does not work; thus, the following (see code after "else")
    % handy feature will not be supported on MacOS
    if ismember(multiple, [0, 2, 3])
        onoff = 'off';
        str1 = 'Select input file (*.im, *.im.zip, *.imp, *.mat)';
        ft = '*.im;*.im.zip;*.imp;*.mat';
    else
        onoff = 'on';
        str1 = 'Select multiple input files (*.im, *.im.zip, *.imp) (CMD + select)';
        ft = '*.im;*.im.zip;*.imp';
    end
    fprintf(1,'%s\n', str1);
    [FileName,newdir,newext] = uigetfile(ft, ...
        str1, workdir, 'MultiSelect', onoff);

else

    % adjust the list of extensions such that the last selected one (stored
    % in IM_FILE_EXT) will be on top, unless the default *.im is selected
    ft = file_types;
    global IM_FILE_EXT;
    switch IM_FILE_EXT 
        case '.im.zip'
            ft([1,2],:) = ft([2,1],:);
        case '.imp'
            ft([1,3],:) = ft([3,1],:);
        case '.mat'
            ft([1,4],:) = ft([4,1],:);
    end

    if multiple==0
        str1 = 'Select *.IM, *.IM.zip or *.IMP file';
        fprintf(1,'%s\n', str1);
        [FileName,newdir,newext] = uigetfile(ft, ...
            str1, workdir, ...
            'MultiSelect', 'off');
    elseif multiple==1
        str1 = 'Select *.IM or *.IM.zip file (+Ctrl for multiple)';
        fprintf(1,'%s\n', str1);
        [FileName,newdir,newext] = uigetfile(ft, ...
            str1, workdir, ...
            'MultiSelect', 'on');
    elseif multiple==2 % this is used when loading the accumulated data, without the need to have the original im data 
        str1 = 'Select LANS preferences file';
        fprintf(1,'%s\n', str1);
        [FileName,newdir,newext] = uigetfile({'*.mat', 'LANS preferences file (*.mat)'}, ...
            str1, workdir, ...
            'MultiSelect', 'off');
        [newdir, fname] = fileparts(newdir(1:end-1));
        newdir = [newdir filesep];
        FileName = [fname filesep FileName];
    elseif multiple==3 % this is used when loading the complete processed dataset, i.e., all planes
        str1 = 'Select LANS-generated data file';
        fprintf(1,'%s\n', str1);
        [FileName,newdir,newext] = uigetfile({'*.mat', 'LANS processed file (*.mat)'}, ...
            str1, workdir, ...
            'MultiSelect', 'off');    
    end

end

% parse the selected filenames
if ~iscell(FileName) 
    
    if FileName~=0
        
        if contains(FileName,'zip')
            newext = 2;
        elseif contains(FileName,'mat')
            newext = 3;
        elseif contains(FileName,'imp')
            newext = 4;
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
    lFN = length(FileName);
    tmp1 = cell(lFN,1);
    tmp2 = cell(lFN,2);
    for ii=1:lFN
        
        if contains(FileName{ii},'zip')
            newext = 2;
        elseif contains(FileName,'imp')
            newext = 3;
        elseif contains(FileName,'mat')
            newext = 4;
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

switch newext
    case 2, IM_FILE_EXT = '.im.zip';
    case 3, IM_FILE_EXT = '.mat';
    case 4, IM_FILE_EXT = '.imp';
    otherwise, IM_FILE_EXT = '.im';
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
end

function dout = get_outdirectory(imfile, newext)
if isempty(imfile)
    dout=[];
else
    % remove .zip if present
    if newext==2
       ind = strfind(imfile,'.zip');
       ind = max(ind);
       imfile = imfile(1:ind-1);
    end
    % determine output directory
    [pathstr, name, ~] = fileparts(imfile);
    dout = [pathstr delimiter name];   
end