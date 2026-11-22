function [FileName, newdir, newext] = uigetfile_macos(type, title, def_file, arg1, val1)

if ischar(type)
    type = {type};
end

if nargin<=3
    numfiles = 1;
else
    if strcmp(arg1,'MultiSelect')
        if strcmp(val1,'off')
            numfiles = 1;
        else
            numfiles = [];
        end
    end
end

[a,b,c] = fileparts(def_file);
setappdata(0, 'uipickfiles_default', [b,c]); % Just the filename + extension

if isfile(def_file)
    prompt = sprintf('%s (default: %s)',title, [b,c]);
end
if isfolder(def_file)
    prompt = title;
end

out = uipickfiles( ...
    'FilterSpec', [a filesep], ...
    'Type', type, ...
    'Prompt', prompt, ...
    'NumFiles', numfiles);

if isequal(out, 0)
    FileName = 0;
    newdir = 0;
    newext = 0;
else

    if isscalar(out)
        [folder, name1, ext2] = fileparts(out{1});
        [~, baseName, ext1]   = fileparts(name1);
        fullExt = [ext1 ext2];  
        FileName = [baseName fullExt];
        newdir = [folder filesep];
        newext = fullExt;
    else
        FileName = cell(length(out),1);
        for i=1:length(out)
            [folder, name1, ext2] = fileparts(out{i});
            [~, baseName, ext1]   = fileparts(name1);
            fullExt = [ext1 ext2];  
            FileName{i} = [baseName fullExt];
            newdir = [folder filesep];
            newext = fullExt;
        end
    end

end

end
