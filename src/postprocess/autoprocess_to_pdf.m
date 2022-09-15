function autoprocess_to_pdf(s, handles)
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
[id,fname,tmnt,ct,xyz,nf,all,plot3d, basedir, image_range]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);

% the output filename will have the same base-name as the metafile
if(~isempty(s.metafile))
    [fdir, fn, fext] = fileparts(s.metafile);
    doutname = [fdir delimiter fn];
    if ~isfolder(doutname)
        mkdir(doutname);
        fprintf(1,'Output folder %s created.\n', doutname);
    end
    foutname = [fdir, delimiter, fn, delimiter, fn, '.tex'];
else
    foutname = [];
end

% auto-process datasets
all_filenames=[];
if ~isempty(foutname)   

    global additional_settings;
    
    for k=1:length(fname)
        
        file_counter=0;
        
        % check whether the input file exists. This is necessary if the
        % original file exists but only a subset of planes were analyzed
        imnamemat=[s.base_dir fname{k} '.mat'];
        imname=[s.base_dir fname{k} '.im'];
        imnamezip=[imname '.zip'];
        full_processed_data_loaded=0;
        p=[];
        if isfile(imnamemat)
            fprintf(1,'Loading data from %s ... ',imnamemat);
            load(imnamemat);
            fprintf(1,'Done.\n');
            full_processed_data_loaded=1;
        elseif isfile(imname)
            % read the raw data
            p = read_cameca_image(imname,0,0);
        elseif isfile(imnamezip)
            % read the zipped raw data
            p = read_cameca_image(imnamezip,0,0);
        else
            fprintf(1,'*** Warning: none of the files exist:\n%s\n%s\n%s\n',...
                imnamemat, imname,imnamezip);
            iname = fname{k};
            ind1=findstr(iname,'_p');
            ind2=findstr(iname,'-');
            if ~isempty(ind2), ind2=ind2(end); end
            if ~isempty(ind1) && ~isempty(ind2)
                if ind2>ind1
                    iname=iname(1:(ind1-1));
                    newimname=[s.base_dir iname '.im'];
                    newimnamezip=[newimname '.zip'];
                    if isfile(newimname)
                        fprintf(1,'*** But %s does.\n',newimname);
                        fprintf(1,'Loading %s\n',newimname);
                        p = read_cameca_image(newimname,1,0);
                    elseif isfile(newimnamezip)
                        fprintf(1,'*** But %s does.\n',newimnamezip);
                        fprintf(1,'Loading %s\n',newimnamezip);
                        p = read_cameca_image(newimnamezip,1,0);                        
                    end
                end
            end
        end        
        
        if isempty(p)
            fprintf(1,'ERROR: Missing file %s\n',imname);
            break; 
        end
                
        if ~full_processed_data_loaded
            
            if handles.dtc.apply_dtc || handles.dtc.apply_QSA            
                % apply dead-time correction
                p.im = apply_dtc(p.im, handles.dtc, p.dwell_time);
            end
            
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
                        case 1, ims = str2num(a.h.edit12.string); mname = a.h.edit3.string;
                        case 2, ims = str2num(a.h.edit12.string); mname = a.h.edit4.string;
                        case 3, ims = str2num(a.h.edit12.string); mname = a.h.edit5.string;
                        case 4, ims = str2num(a.h.edit12.string); mname = a.h.edit6.string;
                        case 5, ims = str2num(a.h.edit12.string); mname = a.h.edit7.string;
                        case 6, ims = str2num(a.h.edit12.string); mname = a.h.edit8.string;
                        case 7, ims = str2num(a.h.edit12.string); mname = a.h.edit9.string;
                        case 8, ims = str2num(a.h.edit12.string); mname = a.h.edit74.string;
                    end
                    images{j}=ims;
                    if ~strcmp(p.mass{j},mname)
                        fprintf(1,'WARNING: Mass %s in the loaded IM file renamed to %s based on info in %s\n',p.mass{j},mname,prefsfile);
                        p.mass{j} = mname;
                    end
                end

                find_alignments = a.h.checkbox7.value;

                xyalign = [];
                tforms = [];

                if find_alignments
                    xyalignfile = [s.base_dir fname{k} filesep s.xyalignfile];

                    if exist(xyalignfile)
                        % load the previously calculated and stored alignment data
                        b=load(xyalignfile);
                        fprintf(1,'XY-alignment loaded from %s\n',xyalignfile);
                        if isfield(b,'xyalign')
                            xyalign = b.xyalign;           
                        end
                        if isfield(b,'tforms')
                            tforms = b.tforms;
                        end                    
                    else
                        % if the xyalignfile does not exist, i.e., the im file has
                        % never been processed or was processed but without image
                        % alignment, autoalign images using the base mass       

                        % identify which mass is the base mass for alignment
                        fprintf(1,'** Warning: %s file does not exist.\n** Auto-aligning planes based on %s\n',...
                            xyalignfile, s.base_mass_for_alignment);
                        bm = identifyMass(p.mass,s.base_mass_for_alignment);
                        % determine the alignment data
                        %[xyalign, images] = findimagealignments(p.im{bm}, [], 1, [1:p.width], [1:p.height],3);
                        % use the new algorithm for image alignment                                        
                        [tforms, images, xyalign, ~, ~] = findimagealignments2(p.im{bm},[],[1:p.width],[1:p.height],0);

                    end
                else
                    images={str2num(a.h.edit12.string)};
                end

                % align only selected planes based on info in metafile
                if ~isempty(str2num(image_range{k}))
                    for ik=1:length(images)
                        images{ik} = str2num(image_range{k});
                    end
                end

                % align and accumulate masses
                if ~p.planes_aligned && ~isempty(xyalign)
                    if ~isempty(tforms)
                        [p.accu_im, p.im]=accumulate_images2(p.im, tforms, p.mass, images, ones(1,length(p.mass)));
                    else
                        [p.accu_im, p.im]=accumulate_images(p.im, xyalign, p.mass, images, ones(1,length(p.mass)));
                    end
                    p.planes_aligned = 1;
                else
                    [p.accu_im, p.im]=accumulate_images(p.im, xyalign, find_alignments, p.mass, images, zeros(1,length(p.mass)));
                end

                if isfield(a.h,'shift_columns_rows')
                    shift_columns_rows = a.h.shift_columns_rows;
                else
                    shift_columns_rows = [0 0 0 0];
                end

            else

                % if the prefs file does not exist, do the processing based on
                % the information in the main GUI 
                fprintf(1,'** WARNING: Preferences file %s does not exist.\n** Accumulating planes based on info in the main GUI.\n',prefsfile);
                images = [s.p.images{1}];
                if s.p.find_alignments
                    bm = identifyMass(p.mass,s.p.alignment_mass);
    %                [xyalign, images] = findimagealignments(p.im{bm}, images, s.p.alignment_image, ...
    %                    s.p.alignmentregion_x, s.p.alignmentregion_y,s.p.maxalignment);
                    [tforms, images, xyalign, ~, ~] = findimagealignments2(p.im{bm},images,s.p.alignmentregion_x, s.p.alignmentregion_y,0);
                else
                    xyalign=zeros(length(images),2);
                    tforms = [];
                end

                % align and accumulate masses
    %            [p.accu_im, p.im]=accumulate_images(p.im, xyalign, s.p.find_alignments, p.mass, {images}, ones(1,length(p.mass)));

                % align and accumulate masses
                if ~isempty(xyalign)
                    if ~isempty(tforms)
                        [p.accu_im, p.im]=accumulate_images2(p.im, tforms, p.mass, {images}, ones(1,length(p.mass)));
                        %[p.accu_im, p.im]=accumulate_images2(p.im, tforms, p.mass, [], ones(1,length(p.mass)));
                    else
                        [p.accu_im, p.im]=accumulate_images(p.im, xyalign, p.mass, {images}, ones(1,length(p.mass)));
                        %[p.accu_im, p.im]=accumulate_images(p.im, xyalign, p.mass, [], ones(1,length(p.mass)));
                    end
                end

                shift_columns_rows = [0 0 0 0];

            end        

            % shift columns or rows of the images, if needed, according to the
            % information stored in shift_columns_rows flags
            p.im = shift_columns_rows_images(p.im, shift_columns_rows);
            p.accu_im = shift_columns_rows_images(p.accu_im, shift_columns_rows);        

        else
            
            images = p.images;
            % figure out the correct amount of images that were originally
            % measured and accumulated in the file
            for j=1:length(images)
                if isempty(images{j})
                    images{j} = p.planes;
                end
                % identify how many planes were in blocks
                ind1=regexp(imnamemat,'b*');
                ind2=regexp(imnamemat,'.mat');
                if ~isempty(ind1)
                    planes_per_block = str2num( imnamemat((ind1(end)+1):(ind2-1)) );
                else
                    planes_per_block = 1;
                end
                images{j} = [1:planes_per_block*length(images{j})];
            end
            
        end
        
        % load cells from disk, if the file exists, otherwise set cells to zero
        cellfile = [s.base_dir fname{k} filesep s.cellfile];
        if exist(cellfile)
            a=load(cellfile);
            Maskimg = a.Maskimg;
            fprintf(1,'ROIs loaded from %s\n',cellfile);
        else
            Maskimg = [];
            fprintf(1,'** WARNING: File %s does not exist.\n** ROIs set as empty.\n',cellfile);
        end
        
        p.Maskimg = Maskimg;
        p.images = images;
        
        fig173 = 173; % "random" figure number where all the images will be displayed
        
        % display and export all masses as PDF
        % because there is no general information about the right scale,
        % the images will be autoscaled in the same way as if the
        % auto-scale function is chosen from the menu in the GUI
        bdir = [s.base_dir fname{k} delimiter];
        for m=1:length(p.mass)
            im=p.accu_im{m};
            % find autoscale
            as = find_image_scale(im,0,additional_settings.autoscale_quantiles,s.log_scale,0,p.mass{m});
            % display image, including the cell outline if ROIs exist.
            % additionally, the data will also be exported as *.mat.
            plotImageCells(fig173,im,p.Maskimg,bdir,p.mass{m},...
                    [s.outline_color '-'],as,...
                    [s.include_outline 0 0 s.log_scale 0 1 0 0 0 0 1 0 0 0 1 0 0],...
                    s.bw,1,p.scale,fname{k},'',p.images,p.planes);
            % export image as EPS (and PDF)
            exportImageCells(fig173,bdir,p.mass{m},'eps',...
                        additional_settings.print_factors(1));
            % add the filename of the exported file to the complete list
            file_counter = file_counter+1;
            all_filenames{k,file_counter} = [bdir 'pdf' delimiter p.mass{m}];
            %['pdf' delimiter fname{k} '_' p.mass{m}];
        end
        
        % calculate ratios specified by the metafile
        p.special = all{k};
        opt4=zeros(8,1);
        opt4(1:length(p.special))=ones(1,length(p.special));                
        if isempty(p.Maskimg)
            [R,~,~,o] = calculate_R_images(p, opt4, 0, 0,[],[5 1]);
        else
            [R,~,~,o] = calculate_R_images(p, opt4, 1, 0,[],[5 1]);
        end
        
        % export ASCII data in ROIs, if cells defined
        if ~isempty(p.Maskimg)
            for m=1:length(o)
                a=convert_string_for_texoutput(p.special{m});
                % when 'size' or 'pixel' is used, change the filename from 'size' to
                % 'ROIs'. this is necessary for compatibility reasons.
                fout=p.special{m};
                if strcmpi(fout,'size') || strcmpi(fout,'pixel')
                    fout='ROIs';
                end
                export_ascii_data_for_ROIS(o{m}, bdir, fout, '.dac', 'f');
            end
        end
        
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
            end    
            if ischar(xyscale)
                if ~isempty(findstr(xyscale,'auto'))
                    xyscale=[];
                else
                    xyscale=str2num(xyscale);
                end
            end
                        
            % find title
            tit = p.special{m};
            if strcmpi(tit,'SIZE') || strcmpi(tit,'PIXEL')
                tit = 'ROIs';
            end
            % autoscale images, if the scale not specified
            if isempty(xyscale)
                xyscale = find_image_scale(R{m},0,additional_settings.autoscale_quantiles,logscale,0,tit);
                % if it's only 'size' that is to be displayed, change R{m} to
                % p.Maskimg, if it is not empty. This will, effectively,
                % display the defined ROIs.
                if strcmpi(tit,'rois')
                    if ~isempty(p.Maskimg)
                        R{m} = p.Maskimg;
                        xyscale=[0 max(R{m}(:))];
                    else
                        R{m} = zeros(128,128);
                        xyscale=[0 1];
                    end                    
                    logscale=0;
                end
            end                        
            
            % display the ratio image, including the cell outline if ROIs
            % exist. additionally, the data will also be exported as
            % *.mat. Note, if logscale==1, the actual data, not
            % log-transformed data, is saved!
            if ~isempty(R{m})
                plotImageCells(fig173,R{m},p.Maskimg,bdir,tit,...
                        [s.outline_color '-'],xyscale,...
                        [s.include_outline 0 0 logscale 0 1 0 0 0 0 1 0 0 0 1 0 0],...
                        0,1,p.scale,fname{k},'',p.images,p.planes);            
                % if logscale==1, the exported eps/pdf file will contain
                % log()
                if logscale
                    tit = ['log(' tit ')'];                
                end
                % export ratio image as EPS (and PDF)    
                exportImageCells(fig173,bdir,tit,'eps',...
                            additional_settings.print_factors(1));
                % add the filename of the exported file to the complete list
                a=convert_string_for_texoutput(tit);
                % add the ratio to the list only if it is not equal to one of
                % the masses
                if identifyMass(all{k},a)==0
                    file_counter = file_counter+1;
                    all_filenames{k,file_counter} = [bdir 'pdf' delimiter a];
                    %all_filenames{k,file_counter} = ['pdf' delimiter fname{k} '_' a];
                end
            end
        end
        
    end
    
    close(figure(fig173));
    
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
        end
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
                end
                cnt=2;
            else
                if ~isempty(all_filenames{k,jj})
                    s1=regexprep(all_filenames{k,jj},'\','/');
                    fprintf(fid,'\\includegraphics[width=0.40\\textwidth]{%s}\n',s1);
                else
                    fprintf(fid,'{}\n');
                end
                fprintf(fid,'\\end{tabular}\n\\end{center}\n');                
                cnt=1;                
            end
        end
        if cnt==2
            fprintf(fid,'\\end{tabular}\n\\end{center}\n'); 
        end
    end

    fprintf(fid,'\n\\end{document}\n');
    fclose(fid);
    
    fprintf(1,'*** Output written to %s\n',foutname);
    
    % compile the tex file to create a PDF output
    mepstopdf(foutname,'pdflatex',0);
    mepstopdf(foutname,'pdflatex',1);
    %disp('You can use pdflatex to generate a PDF file from it');
    
end
