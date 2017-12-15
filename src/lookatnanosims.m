%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the startup script of the Look@NanoSIMS program. To run the
% program, simply type lookatnanosims in Matlab command window and 
% press Enter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Look@NanoSIMS was written by Lubos Polerecky @ MPI-Bremen 2008-2012.
% Development continued by LP @ Utrecht University 2013-2017.
% See http://nanosims.geo.uu.nl/nanosims-wiki/doku.php/nanosims:lans
% for more details about the program.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read these NOTES before proceeding. Really. :)
%
% The graphical user interface (GUI) is defined in different *.fig files
% saved in the figs folder. By setting the units of the GUI objects to
% 'characters', the GUIs shoud look similar (and good) for all platforms
% (e.g. linux, windows, mac). Since Matlab version 2014, however, this
% may not be the case any longer. If you are not happy with the look of the
% GUI on your system, use Matlab's GUI editor to modify it (Matlab:
% File->New->GUI->Open existing GUI->Browse). If you don't want to do this,
% it is recommended that you use Matlab 2013b, which is the version where
% the GUI's were developed.
%
% The exported images (eps and pdf files) depend on the platform, and it
% seems that also on the Matlab version used. If you are not happy with the
% look of the exported images or plots (e.g. the fonts are too big or too
% small), select Settings -> Additional output options in the main menu of
% the program to modify the appearance of the exported figures.
%
% To enable all features implemented in Look@NanoSIMS, you will also need to
% have the following programs/packages installed on your system:
% - stadard LaTeX distribution, including binaries for epstopdf and pdflatex, 
% and also the URL (url.sty) and HYPERREF (hyperref.sty) packages.
% - the Ghostscript program (for converting EPS files to PDF).
% - the program for unzipping zip files (e.g. 7-zip under Windows, or unzip 
% under Linux or Mac-OS).
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
% in the paths.m file. The unzip program is installed by default.
%
% If you use Windows, standard installation of MikTeX, Ghostscript and 7-Zip
% will do the job to make everything work correctly in Look@NanoSIMS.
%
% To make sure that all the paths are correctly defined, check the file 
% paths.m in the LANS folder. 
%
% It seems that secondary ion counts on some (newer?) systems are stored as 
% ushort (16-bit unsigned integer), whereas on some (older?) systems they are 
% stored as uint8 (8-bit unsigned integers). Perhaps this is because of the
% differences between the 32-bit and 64-bit operating systems that run the
% Cameca instrument, but I am not 100% sure. Therefore, if you experience
% problems with loading a file, e.g. the program tells you that there are
% 0 planes, it may well be that this is the cause. In that case, open the
% file read_im_file.m in the fnc folder and see whether you can hack it to 
% make things work. If not, contact LP who may be able to help you.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you can modify some of the default settings of the program.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear CELLSFILE;
global CELLSFILE;
% default name of the file with ROIs definitions
CELLSFILE = 'cells';
%CELLSFILE = 'rois';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% There should be no need to make any changes below this line.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear LANS_version LATEXBIN;
global LANS_version;
global LATEXDIR;
global MAT_EXT;
global UNZIP_COMMAND;
global EXTERNAL_IMAGEFILE;
global PDF_VIEWER;

% series of versions, last line = the current version
LANS_version = '11/11/2011';   % A nice date! :)
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
LANS_version = '2017-12-15-matlab2017b';

% name of the external image file (empty by default)
EXTERNAL_IMAGEFILE = '';

% extension of the Matlab output 
MAT_EXT = '.mat';

% Load paths to make sure all the functions can be found by Matlab.
paths;

% Welcoming message from Lubos
fprintf(1,'================================================================\n')
fprintf(1,'Look@NanoSIMS (version %s)\n',LANS_version);
fprintf(1,'Written by Lubos Polerecky <lpolerec (at) mpi-bremen.de>\n')
fprintf(1,'(2008-2012) Max-Planck Institute for Marine Microbiology, Bremen\n')
fprintf(1,'Updates by Lubos Polerecky <l.polerecky (at) uu.nl>\n')
fprintf(1,'(2013-2017) Utrecht University\n')
fprintf(1,'More info: http://nanosims.geo.uu.nl/nanosims/LANS\n')
fprintf(1,'================================================================\n')
fprintf(1,'Enjoy your work!\n')
fprintf(1,'***\nNote:\nAVOID using SPECIAL CHARACTERS in the path and file names of your data-sets. Use _ or - instead.\n');
disp('Special characters: SPACE, BRACKET ][, PARANTHESES )(, #, %, ^, &, *, /, \\, APOSTROPHE, comma, colon, semi-colon.');
fprintf(1,'***\n');

% Run the actual GUI of Look@nanoSIMS
LANS;
