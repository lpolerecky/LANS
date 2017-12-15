function handles = fillinfo_selected_images(images, handles)
for ii=1:length(handles.p.images)
    handles.p.images{ii}=images;
end;
set(handles.edit12,'string',['[',num2str(images),']']);
