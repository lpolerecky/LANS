function h=add_impoint(s)
fprintf(1,'Add POINT. DOUBLE-CLICK to finalize POINT definition.\n');
h = impoint(s);
addNewPositionCallback(h,@(p) title(mat2str([min(p) max(p)],3)));
fcn = makeConstrainToRectFcn('impoint',get(s,'XLim'),get(s,'YLim'));
setPositionConstraintFcn(h,fcn);
wait(h);
%resume(h);
%fprintf(1,'ROI position confirmed.\n');