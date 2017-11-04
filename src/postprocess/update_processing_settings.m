function update_processing_settings(s,h)
set(h.edit1,'string',s.base_dir);
set(h.edit3,'string',s.metafile);
set(h.edit2,'string',s.cellfile);
set(h.edit17,'string',s.classificationfile);
set(h.edit43,'string',s.xyalignfile);
set(h.edit44,'string',s.prefsfile);

%set(h.popupmenu1,'value',s.dataextention);
set(h.checkbox15,'value',s.plot2d);
set(h.checkbox16,'value',s.plot3d);
set(h.edit18,'string',s.graphtitle);
if(isempty(s.xscale1))
    set(h.edit19,'string','[]');
else
    %set(h.edit19,'string',sprintf('[%s %s]',num2str(s.xscale1(1)),num2str(s.xscale1(2))));
    set(h.edit19,'string',s.xscale1);
end;
if(isempty(s.yscale1))
    set(h.edit20,'string','[]');
else
    %set(h.edit20,'string',sprintf('[%s %s]',num2str(s.yscale1(1)),num2str(s.yscale1(2))));
    set(h.edit20,'string',s.yscale1);
end;
if(isempty(s.xscale2))
    set(h.edit21,'string','[]');
else
    %set(h.edit21,'string',sprintf('[%s %s]',num2str(s.xscale2(1)),num2str(s.xscale2(2))));
    set(h.edit21,'string',s.xscale2);
end;
if(isempty(s.yscale2))
    set(h.edit23,'string','[]');
else
    %set(h.edit23,'string',sprintf('[%s %s]',num2str(s.yscale2(1)),num2str(s.yscale2(2))));
    set(h.edit23,'string',s.yscale2);
end;
if(isempty(s.xscale3))
    set(h.edit24,'string','[]');
else
    %set(h.edit24,'string',sprintf('[%s %s]',num2str(s.xscale3(1)),num2str(s.xscale3(2))));
    set(h.edit24,'string',s.xscale3);
end;
if(isempty(s.yscale3))
    set(h.edit25,'string','[]');
else
    %set(h.edit25,'string',sprintf('[%s %s]',num2str(s.yscale3(1)),num2str(s.yscale3(2))));
    set(h.edit25,'string',s.yscale3);
end;
set(h.edit13,'string',s.cellclasses);
set(h.edit14,'string',s.cellcolors);
set(h.edit15,'string',s.treatments);
set(h.edit16,'string',s.symbols);
set(h.checkbox7,'value',s.logscale.x1);
set(h.checkbox8,'value',s.logscale.y1);
set(h.checkbox9,'value',s.logscale.x2);
set(h.checkbox10,'value',s.logscale.y2);
set(h.checkbox11,'value',s.logscale.x3);
set(h.checkbox12,'value',s.logscale.y3);
if(isfield(s,'disp_errorbars'))
    set(h.checkbox13,'value',s.disp_errorbars);
else
    set(h.checkbox13,'value',1);
end;
if(isfield(s,'log_scale'))
    set(h.checkbox30,'value',s.log_scale);
else
    set(h.checkbox30,'value',0);
end;
if(isfield(s,'bw'))
    set(h.checkbox31,'value',s.bw);
else
    set(h.checkbox31,'value',0);
end;