% paths necessary for running Look@NanoSIMS

global be_verbous
be_verbous = 1;

if exist('start_lans_quietly')
    be_verbous = ~start_lans_quietly;    
end

% path to the core LANS functions
addpath([pwd,filesep,'fnc'],'-end');

% path to add-on functions required for post-processing (processing metafiles)
addpath([pwd,filesep,'postprocess'],'-end');

% OS-specific settings; modify with care!
if ismac
    
    % Warning: MAC-OS users may have a bit of trouble to get things working 
    % and look good
    
    % path to fig files that define the graphical user interface (GUI)
    addpath([pwd,filesep,'figs_win'],'-end');

    if be_verbous
        fprintf(1,'Starting Look@NanoSIMS on a Mac-OS platform.\n');
    end
    
    % make sure that the PATH to pdflatex, epstopdf and gs binaries are correct
    LATEXDIR = '/Library/TeX/texbin/';
    GSDIR    = '/usr/local/bin/';
    
    % no need to make any changes here
    oldpath = getenv('PATH');
    if ~contains(oldpath,GSDIR)
        setenv('PATH', [oldpath ':' GSDIR]);
    end
    
    if ~isfile([GSDIR 'gs'])
        if be_verbous
            fprintf(1,'ERROR: gs not found. Please install Ghostscript to enable PDF conversion.\n');
        end
    end

	% Command for unzipping im.zip files, including the command options. 
    % Here unzip is used, which is by default available on MacOS systems.
    UNZIP_COMMAND = 'unzip -q';
    ZIP_COMMAND   = 'zip -r';
    
    % PDF viewer (path to the pdf viewer on the system)
    PDF_VIEWER = 'open';
    
    GUI_FONTSIZE = 10;

elseif isunix
    
    % unix/linux users have it easy
    
    % path to fig files that define the graphical user interface (GUI)
    addpath([pwd,filesep,'figs'],'-end');

    if be_verbous
        fprintf(1,'Starting Look@NanoSIMS on a Unix/Linux platform.\n');
    end
    
    % Command for unzipping im.zip files, including the command options. 
    % Here unzip is used, which is normally available on a unix system.
    UNZIP_COMMAND = 'unzip -q';    
    ZIP_COMMAND   = 'zip -r';
    
    % PDF viewer; normally this should work (but: see next)
    %PDF_VIEWER = 'xreader';
    
    % Sometimes, calling system(PDF_VIEWER) without the LD_LIBRARY_PATH 
    % set properly gives a segmentation fault. In this case, this new
    % syntax should fix it:
    PDF_VIEWER = 'LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu; xreader';
        
    GUI_FONTSIZE = 11;
    
elseif ispc
    
    % Windows users also have it relatively easy
    
    % path to fig files that define the graphical user interface (GUI)
    addpath([pwd,filesep,'figs_win'],'-end');

    if be_verbous
        fprintf(1,'Starting Look@NanoSIMS on a MS-Windows platform.\n');
    end
    
    % Command for unzipping im.zip files, including the command options. 
    % Here 7zip is used, which is a freeware program available for MS Windows.
    % Note that the full path to the program needs to be specified here,
    % because, based on anecdotal experience, the path to the program is not,
    % or may not be, known within the Matlab environment.
    UNZIP_COMMAND = '"c:\Program Files\7-Zip\7z.exe" e';
    ZIP_COMMAND   = '"c:\Program Files\7-Zip\7z.exe" a';

    % PDF viewer:
    % SumatraPDF is recommended: it is not the prettiest design, but the
    % program file is very small and the PDF file is automatically reloaded
    % when it is updated, which is very handy.
    % Acrobat Reader should definitely NOT be used, because it locks the
    % PDF file for writing, which means that the PDF cannot be reexported
    % by LANS if it is simultaneously opened by Acrobat Reader.
    PDF_VIEWER = '"c:\Program Files\SumatraPDF\SumatraPDF.exe"';
    
    GUI_FONTSIZE = 8;
    
end
