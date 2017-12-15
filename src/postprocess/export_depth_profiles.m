function export_depth_profiles(s)
% Function for exporting depth profiles of masses and ratios in ROIs from
% datasets specified in the metafile. For each dataset,
% 1. the raw data will be loaded;
% 2. all, or specific, planes will be accumulated;
% (c) Lubos Polerecky, 28.01.2017, Utrecht University

% get instructions from the meta file
all_cell_types = regexprep(s.cellclasses,' ','');
[id,fname,tmnt,ct,xyz,nf,all,plot3d, basedir, image_range]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);

% the output filename will have the same base-name as the metafile
if(~isempty(s.metafile))
    [fdir, fn, fext] = fileparts(s.metafile);
    doutname = [fdir delimiter fn];
    if ~exist(doutname)
        mkdir(doutname);
    end;
    foutname = [fdir, delimiter, fn, delimiter, fn];
else
    foutname = [];
end;

% auto-process datasets
all_filenames=[];
if ~isempty(foutname)   

    global additional_settings;
    
    fprintf(1,'Displaying depth profiles in ROIs for datasets in a metafile.\n');
    
    
    want_to_be_asked = 0;
    answer = questdlg('Do you want to pause after each dataset?','Make your choice','Yes','No','Yes');
    if strcmp(answer,'Yes')
        want_to_be_asked = 1;
    end;
    
    final_data_cnt = zeros(1,length(fname));
    final_data = [];
    for ii=1:length(all{1})
        final_data{ii} = [];
    end;
    for k=1:length(fname)
        
        file_counter=0;
        
        % check whether the input file exists. This is necessary if the
        % original file exists but only a subset of planes were analyzed
        imname=[s.base_dir fname{k} '.im']; 
        imnamezip=[imname '.zip'];
        p=[];
        if exist(imname)
            p = read_cameca_image(imname,0,0);
        elseif exist(imnamezip)
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
                % force image_range from the metafile, if not empty
                b=eval(image_range{k});
                if ~isempty(b)
                    images{j}=b;
                end;
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
            fprintf(1,'** Warning: Preferences file %s does not exist.\n** Accumulating planes based on info in the main GUI.\n',prefsfile);
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
            fprintf(1,'** Warning: File %s does not exist.\n** ROIs set as empty.\n',cellfile);
        end;   
        
        p.Maskimg = Maskimg;
        p.images = images;        
            
        % load cells classes from disk, if the file exists, otherwise
        % classify all rois as 'i'
        cellfile = [s.base_dir fname{k} filesep s.classificationfile];
        fprintf(1,'ROI classes loaded from %s\n',cellfile);
        [cidu,cc,cid,cnum,ss]=load_cell_classes(cellfile);
        if isempty(cid)
            % determine the number of rois and classes based on the Maskimg data
            Nrois = length(setdiff(unique(Maskimg(:)),0));
            cid = char('i'*ones(Nrois,1));
            cnum = [1:Nrois]';
        end;
        
        % all important information has been loaded, so now we can proceed
        % with extracting and plotting the depth profiles for each mass and
        % variable in each ROI
        
        % accumulate masses in cells over all pixels, but separately in
        % each plane
        [m2, dm2]=accumulate_masses_in_cells(p.im,p.Maskimg,p.im,p.images);
        
        [out pdfout f30] = display_depth_profiles_ROIS(m2,dm2,cid,cnum,p.images,p.mass,p.Maskimg,all{k},p.filename,s.cellclasses);        
        
        % export data, gather some of it also for final plotting        
        for ii=1:length(all{k})
            if ~isempty(pdfout{ii})
                a=convert_string_for_texoutput(all{k}{ii});
                fout=[foutname '-' a '-rois-z.dat'];                
                if k==1
                    fid=fopen(fout,'w');
                    fprintf(fid,'#id\tfile\ttreatment\tcell_type\tcell_id\tmean\tstd\t2.5pc\t97.5pc\n');
                else
                    fid=fopen(fout,'a');
                end;
                [cids,icid]=sort(cid,1,'descend');
                for jj=1:size(out{ii},1)
                    fprintf(fid,'%d\t%s\t%d\t%c\t%d\t%.4e\t%.4e\t%.4e\t%.4e\n',...
                        k,fname{k},tmnt{k},cid(icid(jj)),cnum(icid(jj)),out{ii}(icid(jj),:));
                    final_data_cnt(k) = final_data_cnt(k) + 1;
                    out_final_data = [k tmnt{k} double(cid(icid(jj))) cnum(icid(jj)) out{ii}(icid(jj),:)];
                    if isempty(final_data{ii})
                        final_data{ii} = out_final_data;
                    else
                        final_data{ii} = [final_data{ii}; out_final_data];
                    end;
                end;
                fclose(fid);
                fprintf(1,'Output written/appended to %s\n',fout);
            end;
        end;
        
        % generate PDF-LaTeX output
        for ii=1:length(all{k})
            
            if ~isempty(pdfout{ii})

                a=convert_string_for_texoutput(all{k}{ii});
                fout=[foutname '-' a '-rois-z.tex'];
                if k==1

                    fid=fopen(fout,'w');
                    fprintf(fid,'\\documentclass[12pt,a4paper]{article}\n','');
                    fprintf(fid,'\\usepackage{graphicx}\n','');
                    fprintf(fid,'\\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}\n','');
                    fprintf(fid,'\\usepackage[bookmarksopen=true,pdfauthor=Look@NanoSIMS,pdftitle=%s]{hyperref}\n',...
                    regexprep(s.metafile,'\','/'));
                    fprintf(fid,'\\begin{document}\n','');

                else
                    fid=fopen(fout,'a');
                end;

                if k>1
                    fprintf(fid,'\n\\newpage\n');
                end;

                % add the section with the current filename, also the label
                s1=regexprep(fname{k},'\','/');
                s1=regexprep(s1,'_','\\_');
                s2=regexprep(fname{k},'\','/');
                s2=regexprep(s2,'_','-');
                fprintf(fid,'\n\\section{\\normalsize %s}\\label{%d: %s}\n',s1,k,s2);
                fprintf(fid,'\n\\begin{center}\n');
                s1=regexprep(pdfout{ii},'\','/');
                fprintf(fid,'\\includegraphics[width=0.99\\textwidth]{%s}\n',s1);
                fprintf(fid,'\\end{center}\n');                
                fclose(fid);

            end;
            
        end;
        
        if want_to_be_asked
            input('Check the graphs, then press enter to continue.');
        end;
        
        % close all figures
        for ii=1:length(f30)
            close(f30{ii});
        end;            
        
    end;
    
    for ii=1:length(all{k})
        if ~isempty(pdfout{ii})
            a=convert_string_for_texoutput(all{k}{ii});
            fout=[foutname '-' a '-rois-z.tex'];
            fid=fopen(fout,'a');
            fprintf(fid,'\n\\end{document}\n');
            fprintf(1,'*** Output written to %s\n',fout);
            % compile the tex file to create a PDF output
            mepstopdf(fout,'pdflatex',0);
            mepstopdf(fout,'pdflatex',1);
        end;
    end;
    
    % plot final data
    fig=plot_final_data(final_data, all{1}, s);
    fout=[foutname '-rois-z-avg-sd-cov.eps'];
    print_figure(fig,fout,additional_settings.print_factors(3));
    % create also PDF file, so that it can be included by pdflatex 
    mepstopdf(fout,'epstopdf',0,1,0);
    
    fprintf(1,'Done.\n');
                
    % compile the tex file to create a PDF output
    %mepstopdf(foutname,'pdflatex',0);
    %mepstopdf(foutname,'pdflatex',1);
    %disp('You can use pdflatex to generate a PDF file from it');
    %end;
    
end;

function fig=plot_final_data(d,ratios,s)
fprintf(1,'Plotting mean +/- SD and COV values ... ');
fig=figure;
Nd = length(d);
tmnt = str2num(s.treatments);
tmnts = double(s.symbols);
tmnts = char(tmnts(tmnts>double(' ')));
classes = s.cellclasses;
for k=1:Nd    
    dd=d{k};
    cnt=0;
    for ii=1:size(dd,1)
        t=dd(ii,2);
        c=char(dd(ii,3));
        roiid=dd(ii,4);
        m=dd(ii,5);
        sd=dd(ii,6);
        pc=dd(ii,7:8);
        ci = findstr(classes,c);
        ti = find(tmnt==t);
        if ~isempty(ci) & ~isempty(ti)
            cnt=cnt+1;
            % plot mean +/- SD
            subplot(2,Nd,k);
            if cnt==1
                hold off;
            else
                hold on;
            end;
            errorbar(cnt,m,sd,tmnts(ti),'MarkerSize',8,'Color',s.cellcolors(ci));
            % plot coefficient of variation
            subplot(2,Nd,k+Nd);            
            if cnt==1
                hold off;
            else
                hold on;
            end;
            plot(cnt,sd/m,tmnts(ti),'MarkerSize',12,'Color',s.cellcolors(ci));   
            text(cnt,sd/m,num2str(roiid),'HorizontalAlignment','center','FontSize',8);
        end;
    end;
    subplot(2,Nd,k);
    title(ratios{k});
    ylabel('mean +/- SD');
    xlim([0 cnt+1]);
    subplot(2,Nd,k+Nd);
    ylabel('COV = SD/mean');
    ylim2=ylim;
    ylim([0 ylim2(2)]);
    xlim([0 cnt+1]);
end;
fprintf(1,'Done.\n');
a=0;