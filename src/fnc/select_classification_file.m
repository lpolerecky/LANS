function cellfile = select_classification_file(p)
% make a pause, otherwise matlab crashes on some computers
% particularly on my TravelMate-3020 - linux-mint-box, matlab 32 bit,
% R2012a (7.14.0.739) (32-bit, glnx86)
pause(0.5);
[FileName,newdir,newext] = uigetfile('*.dat','Select ROI classification file (e.g. cells.dat)', p.fdir);
if(FileName~=0)
    cellfile = [newdir, FileName];
else
    cellfile = [];
end;
