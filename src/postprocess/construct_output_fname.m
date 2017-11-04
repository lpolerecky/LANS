function a = construct_output_fname(metafile,r,compare,b,c,ext)
% construct the output file name
[pathstr name] = fileparts(metafile);
a = [pathstr delimiter name];
if ~isdir(a)
    mkdir(a);
    fprintf(1,'Directory %s did not exist, so it was created.\n',a);
end;
a = [a delimiter b];
if ~isdir(a)
    mkdir(a);
    fprintf(1,'Directory %s did not exist, so it was created.\n',a);
end;
rs=convert_string_for_texoutput(r);
a = [a delimiter rs '-' c '-' compare ext];