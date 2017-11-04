function h=add_polygon(s, pos)
if nargin>1
    position=pos;
else
    position=[];
end;

%fprintf(1,'Define ROI as POLYGON. DOUBLE-CLICK to finalize ROI definition.\n');
if ~isempty(position)
    h = impoly(s,position);
else
    h = impoly(s);
end;
setColor(h,'white');
addNewPositionCallback(h,@(p) title(mat2str([min(p) max(p)],3)));
fcn = makeConstrainToRectFcn('impoly',get(s,'XLim'),get(s,'YLim'));
setPositionConstraintFcn(h,fcn);
wait(h);
%resume(h);
%fprintf(1,'ROI position confirmed.\n');