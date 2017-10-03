function assemble_xymosaic(xscale,yscale,zscale)
% Function for assembling nanosims images in a mosaic, based on the x and y
% co-ordinates of each individual image
% (c) Lubos Polerecky, 24.05.2010, MPI Bremen

% load settings from the ini file
load nanosimsini.mat

% get default base_dir
base_dir = h.edit1.string;
% ask for the base directory with all the processed files
disp('Select base directory with all processes data');
dname = uigetdir(base_dir,'Select base directory with all processes data');
if(dname~=0)
    base_dir=dname;
end;
base_dir=fixdir(base_dir);

% specify the meta-file with the meta-instructions
disp('Select file with the meta-instructions');
[FileName,newdir,newext] = uigetfile({'*.txt';'*.meta';'*.dat'}, 'Select metafile', base_dir);
if(FileName~=0)
    metafname = [newdir, FileName];
else
    % default
    metafname = [base_dir,delimiter,'summary9.txt'];
end;

% specify the final output filename
disp('Define output EPS file')
[FileName,newdir,newext] = uiputfile('*.eps', 'Choose output EPS file', base_dir);
if(FileName~=0)
    foutname = [newdir, FileName];
else
    % default
    [pathstr, name, ext, versn] = fileparts(infile);
    foutname = [pathstr,delimiter,name];
end;
[pathstr, name, ext, versn] = fileparts(foutname);
foutname = [pathstr,delimiter,name];
    
% get instructions from the meta file
[id,fname,tmnt,ct,xs,ys,zs,nf]=getmetainstructions(metafname);

% ask the user which file will be used for ROI's definition
while 1
    disp('Select file with ROI (cells) definitions');
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select file with ROI definitions',...
        [base_dir, fname{1},delimiter]);
    if(FileName~=0)
        cells_file = FileName;
    end;
    c=load([newdir,cells_file]);
    if(isfield(c,'Maskimg'))
        break;
    else
        disp(['File ',cells_file,' doesn''t seem to contain ROI definition. Please select another one.']);
    end;
end;

% load the MAT files, for each special mass and image-set
xpos=[];
ypos=[];
xim=[];
yim=[];
zim=[];
mim=[];
for j=1:nf
    % find out the image co-ordinates
    imfile=[base_dir,fname{j},'.chk_im'];
    im = readimchk(imfile);
    xpos(j)=im.pos.x;
    ypos(j)=im.pos.y;    
    % load cells image first
    ctmp=[base_dir,fname{j},delimiter,cells_file];
    c=load(ctmp);
    mim{j}=c.Maskimg;
    for m=1:3
        switch m,
            case 1, ms=xs{j}; %scale=xscale;
            case 2, ms=ys{j}; %scale=yscale;
            case 3, ms=zs{j}; %scale=zscale;
        end;
        ms=convert_string_for_texoutput(ms);
        mtmp=[base_dir,fname{j},delimiter,'mat',delimiter,ms,'.mat'];
        
        % load matlab file containing the special image and re-print it
        % with a new scale
        if(exist(mtmp))
            v=load(mtmp);
            switch m,
                case 1, xim{j}=v.IM;
                case 2, yim{j}=v.IM;
                case 3, zim{j}=v.IM;
            end;
        else
            disp(['*** File ',mtmp,' missing!']);
        end;
    end;
end;
xpos=xpos-min(xpos);
ypos=-ypos-min(-ypos);

nx=size(xim{1},2);
ny=size(xim{1},1);
stepsize=25;
xpix=ceil(xpos*nx/stepsize);
ypix=ceil(ypos*ny/stepsize);
%mbig=zeros(max(xpix)+nx,max(ypix)+ny);
for m=1:3
    switch m,
        case 1, ms=xs{j}; img=xim; scale=xscale;
        case 2, ms=ys{j}; img=yim; scale=yscale;
        case 3, ms=zs{j}; img=zim; scale=zscale;
    end;
    if(strcmp(ms,'13C/12C'))
        bkg=0.011;
    else
        bkg=0;
    end;
    xbig=bkg*ones(max(xpix)+nx,max(ypix)+ny);
    for j=1:nf    
        ind=find(mim{j}==0);
        img{j}(ind)=bkg*ones(size(ind));
        xbig([1:ny]+xpix(j),[1:nx]+ypix(j))=(img{j});
    end;
    % xbig image is not defined. Print it and save as tif
    figure(30+m); imagesc(xbig,scale); colormap(clut);
    ind=find(xbig<scale(1));
    xbig(ind)=scale(1)*ones(size(ind));
    ind=find(xbig>scale(2));
    xbig(ind)=scale(2)*ones(size(ind));
    ms=convert_string_for_texoutput(ms);
    % write tif
    imwrite((xbig-scale(1))/(scale(2)-scale(1))*size(clut,1),clut,[foutname,ms,'.tif']);
    
end;
a=1;