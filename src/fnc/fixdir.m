function fout=fixdir(fin)
% fix the directory name, if the delimiter at the end was forgotten

% disp('*** This is fixdir ***');

if(~strcmp(fin(length(fin)),delimiter))
    fout = [fin,delimiter];
else
    fout = fin;
end;