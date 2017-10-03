function set_stats_objects_visibility(handles,v)
set(handles.text1,'visible',v);
set(handles.text2,'visible',v);
set(handles.text3,'visible',v);
set(handles.text4,'visible',v);
set(handles.text5,'visible',v);
set(handles.text6,'visible',v);
set(handles.text7,'visible',v);
set(handles.edit1,'visible',v);
set(handles.edit2,'visible',v);
set(handles.pushbutton1,'visible',v);
set(handles.pushbutton2,'visible',v);
set(handles.pushbutton4,'visible',v);
set(handles.pushbutton5,'visible',v);
set(handles.pushbutton6,'visible',v);
set(handles.pushbutton7,'visible',v);
set(handles.popupmenu1,'visible',v);
set(handles.popupmenu2,'visible',v);
set(handles.popupmenu3,'visible',v);
set(handles.checkbox43,'visible',v);
set(handles.checkbox44,'visible',v);
set(handles.checkbox100,'visible',v);
for ii=1:length(handles.class_checkbox)
    s=sprintf('set(handles.checkbox%d,''visible'',''%s'');',handles.class_checkbox(ii),v);
    eval(s);
end;
for ii=1:length(handles.treatment_checkbox)
    s=sprintf('set(handles.checkbox%d,''visible'',''%s'');',handles.treatment_checkbox(ii),v);
    eval(s);
end;