% Script for updating LANS from a zip file located at a given web-address.
% No warranty, but it should work like this: Your old LANS is backed up,
% the latest version is downloaded and unzipped, the MATLABPATH is updated.

% (c) L. Polerecky, 2018-06-07, Utrecht University

LANS_webaddress   = 'https://www.dropbox.com/s/adapr3pulmhlrnl/LANS-latest-src.zip?dl=1';
LANS_zipfile      = 'f1.zip';
LANS_backup_fname = ['LANS-backup-' datestr(now,'YYYY-mm-DD_HH-MM-SS') '.zip'];
LANS_new_fname    = 'LANS-current';

aa=0;
fprintf(1,'*** This will update your Look@NanoSIMS program. ***\n');
fprintf(1,'1. Your current LANS files will be backed up in a zip file.\n');
fprintf(1,'2. The most recent LANS files fill be downloaded from Dropbox and unzipped in your current LANS folder.\n');
aa=input('Do you want to continue? (Enter 1 for yes, anything else for no.)\n');
if isempty(aa), aa=0; end

if aa==1

    % open and close the LANS GUI, to be sure it's closed
    start_lans_quietly = 1;
    lans_paths;
    lh=LANS;
    delete(lh);
    clear LANS_version
    
    % first make a backup of the existing LANS distribution
    curr_dir = pwd;
    [a,b,c]=fileparts(curr_dir);
    old_lans_folder = [b c];
    cd(a);
    fprintf(1,'Creating a backup of the old LANS folder %s ... ',old_lans_folder);
    zip(LANS_backup_fname,old_lans_folder);
    fprintf(1,'Done.\n');

    % download the latest LANS src files
    fprintf(1,'Downloading LANS-latest-src.zip from %s ... ',LANS_webaddress);
    outf = websave(LANS_zipfile,LANS_webaddress);
    fprintf(1,'Done.\n');

    % update now
    fprintf(1,'Attempting LANS update ... \n');

    fprintf(1,'  Unzipping %s ... ', LANS_zipfile);    
    if exist(LANS_new_fname)>0
        % if the remnants of the previous update remain, delete them
        rmdir(LANS_new_fname,'s');
    end        
    unzip(LANS_zipfile,LANS_new_fname);
    delete(LANS_zipfile);
    fprintf(1,'Done.\n');
    
    fprintf(1,'  Updating the folder structure in %s ... ',LANS_new_fname);
    cd(LANS_new_fname)
    if exist('src')>0
        cd('src');
        movefile('*','..');
        cd('..')
        rmdir('src');
    end
    fprintf(1,'Done.\n');    

    % remove the old LANS paths
    fprintf(1,'  Updating MATLAB path ...\n');
    lans_folders = {'fnc', 'external', 'figs', 'figs_win', 'log', 'postprocess'};
    pathCell = regexp(path, pathsep, 'split');
    for i=1:length(lans_folders)
        p1=[curr_dir filesep lans_folders{i}];
        if ispc  % Windows is not case-sensitive
          onPath = any(strcmpi(p1, pathCell));
        else
          onPath = any(strcmp(p1, pathCell));
        end
        if onPath
            rmpath(p1);
            fprintf(1,'  Path %s removed from MATLAB path.\n',p1);
        end
    end
    fprintf(1,'  Done.\n');

    % in the folder with the current version, find out the version, and
    % rename the folder to that version    
    lookatnanosims;
    lh = LANS;
    delete(lh);
    LANS_new_folder = ['LANS-' LANS_version];
    
    % because LANS was run, the paths have been again updated, so remove
    % the newly added paths.
    curr_dir = pwd;
    fprintf(1,'  Updating MATLAB path ...\n');
    pathCell = regexp(path, pathsep, 'split');
    for i=1:length(lans_folders)
        p1=[curr_dir filesep lans_folders{i}];
        if ispc  % Windows is not case-sensitive
          onPath = any(strcmpi(p1, pathCell));
        else
          onPath = any(strcmp(p1, pathCell));
        end
        if onPath
            rmpath(p1);
            fprintf(1,'  Path %s removed from MATLAB path.\n',p1);
        end
    end
    fprintf(1,'  Done.\n');
    
    cd('..');
    curr_dir = LANS_new_folder;
    if exist(LANS_new_folder)>0
        % the folder with the same name already exists, so delete it.
        aa=input(sprintf('Folder %s already exists.\nDo you want to replace its content with the just downloaded LANS distribution? (Enter 1 for yes, anything else for no) ',LANS_new_folder));
        if aa==1
            rmdir(LANS_new_folder,'s');
            movefile(LANS_new_fname,LANS_new_folder);
            fprintf(1,'Folder %s renamed to %s.\n',LANS_new_fname, LANS_new_folder);            
        else
            fprintf(1,'Folder not renamed.\n');
            curr_dir = LANS_new_fname;
        end
    else
        movefile(LANS_new_fname,LANS_new_folder,'f');
    end
    cd(curr_dir);
            
    fprintf(1,'Backup of your old Look@NanoSIMS saved in %s.\n',[a LANS_backup_fname]);
    fprintf(1,'Latest Look@NanoSIMS installed in %s\n',pwd);
    fprintf(1,'Type lookatnanosims to start the program.\n');

    clear a b c outf pathCell lans_folders p1 onPath
    
else
    fprintf(1,'Nothing done.\n');
end

clear LANS_webaddress LANS_zipfile LANS_backup_fname LANS_new_fname aa
