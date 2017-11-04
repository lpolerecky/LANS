function d=delimiter
% return delimiter in filenames
% default
if 0
d='/';
if(ispc)
    d='\';
end;
end;

d=filesep;
