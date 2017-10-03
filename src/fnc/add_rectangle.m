function h=add_rectangle(s)
fprintf(1,'Add ROI as RECTANGLE. DOUBLE-CLICK to finalize ROI definition.\n');
h = imrect(s);
addNewPositionCallback(h,@(p) title(mat2str([min(p) max(p)],3)));
fcn = makeConstrainToRectFcn('imrect',get(s,'XLim'),get(s,'YLim'));
setPositionConstraintFcn(h,fcn);
wait(h);
%resume(h);
%fprintf(1,'ROI position confirmed.\n');