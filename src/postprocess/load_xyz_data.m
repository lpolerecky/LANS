function [rat,cellid,area,pixels,xpos,ypos,l2w]=load_xyz_data(fn,fncells,q,ct)
% if q equals 'size', 'x' or 'y', then load the data from the dat\cells.dat
% file, which must definitely exist even if none of the ratios were
% exported, because at least cell outlines should always be
% exported; otherwise load the data from the fn file

verbose=1;
if(strcmp(lower(q),'size') | strcmp(lower(q),'x') | strcmp(lower(q),'y') | ...
        strcmp(lower(q),'l2w') | strcmp(lower(q),'lw') | strcmp(lower(q),'lwratio'))
    [pathstr, name, ext] = fileparts(fn);
    fn = [pathstr delimiter 'cells', ext];
    if ~exist(fn)
        fprintf(1,'ERROR: File %s must exist to extract %s.\n',fn,q);
        fprintf(1,'Create it through ROIs -> Export ROIs image for each processed dataset.\n');
    end;
    verbose=1;
end;

[rat,cellid,area,pixels,xpos,ypos,l2w]=getratiodata(ct,fn,fncells,q,verbose);

if(strcmp(lower(q),'size'))
    rat = area;
end;

if(strcmp(lower(q),'x'))
    rat = xpos;
end;

if(strcmp(lower(q),'y'))
    rat = ypos;
end;

if(strcmp(lower(q),'l2w') | strcmp(lower(q),'lw') | strcmp(lower(q),'lwratio'))
    rat = l2w;
end;
