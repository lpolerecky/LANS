function [val,r]=readdacfile(fn,col,verbose)
if(exist(fn)==2)
    % parse the fn file
    if(verbose), disp(['Processing file ',fn]); end;
    fid=fopen(fn,'r');
    % read the two header lines
    tline=fgetl(fid);
    tline=fgetl(fid);
    % read first line of the data, and determine the number of columns (7
    % for old format before 4-12-2010, 8 for new format after 4-12-2010, 9
    % for the format after 12-1-2011, 10 for the format after 29-03-2022)
    tline=fgetl(fid);
    a1=str2num(tline);
    ncol=length(a1);
    % read the data now
    fmt='%d %f %f %f %f %f %f'; 
    if(ncol>7)
        for ii=1:(ncol-7)
            fmt=[fmt ' %f'];
        end
    end
    A = fscanf(fid,fmt,[ncol,inf]);		
    fclose(fid);
    r=[a1; A'];
    if(~isempty(r))
        val=r(:,3+col);        
        % make r back-compatible (if it has only 7 or 8 columns)
        if(size(r,2)==7)
            r=[r r(:,7)];
        end
        if(size(r,2)==8)
            r = [r ones(size(r,1),1)];
        end
    else
        val=0;
        r=zeros(1,10);
        fprintf(1,'Warning: File contains no data. Returning zeros.\n');
    end
else
    val=zeros(10,0);
    r=zeros(10,10);
end