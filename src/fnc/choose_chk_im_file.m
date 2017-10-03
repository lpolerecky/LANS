function imfile=choose_chk_im_file(handles)

workdir=get(handles.edit1,'String');
if(isdir(workdir))
    newdir=workdir;
else
    newdir='';
end;
workdir=fixdir(workdir);

[FileName,newdir,newext] = uigetfile('*.chk_im', 'Select *.CHK_IM file', workdir);

if(FileName~=0)
    set(handles.edit1,'String',newdir);
    set(handles.text2,'String',newext);
    imfile = [newdir FileName];
    [pathstr, name, ext] = fileparts(imfile);
    imfile = [pathstr delimiter name];   
else
    imfile=[];
end;