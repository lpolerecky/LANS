function p=read_cameca_image(fname, ask_for_planes, load_accumulated, hndls)
% Read data from the Cameca Image file FNAME. The IM file can be zipped.
% The IM or IM.ZIP files can be missing, in which case only the accumulated
% data stored in MAT files will be loaded.
% USAGE:
%    im=read_cameca_image(fname,ask_for_planes, load_accumulated)
% Required input: 
%   - FNAME: full filename 
%   - ASK_FOR_PLANES - set to 1 to allow the user to specify which planes
%   should be loaded from the dataset
%   - LOAD_ACCUMULATED - set to 2 to load the data stored in the mat files
%   produced by LANS. Useful when only the mat files are available but not
%   any more the original IM file.
% Everything is returned in a structure P:
% 1) All masses for all planes are returned as a structure of 3D matrices,
% i.e., p.im{mass}(:,:,plane). Be careful with the memory requirements if
% there are many planes!! 
% 2) Additional parameters characterizing the dataset are also returned
% (see the end of read_im_file.m for details).
%
% (c) L. Polerecky, 25.11.2009, MPI Bremen
% updated: L. Polerecky, 22.08.2012, MPI Bremen
% updated for loading zipped image files: L. Polerecky, 04.03.2017, Utrecht

if nargin>3
    handles = hndls;
else
    handles = [];
end

im=[]; planes = []; p = [];
imfile_existed=0;

orig_fname = fname;
[pathstr, name, ext] = fileparts(fname);

if load_accumulated ~= 2

% if im file is compressed by zip, unzip it first before reading it.
% if the original im file and zipped im file existed simultaneously, move 
% the original im file to a tmp file, which will be at the end renamed back

    % do this if a *.im.zip file is to be read
    if ~isempty(findstr(ext,'.zip'))

        % if the unzipped im file exists too, move it to a tmp file first
        uname = [pathstr delimiter name];
        if exist(uname)==2
            fprintf(1,'Filename %s already exists.\n',uname);
            [pathstr1, tmpname, ext1] = fileparts(uname);
            tmpimfile = [pathstr1 delimiter 'imtmp.im'];
            fprintf(1,'Renaming to %s ... ',tmpimfile);
            movefile(uname, tmpimfile);
            fprintf(1,'done.\n');
            imfile_existed=1;
        end;

        % unzip the zipped im file
        global UNZIP_COMMAND;    
        fprintf(1,'\nUnzipping %s ... ',[name, ext]);    
        s = ['!' UNZIP_COMMAND ' ' name ext];
        cdir=pwd;
        cd(pathstr);
        eval(s);
        cd(cdir);
        fprintf(1,'done.\n');

        % from now on, *.im file should exist, so update the fname 
        fname = [pathstr delimiter name];

    end;
    
    % read the IM file, filling also its properties in the p structure
    if exist(fname)==2           
        [im, planes, p]=read_im_file(fname,ask_for_planes);
        log_user_info(fname);        
        p.im = im;
        p.planes = planes;
        if ~isempty(handles)
            set(handles.text46,'string',num2str(p.scale));
        end;
    end;

    % if a zipped image file was loaded, remove the unzipped file
    % if the original unzipped file also existed, rename it back
    if ~isempty(findstr(ext,'.zip'))
        fprintf(1,'Deleting file %s and keeping the zipped file ... ',fname);
        delete(fname);
        fprintf(1,'done.\n');
        if imfile_existed
            fprintf(1,'Moving %s back to %s ... ',tmpimfile,fname);
            movefile(tmpimfile, fname); 
            fprintf(1,'done.\n');
        end;
    end;

else

    % load accumulated data (essentially mat files)
    if ~isempty(handles)
        [im, planes, p]=read_accu_im_file(fname,handles);
        log_user_info(fname);        
        p.im = im;
        p.planes = planes; 
    else
        fprintf(1,'*** Warning: cannot load accumulated image data.\n');
    end;
end;
    
% set the EXTERNAL_IMAGEFILE to empty by default every time a new dataset
% is loaded
global EXTERNAL_IMAGEFILE;
EXTERNAL_IMAGEFILE='';