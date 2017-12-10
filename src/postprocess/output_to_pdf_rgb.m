function output_to_pdf_rgb(s)
% Function for generating a LaTeX+PDF file containing RGB images assembled
% from x1,y1,z1 variables specified in the meta-file. Scaling of the images
% is defined by the user. 
% (c) Lubos Polerecky, 01.12.2017, Utrecht University

base_dir = s.base_dir;
cells_file = s.cellfile;

% get instructions from the meta file
all_cell_types = regexprep(s.cellclasses,' ','');
[id,fname,tmnt,ct,xyz,nf,all,plot3d]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);

% the output filename will be stored in the directory of the same name as the the metafile;
% for each variable, the output filename will be the same as the variable
if(~isempty(s.metafile))
    [fdir, fn, fext] = fileparts(s.metafile);
    foutname = [fdir, delimiter, fn];
else
    foutname = [];
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
                    if m==1
                        fntex = ms;
                    else
                        fntex = [fntex '--' ms];
                    end;
                end;
            end;
        end;
    end;
    fntex = [foutname delimiter fntex '.tex'];        

    [fdir, fn, fext] = fileparts(fntex);
    if ~isdir(fdir)
        mkdir(fdir);
    end;

    %fid=fopen(fntex,'w');
    fid=1;
    fprintf(fid,'\\documentclass[12pt,a4paper]{article}\n');
    fprintf(fid,'\\usepackage{graphicx}\n');
    fprintf(fid,'\\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}\n');
    fprintf(fid,'\\usepackage[bookmarksopen=true,pdfauthor=Look@NanoSIMS,pdftitle=%s,pdfsubject=%s]{hyperref}\n',...
        regexprep(s.metafile,'\','/'),fn);
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
        
        for m=1:3
            ms = all{1}{m};
            switch m,
                case 1, scale=s.xscale1; lscale=s.logscale.x1;
                case 2, scale=s.yscale1; lscale=s.logscale.y1;
                case 3, scale=s.xscale2; lscale=s.logscale.x2;
            end;

            
            if ~strcmp(lower(ms),'size')
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

                    disp(['Loading data from ',mtmp]);
                    v=load(mtmp);
                        
                    h{m} = m;
                    p_name{m} = ms;
                    if isempty(scale)                        
                        p_scale{m} = v.vscale;
                    else
                        p_scale{m} = scale;
                    end;
                    Maskimg = c.Maskimg;
                    if(Maskimg==0)
                        Maskimg=ones(size(v.IM));
                    end;
                    R{m} = v.IM;
                    Raa = zeros(size(R{m}));
                    
                    % HERE
                    
                    Raim{m} = cells2image(R{m},Maskimg);
                    opt1 = [0 0 0 0 1 0 1 1]; % set opt1 to 1 for log
                    [rgb7, rgb8, xl, yl, zl, xs, ys, zs, rgb_true] = ...
                        construct_RGB_image(h,p_name,p_scale,Maskimg,R,Raim,opt1);
                
                    display_RGB_image(rgb7, rgb8, p, opt1, tit, xl, yl, zl, handles); 

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
    

