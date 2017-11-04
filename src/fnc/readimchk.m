function im = readimchk(imfile)
% Read *.chk_im file and parse it to find out which masses where measured
% and what is the position, date/time, dimensions and scale of the image. 
% Store everything in a structure im: im.pos, im.mass, im.date, im.time...
% (c) L. Polerecky, 8.6.2009, MPI Bremen
% This file is obsolete from version 20/08/2012

if ~isempty(findstr(imfile,'.chk_im'))
    [pathstr name ext] = fileparts(imfile);
    imfile = [pathstr delimiter name];
end;

chkfile = [imfile,'.chk_im'];
[pathstr name ext] = fileparts(chkfile);

im=[];

raw_data_loaded = ( exist([imfile,'.im'])==2 | exist([imfile,'.imf'])==2 ) & exist(chkfile)==2;
processed_data_loaded = exist(chkfile)==2 & isdir(pathstr);
if raw_data_loaded | processed_data_loaded

    disp(['Loading information from ',chkfile]);
    fid=fopen(chkfile,'r');

    tline = fgetl(fid);
    tline = fgetl(fid);
    
    % determine date/time
    tline = fgetl(fid);
    ind1=max(find(tline==char(9)));
    ind2=max(find(tline==char(' ')));
    ind2=find(tline==' ');
    datestr = tline((ind1+1):(ind2-1));
    timestr = tline((ind2+1):length(tline));
    
    % determine stage position
    tline = fgetl(fid);   
    indx=findstr(tline,'x=');
    indy=findstr(tline,'y=');
    indz=findstr(tline,'z=');
    ind2=findstr(tline,'um');
    pos=[];
    if(~isempty(indx))
        pos(1)=str2num(tline((indx+2):(ind2(1)-1)));
    else
        pos(1)=0;
    end;
    if(~isempty(indy))
        pos(2)=str2num(tline((indy+2):(ind2(2)-1)));
    else
        pos(2)=0;
    end;
    if(~isempty(indz))
        pos(3)=str2num(tline((indz+2):(ind2(3)-1)));    
    else
        pos(3)=0;
    end;        
    
    % read line
    tline = fgetl(fid);
    
    % set the reverse byte order flag
    % for reverse_bytes == 1 the file was most likely measured under windows and
    % thus the binary im file will have the bytes reversed
    % for reverse_bytes == 0 the file was most likely measured under unix and
    % thus the binary im file will not have the bytes reversed
    im.reverse_bytes = length(findstr(tline,'\'))>0;
    if im.reverse_bytes
        fprintf(1,'Warning: The IM file seems to have been measured under Windows. Bytes will be reversed while reading.\n');
    end;
    
    
    % determine size of the image and scale
    tline = fgetl(fid);
    A=sscanf(tline,'Frame:%d,%d-%d,%d / Raster:%fum');
    w = A(3)-A(1)+1;
    h = A(4)-A(2)+1;
    scale = A(5);
    
    % read other data until you encounter Mass#
    while 1
        tline = fgetl(fid);
        if(~isempty(findstr(tline,'Mass#')))
            break;
        end;
    end;
    
    % determine masses
    ii=0;
    while 1
        tline = fgetl(fid);
        if(tline==-1)
            tline='';
        end;
        if(length(tline)>0)
            ii=ii+1;
            m{ii}=getmass(tline);
        else
            break;
        end;
    end;
    fclose(fid);
    
    % construct the output structure im
    im.pos=pos;
    for ii=1:length(m)
        im.mass{ii}=m{ii}.isotope;
        im.mass_precise(ii)=m{ii}.mass_precise;
    end;
    im.date=datestr;
    im.time=timestr;
    im.width=w;
    im.height=h;
    im.scale=scale;
    im.filename=imfile;

    % make the directory with the same name as the filename if raw data was
    % loaded, but not if processed data was loaded
    if raw_data_loaded
        if(~isdir(imfile))
            mkdir(imfile);
        end;

        % copy the chk_im file to the default output directory
        [pathstr, name, ext] = fileparts(chkfile);
        bakfile = [pathstr delimiter name delimiter name ext];
        copyfile(chkfile, bakfile);
        fprintf(1,'Backup file %s created.\n',bakfile);
    else
        [pathstr, name, ext] = fileparts(imfile);
        im.filename = pathstr;
    end;        
    
else
    
    if(exist([imfile,'.im'])~=2)
        disp(['Error: ',imfile,'.im cannot be found.']);
    end;
    if(exist([imfile,'.imf'])~=2)
        disp(['Error: ',imfile,'.imf cannot be found.']);
    end;
    if(exist(chkfile)~=2)
        disp(['Error: ',chkfile,' cannot be found.']);
    end;
    
end;