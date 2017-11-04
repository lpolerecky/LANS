function [cidu,cc,cid,cnum,ss]=load_cell_classes(fncells)

if(exist(fncells)==2)
    % load the cell types from the file
    disp(['Loading ROI classes from ',fncells]);
    fid=fopen(fncells,'r');
    A = fscanf(fid,'%d %c',[2,inf]);
    fclose(fid);
    if size(A,2)>0
        cnum=A(1,:)';
        cid=char(A(2,:)');
    else
        cnum=[];
        cid=[];
        cidu=[];
    end;
    % find unique cell classes
    cidu=unique(cid);
else
    cidu=[]; cid=[]; cnum=[];
end;
cc=['rgbmckrgbmckrgbmckrgbmckrgbmckrgbmck'];
ss=['oooooossssssvvvvvv^^^^^^>>>>>><<<<<<'];