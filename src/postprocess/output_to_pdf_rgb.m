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
    % export variable image to pdf and tif for each file in the metafile
    
    rgb7_fname = [];
    rgb8_fname = [];
    xl = [];
    yl = [];
    zl = [];
    
    rgb_big = [];
    rgba_big = [];
    
    % load the mat file from the disk, redisplay it in the user-specified scale
    for j=1:nf
        
        % load cells image first
        ctmp=[base_dir,fname{j},delimiter,cells_file];
        if(exist(ctmp)==2)
            c=load(ctmp); fprintf(1,'ROIs loaded from %s.\n',ctmp);
        else
            fprintf(1,'File %s does not exist. No ROIs defined.\n',ctmp);
            c.Maskimg=[];
        end;
        
        % load and scale the first 3 masses
        Nrgb = min([3 length(all{1})]);
        for m=1:Nrgb
            
            ms = all{1}{m};
            R{m} = [];
            Ra{m} = [];
            title_ = ms;
            
            % load accumulated ion counts from the mat file
            if ~strcmp(lower(ms),'size')                
                ms=convert_string_for_texoutput(ms);
                mtmp=[base_dir,fname{j},delimiter,'mat',delimiter,ms,'.mat'];
                if exist(mtmp)
                    fprintf(1,'Loading data from %s ...',mtmp);
                    v=load(mtmp); fprintf(1,'done.\n')
                    R{m} = v.IM;
                else
                    fprintf(1,'WARNING: File %s does not exist.\nRe-run auto-process datasets from Tools menu.\n',mtmp);
                end;
            else
                fprintf(1,'WARNING: size not supported.\n');
            end;
                  
            % find the scale
            switch m,
                case 1, scale=s.xscale1; lscale=s.logscale.x1; xl = title_;
                case 2, scale=s.yscale1; lscale=s.logscale.y1; yl = title_;
                case 3, scale=s.xscale2; lscale=s.logscale.x2; zl = title_;
            end;

            if isempty(strfind(scale,'auto'))
                scale = str2num(scale);
            end;

                        
            if isempty(scale) | ~isempty(strfind(scale,'auto'))
                scale = find_image_scale(R{m}, 0, additional_settings.autoscale_quantiles, lscale, 0, title_);
            end;
            
            % average values over ROI pixels
            Ra{m} = zeros(size(R{m}));
            if ~isempty(R{m}) & ~isempty(c.Maskimg)
                rois = setdiff(unique(c.Maskimg(:)),0);
                nrois = length(rois);                
                for ii=1:nrois
                    ind = find(c.Maskimg==rois(ii));
                    Ra{m}(ind) = mean(R{m}(ind));
                end;
            end;
            
            if lscale
                itmp1=R{m};
                ind1=find(itmp1>0);
                ind2=find(itmp1<=0);
                itmp1(ind1)=log10(itmp1(ind1));
                itmp1(ind2)=0;
                R{m}=itmp1;
                %R{m} = log10(R{m});
                itmp1=Ra{m};
                ind1=find(itmp1>0);
                ind2=find(itmp1<=0);
                itmp1(ind1)=log10(itmp1(ind1));
                itmp1(ind2)=0;
                Ra{m}=itmp1;                
                %Ra{m} = log10(Ra{m});
                scale = log10(scale);
            end;
            
            % rescale R and Ra so that min/max = 0/1
            R{m} = (R{m}-scale(1))/(diff(scale));
            ind = find(R{m}<0);
            R{m}(ind) = zeros(size(ind));
            ind = find(R{m}>1);
            R{m}(ind) = ones(size(ind));            
            Ra{m} = (Ra{m}-scale(1))/(diff(scale));
            ind = find(Ra{m}<0);
            Ra{m}(ind) = zeros(size(ind));
            ind = find(Ra{m}>1);
            Ra{m}(ind) = ones(size(ind));
                             
        end;
        
        % construct the RGB images
        rgb7 = zeros(size(R{1},1),size(R{1},2),3);
        rgb8 = rgb7;
        for m=1:Nrgb
            rgb7(:,:,m)=R{m};
            rgb8(:,:,m)=Ra{m};
        end;
        
        % prepare the structures required by display_RGB_image
        p.scale = v.xyscale;
        p.Maskimg = c.Maskimg;
        p.fdir = [base_dir,fname{j},delimiter];
        tit = p.fdir;
        opt = zeros(1,16);
        opt([7 8 11 15])=1;
        opt(1) = s.include_outline;
        [rgb7_fname{j} rgb8_fname{j}] = display_RGB_image(rgb7, rgb8, p, opt, tit, xl, yl, zl, s.outline_color);
        
        rgb_big{j} = rgb7;
        rgba_big{j} = rgb8;
        
    end;
    
end;

if 0
    % close figures
    f37=figure(37); close(f37);
    f36=figure(36); close(f36);
    pause(0.1);
end;

if(~isempty(foutname))
    % generate the PDF-LaTeX file
    
    for ii=1:2
        
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

        if ii==1
            fntex = [foutname delimiter fntex '-rgb.tex'];
            rgb_fname = rgb7_fname;
        else
            fntex = [foutname delimiter fntex '-rgba.tex'];
            rgb_fname = rgb8_fname;
        end;

        [fdir, fn, fext] = fileparts(fntex);
        if ~isdir(fdir)
            mkdir(fdir);
        end;

        fid=fopen(fntex,'w');
        %fid=1;
        fprintf(fid,'\\documentclass[12pt,a4paper]{article}\n');
        fprintf(fid,'\\usepackage{graphicx}\n');
        fprintf(fid,'\\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}\n');
        fprintf(fid,'\\usepackage[bookmarksopen=true,pdfauthor=Look@NanoSIMS,pdftitle=%s,pdfsubject=%s]{hyperref}\n',...
            regexprep(s.metafile,'\','/'),fn);
        fprintf(fid,'\\begin{document}\n');

        fprintf(fid,'\\begin{center}\n');
        
        for j=1:nf
            % add the LaTeX entry to the file
            if(mod(j,2)==1)
                fprintf(fid,'%s\n','\begin{tabular}{cc}');
                if exist(rgb_fname{j})
                    %fprintf(fid,'%d: \\includegraphics[width=0.43\\textwidth]{%s} &\n',id{j},ftmp);
                    fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s} &\n',j,tmnt{j},rgb_fname{j});
                else
                    fprintf(fid,'%d: missing &\n',id{j});
                end;
            else
                if exist(rgb_fname{j})
                    %fprintf(fid,'%d: \\includegraphics[width=0.43\\textwidth]{%s}\n',id{j},ftmp);
                    fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s}\n',j,tmnt{j},rgb_fname{j});
                else
                    fprintf(fid,'%d: missing\n',id{j});
                end;
                fprintf(fid,'%s\n','\end{tabular}');
            end;        
        end;        
        
        % add \end{tabular} if the number of entries is odd
        if(mod(j,2)==1)
            fprintf(fid,'%s\n','\end{tabular}'); 
        end;

        fprintf(fid,'%s\n','\end{center}');
        % finish the LaTeX output and close the files            
        fprintf(fid,'%s\n','\end{document}');
        fclose(fid);
        
        % compile the files with pdflatex
        fprintf(1,'LaTeX output files generated in %s\n',fntex);
        mepstopdf(fntex,'pdflatex',0);
        mepstopdf(fntex,'pdflatex',1);
    
        % assemble rgb_big into a big matrix and export it as tif
        if ii==1
            rgb = assemble_rgb_big(nf, rgb_big);
        else
            rgb = assemble_rgb_big(nf, rgba_big);
        end;
        tif_out = [fdir delimiter fn '.tif'];
        Nbits = 8;
        if Nbits==16
            imwrite(uint16(rgb*(2^Nbits-1)),tif_out);
        elseif Nbits==8
            imwrite(uint8(rgb*(2^Nbits-1)),tif_out);
        end
        fprintf(1,'%d-bit RGB image saved as %s\n', Nbits, tif_out);
    end
end


function rgb = assemble_rgb_big(nf, rgb_big)
% assemble the rgb images into a one large single image and export it as
% tif
rgb=[];
nfx = round(sqrt(nf));
nfy = ceil(nf/nfx);
prompt = {sprintf('%d files in the metafile.\nEnter number of columns in the TIF image assembly',nf)};
dlg_title = 'Final TIF formatting';
num_lines = 1;
defaultans = {num2str(nfy)};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
[val status] = str2num(answer{1});
if status
    nfx=val;
    nfy=ceil(nf/nfx);
end
k=0;
for ii=1:nfy
    rgb1 = [];
    for jj=1:nfx
        k=k+1;
        if k<=length(rgb_big)
            if jj==1
                rgb1 = [rgb1 rgb_big{k}];
            else             
                rgb_big_k = rgb_big{k};
                if size(rgb_big_k,1) >  size(rgb1,1)
                    tmp = zeros(size(rgb_big_k,1),size(rgb1,2),size(rgb1,3));
                    tmp(1:size(rgb1,1),1:size(rgb1,2),1:size(rgb1,3)) = rgb1;
                    rgb1 = tmp;
                elseif size(rgb_big_k,1) <  size(rgb1,1)
                    tmp = zeros(size(rgb1,1),size(rgb_big_k,2),size(rgb_big_k,3));
                    tmp(1:size(rgb_big_k,1),1:size(rgb_big_k,2),1:size(rgb_big_k,3)) = rgb_big_k;
                    rgb_big_k = tmp;
                end
                %if size(rgb_big{k},1) == size(rgb1,1)
                rgb1 = [rgb1 rgb_big_k];
                %else
                %    fprintf(1,'WARNING: data #%d skipped due to size mismatch.\n',k);
                %end
            end
        end
    end
    if ii==1
        rgb = rgb1;
    else
        if size(rgb1,2)<size(rgb,2)
            rgb_add = zeros(size(rgb1,1),size(rgb,2));
            rgb_add(1:size(rgb1,1),1:size(rgb1,2),1:size(rgb1,3)) = rgb1;
        else
            rgb_add = rgb1;
        end
        if size(rgb_add,2)>size(rgb,2)
            tmp = zeros(size(rgb,1),size(rgb_add,2),size(rgb,3));
            tmp(1:size(rgb,1),1:size(rgb,2),1:size(rgb,3)) = rgb;
            rgb=tmp;
        elseif size(rgb,2)>size(rgb_add,2)
            tmp = zeros(size(rgb_add,1),size(rgb,2),size(rgb_add,3));
            tmp(1:size(rgb_add,1),1:size(rgb_add,2),1:size(rgb_add,3)) = rgb_add;
            rgb_add=tmp;
        end
        rgb = [rgb; rgb_add];
    end
end
    


    