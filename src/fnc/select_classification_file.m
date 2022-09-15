function cellfile = select_classification_file(p)
% make a pause, otherwise matlab crashes on some computers
% particularly on my TravelMate-3020 - linux-mint-box, matlab 32 bit,
% R2012a (7.14.0.739) (32-bit, glnx86)
pause(0.5);

global CELLSFILE

def_file = [p.fdir CELLSFILE '.dat'];
fprintf(1,'\n*** Select ROIs classification file (default %s).\n',def_file);
fprintf(1,'If the file does not exit, or if you do not want to select it, click ''Cancel'' or press ''Esc''.\n');

[FileName,newdir,newext] = uigetfile('*.dat',sprintf('Select ROI classification file (e.g. %s)',def_file), def_file);
if(FileName~=0)
    cellfile = [newdir, FileName];
else
    cellfile = [];
end