function output_to_pdf_xyz(s)
% Function for generating a LaTeX file containing images of x1:y3 variables
% specified in the meta-file. The images for each variable are stored in a 
% separate file, the scaling of the images is defined by the user.
% (c) Lubos Polerecky, 05.11.2009, MPI Bremen
% 26-03-2011 modified to add export of up to 6 variables

base_dir = s.base_dir;
cells_file = s.cellfile;

% get instructions from the meta file
all_cell_types = regexprep(s.cellclasses,' ','');
[id,fname,tmnt,ct,xyz,nf,all,plot3d]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);

% Check whether some of the ratios that are requested to be processed by
% the metafile have not been exported during the manual run of LANS (e.g.,
% the corresponding *.mat or *.dac files are missing). If this is so,
% reprocess the im files based on the information stored in the
% xyalign.mat and prefs.mat files. If cells_file exists, recalculate also
% the ratios in the ROIs.
%reprocess_im_files(fname,all{1},base_dir,cells_file);

% the output filename will be stored in the directory of the same name as the the metafile;
% for each variable, the output filename will be the same as the variable
if(~isempty(s.metafile))
    [fdir, fn, fext] = fileparts(s.metafile);
    foutname = [fdir, delimiter, fn];
else
    foutname = [];
end;

if 0
    % do this to allow user select the output file
    disp('Define output LaTeX file')
    [FileName,newdir,newext] = uiputfile('*.tex', 'Choose output LaTeX file', base_dir);
    if(FileName~=0)
        foutname = [newdir, FileName];
    else
        % default
        foutname = [];
    end;
end;

global additional_settings;
global CELLSFILE;
global MAT_EXT;

if(~isempty(foutname))
    % generate the PDF-LaTeX file for each variable
    
    fntex = [];
    for m=1:6
        if(length(all{1})>=m)
            if(~isempty(all{1}{m}))
                if(~strcmp(lower(all{1}{m}),'x') & ~strcmp(lower(all{1}{m}),'y') & ~strcmp(lower(all{1}{m}),'l2d'))
                    ms = all{1}{m};
                    ms=convert_string_for_texoutput(ms);
                    fntex{m} = [foutname delimiter ms '.tex'];
                end;
            end;
        end;
    end;
                
    for m=1:length(fntex)
        [fdir, fn, fext] = fileparts(fntex{m});
        if ~isdir(fdir)
            mkdir(fdir);
        end;
        
        fid=fopen(fntex{m},'w');
        %fid=1;
        fprintf(fid,'\\documentclass[12pt,a4paper]{article}\n');
        fprintf(fid,'\\usepackage{graphicx}\n');
        fprintf(fid,'\\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}\n');
        fprintf(fid,'\\usepackage[bookmarksopen=true,pdfauthor=Look@NanoSIMS,pdftitle=%s,pdfsubject=%s]{hyperref}\n',...
            regexprep(s.metafile,'\','/'),all{1}{m});
        fprintf(fid,'\\begin{document}\n');
        fprintf(fid,'\\begin{center}\n');
        % load the mat file from the disk, redisplay it in the user-specified scale
        % (if empty, just use the already exported EPS file) and add the code to the LaTeX file
        for j=1:nf
            % load cells image first
            ctmp=[base_dir,fname{j},delimiter,cells_file];
            if(exist(ctmp)==2)
                c=load(ctmp);
            else
                fprintf(1,'File %s does not exist. No cells defined.\n',ctmp);
                c.Maskimg=0;
            end;
            ms = all{1}{m};
            switch m,
                case 1, scale=s.xscale1; lscale=s.logscale.x1;
                case 2, scale=s.yscale1; lscale=s.logscale.y1;
                case 3, scale=s.xscale2; lscale=s.logscale.x2;
                case 4, scale=s.yscale2; lscale=s.logscale.y2;
                case 5, scale=s.xscale3; lscale=s.logscale.x3;
                case 6, scale=s.yscale3; lscale=s.logscale.y3;
            end;

            if(strcmp(lower(ms),'size'))
                
                % when variable=size, use the cells.pdf image
                ftmp=[base_dir,fname{j},delimiter,'pdf',delimiter,CELLSFILE];
                [pathstr, name, ext] = fileparts(ftmp);
                ext='.pdf';
                %ext='.png';
                
                if ~exist([pathstr,delimiter,name,ext]) | ~isempty(str2num(scale))
                    % the ROIs outlines were not yet created, so do it now
                    opt1=zeros(1,16);
                    opt1([1 6 10 11 15])=1;
                    plotImageCells(10,ones(size(c.Maskimg)),c.Maskimg,[base_dir,fname{j} delimiter],'cells',...
                        'r-',[0 1],opt1,0,0,30, fname{j}, [], [],[]);
                    addCellNumbers(10,c.Maskimg,'k');                                           
                    exportImageCells(10,[base_dir fname{j}],CELLSFILE,'eps', ...
                            additional_settings.print_factors(7));
                end;
                
                if exist([pathstr,delimiter,name,ext])   
                    ftmp=[pathstr,delimiter,name];
                else
                    ftmp=[pathstr,delimiter,lower(name)];
                end;
                
                ftmp=regexprep(ftmp,'\\','/');
                
                % add the LaTeX entry to the file
                if(mod(j,2)==1)
                    fprintf(fid,'%s\n','\begin{tabular}{cc}');            
                    %fprintf(fid,'%d: \\includegraphics[width=0.43\\textwidth]{%s} &\n',id{j},ftmp);
                    fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s} &\n',j,tmnt{j},ftmp);
                else
                    %fprintf(fid,'%d: \\includegraphics[width=0.43\\textwidth]{%s}\n',id{j},ftmp);
                    fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s}\n',j,tmnt{j},ftmp);
                    fprintf(fid,'%s\n','\end{tabular}');
                end;
            else
                title_ = ms;
                ms=convert_string_for_texoutput(ms);
                mtmp=[base_dir,fname{j},delimiter,'mat',delimiter,ms,'.mat'];

                % load matlab file containing the special image and re-print it
                % with a new scale (if the scale is defined or set to
                % auto), or use the already exported pdf file (if the scale
                % is defined as [])
                if(exist(mtmp))
                    
                    if isempty(strfind(scale,'auto'))
                        scale = str2num(scale);
                    end;
                        
                    if(~isempty(scale))
                        disp(['Loading data from ',mtmp]);
                        v=load(mtmp);
                        if(c.Maskimg==0)
                            c.Maskimg=ones(size(v.IM));
                        end;
                        if(isfield(v,'xyscale'))
                            xyscale=v.xyscale;
                        else
                            disp(['Warning: Raster not saved in the mat file. Using 50 um by default.']);
                            xyscale=50;
                        end;
                        plotImageCells(10,v.IM,c.Maskimg,[base_dir,fname{j}],title_,[s.outline_color,'-'],scale,...
                            [s.include_outline s.zero_outside 0 lscale 0 1 0 0 0 0 1 0 0 0 1],s.bw,0,...
                            xyscale,fname{j},s.cellfile,0,0);
                        exportImageCells(10,[base_dir,fname{j}],ms,'eps',...
                            additional_settings.print_factors(1));                                               
                
                        %exportImageCells(10,[base_dir,fname{j}],ms,'png');
                    end;
                    ftmp=[base_dir,fname{j},delimiter,'pdf',delimiter,ms];
                    [pathstr, name, ext] = fileparts(ftmp);
                    ext='.pdf';
                    %ext='.png';
                    if(exist([pathstr,delimiter,name,ext]))
                        ftmp=[pathstr,delimiter,name];
                    else
                        ftmp=[pathstr,delimiter,lower(name)];
                    end;
                    ftmp=regexprep(ftmp,'\\','/');
                else
                    disp(['*** File ',mtmp,' missing!']);
                    ftmp=[];
                end;
                % add the LaTeX entry to the file
                if(mod(j,2)==1)
                    fprintf(fid,'%s\n','\begin{tabular}{cc}');
                    if exist(mtmp)
                        %fprintf(fid,'%d: \\includegraphics[width=0.43\\textwidth]{%s} &\n',id{j},ftmp);
                        fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s} &\n',j,tmnt{j},ftmp);
                    else
                        fprintf(fid,'%d: missing &\n',id{j});
                    end;
                else
                    if exist(mtmp)
                        %fprintf(fid,'%d: \\includegraphics[width=0.43\\textwidth]{%s}\n',id{j},ftmp);
                        fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s}\n',j,tmnt{j},ftmp);
                    else
                        fprintf(fid,'%d: missing\n',id{j});
                    end;
                    fprintf(fid,'%s\n','\end{tabular}');
                end;
            end;
        end;        

        % add \end{tabular} if the number of entries is odd
        if(mod(j,2)==1)
            fprintf(fid,'%s\n','\end{tabular}'); 
        end;

        % finish the LaTeX output and close the files        
        fprintf(fid,'%s\n','\end{center}');
        fprintf(fid,'%s\n','\end{document}');
        fclose(fid);
    end;
    
    f10=figure(10);
    close(f10);
    pause(0.1);
    
    % compile the files with pdflatex
    for m=1:length(fntex)
        fprintf(1,'LaTeX output files generated in %s\n',fntex{m});
        mepstopdf(fntex{m},'pdflatex',0);
        mepstopdf(fntex{m},'pdflatex',1);        
    end;
    
end;
