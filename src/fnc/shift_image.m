function im=shift_image(handles,a)
xs=str2num(get(handles.edit40,'string'));
ys=-str2num(get(handles.edit41,'string'));
im = shiftimg(a,xs,ys);

global CELLSFILE

Maskimg=im;
disp(['Shifted ROIs saved into ',handles.p.fdir, CELLSFILE '.mat']);
eval(['save ',handles.p.fdir,CELLSFILE '.mat -v6 Maskimg']);