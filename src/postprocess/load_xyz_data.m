function [rat,cellid,area,pixels,xpos,ypos,l2w,cls]=load_xyz_data(fn,fncells,q,ct)
% if q equals 'size', 'x' or 'y', then load the data from the dat\cells.dat
% file, which must definitely exist even if none of the ratios were
% exported, because at least cell outlines should always be
% exported; otherwise load the data from the fn file

global verbose

if strcmpi(q,'size') || strcmpi(q,'pixel') || strcmpi(q,'x') || ...
        strcmpi(q,'y') || strcmpi(q,'l2w') || strcmpi(q,'lw') || strcmpi(q,'lwratio')
    [pathstr, ~, ext] = fileparts(fn);
    fn = [pathstr delimiter 'ROIs', ext];
    if ~exist(fn)
        fprintf(1,'ERROR: File %s must exist to extract %s.\n',fn,q);
        fprintf(1,'Create it through ROIs -> Export ROIs image for each processed dataset.\n');
    end
end

[rat,cellid,area,pixels,xpos,ypos,l2w,cls]=getratiodata(ct,fn,fncells,q,verbose);

if strcmpi(q,'size')
    rat = area;
end

if strcmpi(q,'pixel')
    rat = pixels;
end

if strcmpi(q,'x')
    rat = xpos;
end

if strcmpi(q,'y')
    rat = ypos;
end

if strcmpi(q,'l2w') || strcmpi(q,'lw') || strcmpi(q,'lwratio')
    rat = l2w;
end
