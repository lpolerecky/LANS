% paths and other settings necessary to run Look@NanoSIMS

% level of details in comments written in the console
global be_verbous
be_verbous = 1; 

if exist('start_lans_quietly', 'var')
    be_verbous = ~start_lans_quietly;    
end

% path to the core LANS functions: fnc
addpath([pwd,filesep,'fnc'],'-end');

% path to add-on functions required for post-processing (processing
% metafiles): postprocess
addpath([pwd,filesep,'postprocess'],'-end');

%% OS-specific and Matlab release-specific settings; modify with care!
matlab_release_year = str2num(regexp(version('-release'), '\d+', 'match', 'once'));

% In newer Matlab releases, the default figure position is larger. For the
% purpose of LANS, set it to the "classic" width of 560 and height of 420
% pixels.
if matlab_release_year>2024
    set(0, 'DefaultFigurePosition', [400, 300, 560, 420]);
end

if ismac
    
    % Warning: MAC-OS users may have a bit of trouble to get things working 
    % and look good (see below)
    
    % path to fig files that define the graphical user interface (GUI)
    addpath([pwd,filesep,'figs_macos'],'-end');

    if be_verbous
        fprintf(1,'Starting Look@NanoSIMS on a Mac-OS platform.\n');
    end
    
    % make sure that the PATH to pdflatex binary is correct
    LATEXDIR = '/Library/TeX/texbin/';
    %GSDIR    = '/usr/local/bin/';
    
    % no need to make any changes here if the paths defined above are
    % correct
    %oldpath = getenv('PATH');
    %if ~contains(oldpath,GSDIR)
    %    setenv('PATH', [oldpath ':' GSDIR]);
    %end
    
    %if ~isfile([GSDIR 'gs'])
    %    if be_verbous
    %        fprintf(1,'ERROR: gs not found. Please install Ghostscript to enable PDF conversion.\n');
    %    end
    %end

	% Command for unzipping im.zip files and zipping folders with processed
    % data, including the command options. Here unzip and zip are used,
    % which are by default available on MacOS systems.
    UNZIP_COMMAND = 'unzip -q';
    ZIP_COMMAND   = 'zip -r';
    
    % PDF viewer (path to the default pdf viewer on the system)
    PDF_VIEWER = 'open';
    
    % default fontsize to be used in the LANS windows
    GUI_FONTSIZE = 11;

    % in newer matlab releases the smaller size looks better
    if matlab_release_year>=2025
        GUI_FONTSIZE = 9;
    end

elseif isunix
    
    % unix/linux users have it easy
    
    % path to fig files that define the graphical user interface (GUI)
    addpath([pwd,filesep,'figs'],'-end');

    if be_verbous
        fprintf(1,'Starting Look@NanoSIMS on a Unix/Linux platform.\n');
    end
    
    % Command for unzipping im.zip files and zipping folders with processed
    % data, including the command options. Here unzip and zip are used,
    % which are by default available on Linux systems.
    UNZIP_COMMAND = 'unzip -q';    
    ZIP_COMMAND   = 'zip -r';
    
    % PDF viewer; normally this should work, but see next...
    %PDF_VIEWER = 'xreader';
    
    % Sometimes, calling system(PDF_VIEWER) without the LD_LIBRARY_PATH 
    % set properly gives a segmentation fault. In this case, this new
    % syntax should fix it:
    PDF_VIEWER = 'LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu; xreader';
        
    % fontsize to be used in the LANS windows
    GUI_FONTSIZE = 11;
    
elseif ispc
    
    % Windows users also have it relatively easy
    
    % path to fig files that define the graphical user interface (GUI)
    addpath([pwd,filesep,'figs_win'],'-end');

    if be_verbous
        fprintf(1,'Starting Look@NanoSIMS on a MS-Windows platform.\n');
    end
    
    % Command for unzipping im.zip files and zipping folders with processed
    % data, including the command options. Here 7zip is used, which is a
    % freeware program available for MS Windows. 
    % Note that the full path to the program needs to be specified here,
    % because, based on anecdotal experience, the path to the program is
    % not, or may not be, known within the Matlab environment.
    UNZIP_COMMAND = '"c:\Program Files\7-Zip\7z.exe" e';
    ZIP_COMMAND   = '"c:\Program Files\7-Zip\7z.exe" a';

    % PDF viewer:
    % - msedge.exe will by default exist on Windows machines, so it is the
    % default value
    % - SumatraPDF is recommended: it is not the prettiest design, but the
    % program file is very small and the PDF file, when viewed, is
    % automatically reloaded if it is updated by LANS, which is very handy.
    % - Acrobat Reader should definitely NOT be used, because it locks the
    % PDF file for writing, which means that the PDF cannot be reexported
    % by LANS if it is simultaneously viewed by Acrobat Reader.
    PDF_VIEWER = '';

    % these two are possible default values
    pdfv = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe';
    if exist(pdfv, 'file') == 2
        PDF_VIEWER = ['"', pdfv, '"'];
    end
    pdfv = 'C:\Program Files\Microsoft\Edge\Application\msedge.exe';
    if exist(pdfv, 'file') == 2
        PDF_VIEWER = ['"', pdfv, '"'];
    end
    
    % choose a program of your choice
    pdfv = 'c:\Program Files\SumatraPDF\SumatraPDF.exe';
    if exist(pdfv, 'file') == 2
        PDF_VIEWER = ['"', pdfv, '"'];
    end

    % fontsize to be used in the LANS windows
    GUI_FONTSIZE = 8;
    
end
