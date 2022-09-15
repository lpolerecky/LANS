function [planes,ratios]=readdatprofile(fn,col,verbose)
if(exist(fn)==2)
    % parse the fn file
    if(verbose), disp(['Processing file ',fn]); end
    fid=fopen(fn,'r');
    % read the three header lines
    tline=fgetl(fid);
    tline=fgetl(fid);
    tline=fgetl(fid);
    % read first line of the data, and determine the number of columns
    tline=fgetl(fid);
    a1=str2num(tline);
    ncol=length(a1);
    % read the data now
    fmt='%d';
    for ii=1:(ncol-1)
        fmt = [fmt ' %e'];
    end
    A = fscanf(fid,fmt,[ncol,inf]);		
    fclose(fid);
    r = a1;
    if(~isempty(A))
        r=[r; A'];
    end
    % export planes and mean ratios
    planes = r(:,1);
    ratios = r(:,[2:2:end]);
else
    planes = [];
    ratios = [];
    fprintf(1,'ERROR: File %s does not exist.\n',fn);
end