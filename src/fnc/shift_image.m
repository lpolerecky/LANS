function im=shift_image(handles,a)
xs=str2num(get(handles.edit40,'string'));
ys=-str2num(get(handles.edit41,'string'));
im = shiftimg(a,xs,ys);

Maskimg=im;
disp(['Shifted cells image saved into ',handles.p.fdir,'cells.mat']);
eval(['save ',handles.p.fdir,'cells.mat -v6 Maskimg']);