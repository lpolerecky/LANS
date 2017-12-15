function autoprocess_to_pdf(s)
% Function for autoprocessing datasets from the metafile. The datasets do
% need to be processed individually, but will be calculated automatically
% by this function and exported into a PDF file. For each dataset,
% 1. the raw data will be loaded;
% 2. all planes for all masses will be aligned based on the Base mass for
% alignment specified in the main GUI; 
% 3. all planes will be accumulated;
% 4. all masses will be autoscaled and exported as EPS/PDF;
% 5. the ratios specified in the metafile will be calculated (the user must
% make sure that the corresponding masses exist), scaled and exported as
% EPS/PDF;
% 6. a LaTeX document with the masses and ratios will be generated and
% compiled to PDF.
% (c) Lubos Polerecky, 01.09.2012, MPI Bremen

% get instructions from the meta file
all_cell_types = regexprep(s.cellclasses,' ','');
[id,fname,tmnt,ct,xyz,nf,all,plot3d]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);

% the output filename will have the same base-name as the metafile
if(~isempty(s.metafile))
    [fdir, fn, fext] = fileparts(s.metafile);
    doutname = [fdir delimiter fn];
    if ~exist(doutname)
        mkdir(doutname);
    end;
    foutname = [fdir, delimiter, fn, delimiter, fn, '.tex'];
else
    foutname = [];
end;

% auto-process datasets
all_filenames=[];
if ~isempty(foutname)   

    global additional_settings;
    
    for k=1:length(fname)
        
        file_counter=0;
        
        % check whether the input file exists. This is necessary if the
        % original file exists but only a subset of planes were analyzed
        imname=[s.base_dir fname{k} '.im'];
        imnamezip=[imname '.zip'];
        p=[];
        if exist(imname)
            % read the raw data
            p = read_cameca_image(imname,0,0);
        elseif exist(imnamezip)
            % read the zipped raw data
            p = read_cameca_image(imnamezip,0,0);
        else
            fprintf(1,'*** Warning: file %s does not exist.\n',imname);
            iname = fname{k};
            ind1=findstr(iname,'_p');
            ind2=findstr(iname,'-');
            if ~isempty(ind2), ind2=ind2(end); end;
            if ~isempty(ind1) & ~isempty(ind2)
                if ind2>ind1
                    iname=iname(1:(ind1-1));
                    newimname=[s.base_dir iname '.im'];
                    newimnamezip=[newimname '.zip'];
                    if exist(newimname)
                        fprintf(1,'*** But %s does.\n',newimname);
                        fprintf(1,'Loading %s\n',newimname);
                        p = read_cameca_image(newimname,1,0);
                    elseif exist(newimnamezip)
                        fprintf(1,'*** But %s does.\n',newimnamezip);
                        fprintf(1,'Loading %s\n',newimnamezip);
                        p = read_cameca_image(newimnamezip,1,0);                        
                    end;
                end;
            end;
        end;                
        
        if isempty(p)
            fprintf(1,'ERROR: Missing file %s\n',imname);
            break; 
        end;
        
        % set as not aligned
        p.planes_aligned = 0;
        
        % if the im file was processed before, the prefs.mat and
        % xyalign.mat files should exist. if this is so, use the info
        % stored in these files to accumulate the images. if they do not
        % exist, do accumulation based on the information in the
        % main GUI.
        prefsfile = [s.base_dir fname{k} filesep s.prefsfile];
        if exist(prefsfile)

            a=load(prefsfile);
            fprintf(1,'Preferences loaded from %s\n',prefsfile);
            
            images=[];
            for j=1:length(p.mass)
                switch j
                    case 1, ims = str2num(a.h.edit12.string);
                    case 2, ims = str2num(a.h.edit13.string);
                    case 3, ims = str2num(a.h.edit14.string);
                    case 4, ims = str2num(a.h.edit15.string);
                    case 5, ims = str2num(a.h.edit16.string);
                    case 6, ims = str2num(a.h.edit17.string);
                    case 7, ims = str2num(a.h.edit18.string);
                    case 8, ims = str2num(a.h.edit75.string);
                end;
                images{j}=ims;
            end;
                
            find_alignments = a.h.checkbox7.value;
            
            if find_alignments
                xyalignfile = [s.base_dir fname{k} filesep s.xyalignfile];
                if exist(xyalignfile)
                    b=load(xyalignfile);
                    xyalign = b.xyalign;
                    %images = a.images;
                    fprintf(1,'XY-alignment loaded from %s\n',xyalignfile);
                else
                    % if the xyalignfile does not exist, i.e., the im file has
                    % never been processed or was processed but without image
                    % alignment, autoalign images using the base mass       
                    
                    % identify which mass is the base mass for alignment
                    fprintf(1,'** Warning: %s file does not exist.\n** Auto-aligning planes based on %s\n',...
                        xyalignfile, s.base_mass_for_alignment);
                    bm = identifyMass(p.mass,s.base_mass_for_alignment);
                    % determine the alignment distances
                    [xyalign, images] = findimagealignments(p.im{bm}, [], 1, [1:p.width], [1:p.height],3);
                end;
            else
                xyalign=[];
                images={str2num(a.h.edit12.string)};
            end;
        
            % align and accumulate masses
            [p.accu_im, p.im]=accumulate_images(p.im, xyalign, find_alignments, p.mass, images, ones(1,length(p.mass)));
        
            if isfield(a.h,'shift_columns_rows')
                shift_columns_rows = a.h.shift_columns_rows;
            else
                shift_columns_rows = [0 0 0 0];
            end;
            
        else
            
            % if the prefs file does not exist, do the processing based on
            % the information in the main GUI 
            fprintf(1,'** WARNING: Preferences file %s does not exist.\n** Accumulating planes based on info in the main GUI.\n',prefsfile);
            images = [s.p.images{1}];
            if s.p.find_alignments
                bm = identifyMass(p.mass,s.p.alignment_mass);
                [xyalign, images] = findimagealignments(p.im{bm}, images, s.p.alignment_image, ...
                    s.p.alignmentregion_x, s.p.alignmentregion_y,s.p.maxalignment);
            else
                xyalign=zeros(length(images),2);
            end;
        
            % align and accumulate masses
            [p.accu_im, p.im]=accumulate_images(p.im, xyalign, s.p.find_alignments, p.mass, {images}, ones(1,length(p.mass)));
        
            shift_columns_rows = [0 0 0 0];
            
        end;        
                
        % shift columns or rows of the images, if needed, according to the
        % information stored in shift_columns_rows flags
        p.im = shift_columns_rows_images(p.im, shift_columns_rows);
        p.accu_im = shift_columns_rows_images(p.accu_im, shift_columns_rows);        
        
        % load cells from disk, if the file exists, otherwise set cells to zero
        cellfile = [s.base_dir fname{k} filesep s.cellfile];
        if exist(cellfile)
            a=load(cellfile);
            Maskimg = a.Maskimg;
            fprintf(1,'ROIs loaded from %s\n',cellfile);
        else
            Maskimg = [];
            fprintf(1,'** WARNING: File %s does not exist.\n** ROIs set as empty.\n',cellfile);
        end;   
        
        p.Maskimg = Maskimg;
        p.images = images;
        
        % display and export all masses as PDF
        % because there is no general information about the right scale,
        % the images will be autoscaled in the same way as if the
        % auto-scale function is chosen from the menu in the GUI
        bdir = [s.base_dir fname{k} delimiter];
        for m=1:length(p.mass)
            im=p.accu_im{m};
            % find autoscale
            as = find_image_scale(im,s.log_scale,0);
            %as=[min(im(:)) round(quantile(im(:),0.999))];
            %as = quantile(im(:), additional_settings.autoscale_quantiles);
            %fprintf(1,'Auto-scale based on quantiles [%.3f %.3f]\n',additional_settings.autoscale_quantiles);
            % if the images should be log10-transformed, then make sure the
            % min-scale is not zero
            %if s.log_scale
            %    if as(1)==0, as(1)=1; end;
            %end;
            % display image, including the cell outline if ROIs exist.
            % additionally, the data will also be exported as *.mat.
            plotImageCells(1,im,p.Maskimg,bdir,p.mass{m},...
                    [s.outline_color '-'],as,...
                    [s.include_outline 0 0 s.log_scale 0 1 0 0 0 0 1 0 0 0 1 0 0],...
                    s.bw,1,p.scale,fname{k},'',p.images,p.planes);
            % export image as EPS (and PDF)
            exportImageCells(1,bdir,p.mass{m},'eps',...
                        additional_settings.print_factors(1));
            % add the filename of the exported file to the complete list
            file_counter = file_counter+1;
            all_filenames{k,file_counter} = [bdir 'pdf' delimiter p.mass{m}];
            %['pdf' delimiter fname{k} '_' p.mass{m}];
        end;
        
        % calculate ratios specified by the metafile
        p.special = all{k};
        opt4=zeros(8,1);
        opt4(1:length(p.special))=ones(1,length(p.special));                
        if isempty(p.Maskimg)
            [R,Ra,Raim,o] = calculate_R_images(p, opt4, 0, 0,[],[5 1]);
        else
            [R,Ra,Raim,o] = calculate_R_images(p, opt4, 1, 0,[],[5 1]);
        end;
        
        % export ASCII data in ROIs, if cells defined
        if ~isempty(p.Maskimg)
            for m=1:length(o)
                a=convert_string_for_texoutput(p.special{m});
                % when 'size' is used, change the filename from 'size' to
                % 'cells'. this is necessary for compatibility reasons.
                fout=p.special{m};
                if strcmp(lower(fout),'size')
                    fout='cells';
                end;
                export_ascii_data_for_ROIS(o{m}, bdir, fout, '.dac', 'f');
            end;
        end;
        
        % display and export the calculated ratios as PDF
        for m=1:length(R)
            
            % get scaling from the GUI
            switch m
                case 1, xyscale = s.xscale1; logscale = s.logscale.x1;
                case 2, xyscale = s.yscale1; logscale = s.logscale.y1;
                case 3, xyscale = s.xscale2; logscale = s.logscale.x2;
                case 4, xyscale = s.yscale2; logscale = s.logscale.y2;
                case 5, xyscale = s.xscale3; logscale = s.logscale.x3;
                case 6, xyscale = s.yscale3; logscale = s.logscale.y3;
                otherwise, xyscale = []; logscale=0;
            end;         
            if ischar(xyscale)
                if ~isempty(findstr(xyscale,'auto'))
                    xyscale=[];
                else
                    xyscale=str2num(xyscale);
                end;
            end;
                        
            % find title
            tit = p.special{m};
            % autoscale images, if the scale not specified
            if isempty(xyscale)
                xyscale = find_image_scale(R{m},logscale,0);
                % if it's only 'size' that is to be displayed, change R{m} to
                % p.Maskimg, if it is not empty. This will, effectively,
                % display the defined ROIs.
                if strcmp(upper(tit),'SIZE') 
                    if ~isempty(p.Maskimg)
                        R{m} = p.Maskimg;
                        xyscale=[0 max(R{m}(:))];
                    else
                        R{m} = zeros(128,128);
                        xyscale=[0 1];
                    end;                    
                    logscale=0;
                end;
            else
                if 0 & logscale 
                    if xyscale(1) == 0
                        xyscale(1) = 1e-3 * xyscale(2);
                        fprintf(1,'Log-transform requested: auto-scaling minimum changed from 0 to %.3e\n',xyscale(1));
                    end;
                    xyscale = log10(xyscale);
                end;
            end;
            
            if logscale
                tit = ['log(' tit ')'];                
            end;
            
            % display the ratio image, including the cell outline if ROIs
            % exist. additionally, the data will also be exported as
            % *.mat.
            if ~isempty(R{m})
                plotImageCells(1,R{m},p.Maskimg,bdir,tit,...
                        [s.outline_color '-'],xyscale,...
                        [s.include_outline 0 0 logscale 0 1 0 0 0 0 1 0 0 0 1 0 0],...
                        s.bw,1,p.scale,fname{k},'',p.images,p.planes);            
                % export ratio image as EPS (and PDF)    
                exportImageCells(1,bdir,tit,'eps',...
                            additional_settings.print_factors(1));
                % add the filename of the exported file to the complete list
                a=convert_string_for_texoutput(tit);
                % add the ratio to the list only if it is not equal to one of
                % the masses
                if identifyMass(all{k},a)==0
                    file_counter = file_counter+1;
                    all_filenames{k,file_counter} = [bdir 'pdf' delimiter a];
                    %all_filenames{k,file_counter} = ['pdf' delimiter fname{k} '_' a];
                end;
            end;
        end;
        
    end;
    
    close(figure(1));
    
    % generate the PDF-LaTeX file   
    fid=fopen(foutname,'w');
    fprintf(fid,'\\documentclass[12pt,a4paper]{article}\n','');
    fprintf(fid,'\\usepackage{graphicx}\n','');
    fprintf(fid,'\\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}\n','');
    fprintf(fid,'\\usepackage[bookmarksopen=true,pdfauthor=Look@NanoSIMS,pdftitle=%s]{hyperref}\n',...
    regexprep(s.metafile,'\','/'));
    fprintf(fid,'\\begin{document}\n','');
    
    for k=1:size(all_filenames,1)      
        cnt = 1;
        if k>1
            fprintf(fid,'\n\\newpage\n');
        end;
        % add the section with the current filename, also the label
        s1=regexprep(fname{k},'\','/');
        s1=regexprep(s1,'_','\\_');
        s2=regexprep(fname{k},'\','/');
        s2=regexprep(s2,'_','-');
        fprintf(fid,'\n\\section{%s}\\label{%d: %s}\n',s1,k,s2);
        for jj=1:size(all_filenames,2)
            if cnt==1
                fprintf(fid,'\n\\begin{center}\n\\begin{tabular}{cc}\n');
                if ~isempty(all_filenames{k,jj})
                    s1=regexprep(all_filenames{k,jj},'\','/');
                    fprintf(fid,'\\includegraphics[width=0.40\\textwidth]{%s} &\n',s1);
                else
                    fprintf(fid,'{} &\n');
                end;
                cnt=2;
            else
                if ~isempty(all_filenames{k,jj})
                    s1=regexprep(all_filenames{k,jj},'\','/');
                    fprintf(fid,'\\includegraphics[width=0.40\\textwidth]{%s}\n',s1);
                else
                    fprintf(fid,'{}\n');
                end;
                fprintf(fid,'\\end{tabular}\n\\end{center}\n');                
                cnt=1;                
            end;
        end;
        if cnt==2
            fprintf(fid,'\\end{tabular}\n\\end{center}\n'); 
        end;
    end

    fprintf(fid,'\n\\end{document}\n');
    fclose(fid);
    
    fprintf(1,'*** Output written to %s\n',foutname);
    
    % compile the tex file to create a PDF output
    mepstopdf(foutname,'pdflatex',0);
    mepstopdf(foutname,'pdflatex',1);
    %disp('You can use pdflatex to generate a PDF file from it');
    
end;
