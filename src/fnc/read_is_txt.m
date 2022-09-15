function [out]=read_is_txt(fname, cnts)

global verbose
if verbose 
    fprintf('Processing file %s\n', fname);
end

fid=fopen(fname);

tline=fgetl(fid);

% read blocks of data
for i=1:length(cnts)
    
    while isempty(strfind(tline,'X'))
        tline=fgetl(fid);
    end;

    k=1;
    while ~isempty(tline) & tline~=-1
        tline=fgetl(fid);
        if ~isempty(tline) & tline~=-1
            A = sscanf(tline,'%e %e');
            out(k,[1:2]+(i-1)*2)=A;
            k=k+1;
        end;
    end;

end;

fclose(fid);