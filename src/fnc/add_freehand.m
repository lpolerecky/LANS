function h=add_freehand(s,openclose)
if(openclose)
    fprintf(1,'Add ROI as FREEHAND drawing. DOUBLE-CLICK to finalize ROI definition.\n');
else
    fprintf(1,'Add LINE as FREEHAND drawing. DOUBLE-CLICK to finalize LINE definition.\n');
end;
h = imfreehand(s,'closed',openclose);
addNewPositionCallback(h,@(p) title(mat2str([min(p) max(p)],3)));
fcn = makeConstrainToRectFcn('imfreehand',get(s,'XLim'),get(s,'YLim'));
setPositionConstraintFcn(h,fcn);

wait(h);

%resume(h);
%fprintf(1,'ROI position confirmed.\n');