function [h, position]=add_line(s)
fprintf(1,'Add LINE using the mouse. DOUBLE-CLICK on the LINE to finalize its definition.\n');
h = imline(s);
addNewPositionCallback(h,@(p) title(mat2str([min(p) max(p)],3)));
fcn = makeConstrainToRectFcn('imline',get(s,'XLim'),get(s,'YLim'));
setPositionConstraintFcn(h,fcn);
position=wait(h);
%resume(h);
%fprintf(1,'ROI position confirmed.\n');