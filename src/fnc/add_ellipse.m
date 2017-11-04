function h=add_ellipse(s, pos)
if nargin>1
    position=pos;
else
    position=[];
end;

fprintf(1,'Add ROI as ELLIPSE. DOUBLE-CLICK to finalize ROI definition.\n');
if ~isempty(position)
    h = imellipse(s,position);
else
    h = imellipse(s);
end;
addNewPositionCallback(h,@(p) title(mat2str([min(p) max(p)],3)));
fcn = makeConstrainToRectFcn('imellipse',get(s,'XLim'),get(s,'YLim'));
setPositionConstraintFcn(h,fcn);
wait(h);
%resume(h);
%fprintf(1,'ROI position confirmed.\n');