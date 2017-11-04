function handles = fillinfo_selected_images(images, handles)
for ii=1:length(handles.p.images)
    handles.p.images{ii}=images;
    if(ii==1)
       set(handles.edit12,'string',['[',num2str(images),']']);
    end;
    if(ii==2)
       set(handles.edit13,'string',['[',num2str(images),']']);
    end;
    if(ii==3)
       set(handles.edit14,'string',['[',num2str(images),']']);
    end;
    if(ii==4)
       set(handles.edit15,'string',['[',num2str(images),']']);
    end;
    if(ii==5)
       set(handles.edit16,'string',['[',num2str(images),']']);
    end;
    if(ii==6)
       set(handles.edit17,'string',['[',num2str(images),']']);
    end;
    if(ii==7)
       set(handles.edit18,'string',['[',num2str(images),']']);
    end;
    if(ii==8)
       set(handles.edit75,'string',['[',num2str(images),']']);
    end;
end;