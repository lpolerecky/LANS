function [dir_name, imfile, name]=choose_processed_im_file(handles)
workdir=get(handles.edit1,'String');
if(isdir(workdir))
    newdir=workdir;
else
    newdir='';
end;
workdir=fixdir(workdir);

dir_name = uigetdir(workdir,'Select DIRECTORY with processed data');

imfile=[]; name=[];

if(dir_name~=0)
    set(handles.edit1,'String',newdir);
    [pathstr, name, ext] = fileparts(dir_name);
    imfile = [pathstr delimiter name];
end;