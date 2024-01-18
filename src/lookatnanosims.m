%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the startup script of the Look@NanoSIMS (LANS) program. To run
% the program, simply type lookatnanosims in Matlab command window and 
% press Enter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Look@NanoSIMS was written by Lubos Polerecky @ MPI-Bremen 2008-2012.
% Development continued by LP @ Utrecht University 2013-2022.
% See http://nanosims.geo.uu.nl/LANS for more details about the program.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read these NOTES before proceeding. Really. :)
%
% The graphical user interface (GUI) is defined in different *.fig files
% saved in the figs folder. By setting the units of the GUI objects to
% 'characters', the GUIs shoud look similar (and good) for all platforms
% (e.g. linux, windows, mac). Since Matlab version 2014, however, this
% may no longer be the case. Thus, if you open the older LANS version with
% a newer Matlab version, or vice versa, the appearance of LANS may not
% look as good as you would like to. If this is the case, I recommend that
% you upgrade Matlab to the version in which LANS was developed (see list
% of versions below). If you cannot do this, you can modify the GUI by
% yourself. To do this, in Matlab console, type 'guide' (without the '')
% and press enter. Then browse to the fig file that you would like to
% modify and change the positions and sizes of the GUI objects to your
% liking. Alternatively, do this through the menu: File -> New -> GUI ->
% Open existing GUI -> Browse. 
%
% The exported images (eps and pdf files) depend on the platform, and it
% seems that also on the Matlab version used. If you are not happy with the
% look of the exported images or plots (e.g. the fonts are too big or too
% small), select Settings -> Additional output options in the main menu of
% LANS to modify the appearance of the exported figures. You will need to
% experiment with the print factors until you get optimal results.
%
% To enable all features implemented in LANS, you will also need to have
% the following programs/packages installed on your system: 
% - LaTeX, including binaries for epstopdf and pdflatex, the URL (url.sty)
% and HYPERREF (hyperref.sty) packages.
% - Ghostscript (for converting EPS files to PDF).
% - a program for unzipping zip files (e.g. 7-zip under Windows, or unzip 
% under Linux or Mac-OS).
% - a program for viewing PDF files (e.g., xreader under Linux, Preview
% under Mac-OS, SumatraPDF under Windows). 
%
% When working on Ubuntu-like Linux systems, you will need to install these
% packages to make things work seemlessly: 
% - texlive-latex-base
% - texlive-latex-recommended
% + whatever other dependencies that come with these packages.
% The unzip program is installed by default.
%
% If you use Mac-OS, first check your system to find out where the 
% pdflatex and ghostscript binaries are located (e.g., /usr/texbin/ and 
% /usr/local/bin). Then modify accordingly the LATEXDIR and GSDIR variables 
% in the paths.m file. The unzip program is installed by default. The
% preview program probably too.
%
% If you use Windows, standard installation of MikTeX, Ghostscript and
% 7-Zip will do the job to make everything work correctly in LANS. However,
% in Windows 10 you also need to verify that the helvetic font is
% installed, otherwise the epstopdf conversion may not work.
%
% To make sure that all the paths are correctly defined, check the file 
% paths.m in the LANS folder. 
%
% It seems that secondary ion counts on some (newer?) systems are stored as 
% ushort (16-bit unsigned integer), whereas on some (older?) systems they
% are  stored as uint8 (8-bit unsigned integers). Perhaps this is because
% of the differences between the 32-bit and 64-bit operating systems that
% run the Cameca instrument, but I am not 100% sure. Therefore, if you
% experience problems with loading an im file, e.g. the program tells you
% that there are 0 planes even though there are for sure more, it may well
% be that this is the cause. In that case, open the file read_im_file.m in
% the fnc folder and see whether you can hack it to make things work. If
% not, contact LP who may be able to help you. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you can modify some of the default settings of the program.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear CELLSFILE IM_FILE_EXT verbose;
global CELLSFILE IM_FILE_EXT verbose;

% default name of the file with ROIs definitions
CELLSFILE = 'cells';
%CELLSFILE = 'rois';

% default extension of the input binary im file
IM_FILE_EXT = '.im.zip';

% define whether you want to display actions during data processing by LANS
verbose = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There should be no need to make any changes below this line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear LANS_version LATEXBIN;

% define global variable names
global LANS_version;
global LATEXDIR;
global MAT_EXT;
global UNZIP_COMMAND;
global ZIP_COMMAND;
global EXTERNAL_IMAGEFILE;
global PDF_VIEWER;
global GUI_FONTSIZE;

% list of versions, last line = the current version
LANS_version = '11/11/2011';
LANS_version = '22/02/2012-beta';
LANS_version = '24/04/2012';
LANS_version = '03/07/2012';
LANS_version = '03/09/2012';
LANS_version = '05/01/2013';
LANS_version = '2013-04-01_devel';
LANS_version = '2014-01-02';
LANS_version = '2014-10-02';
LANS_version = '2014-11-27';
LANS_version = '2015-04-26';
LANS_version = '2015-06-09';
LANS_version = '2015-10-20';
LANS_version = '2016-01-22';
LANS_version = '2016-02-15';
LANS_version = '2017-01-28';
LANS_version = '2017-05-14';
LANS_version = '2017-06-01';
LANS_version = '2017-09-07';
LANS_version = '2017-11-04';

% these versions require min Matlab 2017b
LANS_version = '2017-12-18-matlab2017b';
LANS_version = '2018-02-18-matlab2017b';

% these versions require min Matlab 2018a (developed in Matlab 2018a)
LANS_version = '2018-05-20-matlab2018a';
LANS_version = '2018-06-22';
LANS_version = '2018-11-12';
LANS_version = '2019-02-22';
LANS_version = '2019-05-14';
LANS_version = '2019-12-18';
LANS_version = '2020-03-03';
LANS_version = '2020-03-19';

% these versions require min Matlab 2019b
LANS_version = '2020-03-28';
LANS_version = '2020-04-22';
LANS_version = '2020-05-01';
LANS_version = '2020-05-04';
LANS_version = '2020-05-05';
LANS_version = '2020-05-10';
LANS_version = '2020-05-28';
LANS_version = '2020-12-04';
LANS_version = '2021-01-15'; % bug fixes: my_figure; read_data_from_input_files; load_settings;
LANS_version = '2021-05-21-beta'; % added capability to analyse more than 8 masses (tested for 10, peak-switching)
LANS_version = '2022-01-13'; % fixed issues in Display-XYZ-Stacks, added mat-folder removal and 
							 % folder backup (see Preferences menu)
LANS_version = '2022-02-22'; % palindrome!! :) 
                             % new features implemented:
                             % 1. export of _cnt
                             % 2. backup of pdf and minimal mat output
                             % 3. LWratio calculation revised (see find_cell_lwfactor.m for details),
                             % uncertainty of LWratio also calculated and added to the output file; 
                             % this change required revision of several functions for writing and 
                             % loading data into/from disk
LANS_version = '2022-07-04'; % errorbars for lateral profiles implemented; 
                             % bugs fixed in how the lateral profiles for mass and mass/plane/pixel 
							 % are calculated/displayed
LANS_version = '2022-09-02'; % An error was fixed in the worklow for defining ROIs using resampled (magnified)
							 % NanoSIMS images or high-resolution external images (e.g. EM).
							 % With this error, the resized image wanted to be resized again, which yielded 
							 % enormous datasets and thus resulted in a Matlab crash.
                             % Also, export of RGB overlays in the CMYK mode was added.
LANS_version = '2022-12-10'; % Bugs in autoupdate_cell_classification after
                             % rearranging cells (due to the addition,
                             % removal, splitting of cells) fixed.
LANS_version = '2023-03-14'; % Bug fixed: comparison of ratios in individual ROIs based on
                             % depth profiles now works again.
LANS_version = '2023-03-16'; % Bug fixed: when all planes are accumulated, i.e., planes = [],
                             % the image_stack in lateral profiles became empty.                             
LANS_version = '2023-06-09'; % There was a bug in the formatting of the data structure when the im file
                             % only contained one plane, which caused
                             % errors down the line (e.g., when one wanted
                             % to display lateral profiles). This bug has
                             % been fixed now.
LANS_version = '2023-08-03'; % Bugs in export_depth_profiles.m fixed.
                             % Now it is again possible, without errors, to
                             % use metafile processing for plotting depth
                             % profiles of ion counts and ion count ratios
                             % in ROIs. By default, depth profiles in all
                             % planes selected during the processing of the
                             % individual datasets are plotted (and exported).
                             % One can change this behaviour by including a
                             % range of planes (e.g., [5:25]) for each
                             % individual dataset in the metafile. The range
                             % should be added at the end of the
                             % corresponding line. Note that this range is
                             % also used when doing Auto-process datasets
                             % during metafile processing. In this case,
                             % when the data is reprocessed, the total ion
                             % counts, and the corresponding ion count ratios,
                             % will be calculated by accumulating only the
                             % specified planes.
LANS_version = '2024-01-18'; % Bugs in align_external_image due to autoscale fixed.

% name of the external image file (empty by default)
EXTERNAL_IMAGEFILE = '';

% extension of the Matlab output 
MAT_EXT = '.mat';

% Load paths to make sure all the LANS functions can be found by Matlab.
lans_paths;

% Welcoming message from LP
if be_verbous
    fprintf(1,'================================================================\n')
    fprintf(1,'Look@NanoSIMS (version %s)\n',LANS_version);
    fprintf(1,'Written by Lubos Polerecky <lpolerec (at) mpi-bremen.de>\n')
    fprintf(1,'(2008-2012) Max-Planck Institute for Marine Microbiology, Bremen\n')
    fprintf(1,'Updates by Lubos Polerecky <l.polerecky (at) uu.nl>\n')
    fprintf(1,'(2013-2024) Utrecht University\n')
    fprintf(1,'More info: http://nanosims.geo.uu.nl/LANS\n')
    fprintf(1,'================================================================\n')
    fprintf(1,'Enjoy your work!\n')
    fprintf(1,'***\nNote:\nAVOID using SPECIAL CHARACTERS in the path and file names of your data-sets. Use _ or - instead.\n');
    disp('Special characters: SPACE, BRACKET ][, PARANTHESES )(, #, %, ^, &, *, /, \\, APOSTROPHE, comma, colon, semi-colon.');
    fprintf(1,'***\n');
end

% Run the actual GUI of Look@nanoSIMS
LANS;

if exist('start_lans_quietly')
    clear start_lans_quietly
end
