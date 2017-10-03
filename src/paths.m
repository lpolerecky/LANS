% paths necessary for running of the Look@NanoSIMS program

% path with the basic LANS functions
addpath([pwd,filesep,'fnc']);
% path with functions required for postprocessing (processing metafiles)
addpath([pwd,filesep,'postprocess']);
% path functions written by other people that are used by LANS
addpath([pwd,filesep,'external']);
% path with fig files that define the graphical user interface (GUI)
addpath([pwd,filesep,'figs']);

% system-specific settings; modify with care!
if ismac
    % MAC-OS users may have a bit of trouble to get things working

    fprintf(1,'Starting Look@NanoSIMS on a Mac-OS platform.\n');
    
    % make sure that the PATH to pdflatex, epstopdf and gs binaries are
    % correct
    LATEXDIR = '/Library/TeX/texbin/';
    GSDIR = '/usr/local/bin/';
    
    % no need to make any changes here
    oldpath = getenv('PATH');
    if isempty(strfind(oldpath,GSDIR))
        setenv('PATH', [oldpath ':' GSDIR]);
    end;
    
    if ~exist([GSDIR 'gs'])==2
        fprintf(1,'ERROR: gs not found. Please install Ghostscript to enable PDF conversion.\n');
    end;

	% Command for unzipping im.zip files, including the command options. 
    % Here I use unzip, which is by default available on MacOS systems.
    UNZIP_COMMAND = 'unzip -q';

elseif isunix
    % unix/linux users have it easy

    fprintf(1,'Starting Look@NanoSIMS on a Unix/Linux platform.\n');
    
    % Command for unzipping im.zip files, including the command options. 
    % Here I use unzip, which is normally available on a unix system.
    UNZIP_COMMAND = 'unzip -q';
        
elseif ispc
    % Windows users also have it relatively easy

    fprintf(1,'Starting Look@NanoSIMS on a MS-Windows platform.\n');
    
    % Command for unzipping im.zip files, including the command options. 
    % Here I use 7zip, which is a freeware program available for MS Windows.
    % Note that the full path to the program needs to be specified here,
    % because, based on limited experience, the path to the program is not,
    % or may not be, known within the Matlab environment.
    UNZIP_COMMAND = '"c:\Program Files (x86)\7-Zip\7z.exe" e';

end;
