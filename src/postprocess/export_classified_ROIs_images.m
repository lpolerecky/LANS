function export_classified_ROIs_images(s)
% Function for exporting images of classified ROIs in a single PDF file.
% (c) Lubos Polerecky, 02.05.2019, Utrecht University

global verbose

fprintf(1,'\n\n\n\n\nMetafile processing: export_classified_ROIs_images.m\n');

if(exist(s.base_dir)~=7 | exist(s.metafile)~=2)
    disp(['WARNING: Dataset directory or metafile does not exist. Nothing done.']);
else

    global CELLSFILE;
    global MAT_EXT;

    %% form the final output file basename
    [pathstr, name, ext] = fileparts(s.metafile);
    foutname = [pathstr,delimiter,name];
    if(~isdir(foutname))
        mkdir(foutname);
    end
    foutname = [foutname delimiter name '_' CELLSFILE '.tex'];

    %% get instructions from the meta file
    all_cell_types = regexprep(s.cellclasses,' ','');
    [id,fname,tmnt,ct,xyz,nf,all,plot3d,basedir]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);
    
    % convert tmnt from a cell (array of strings) to a matrix
    tmnt = cell2mat(tmnt);
    
    if ~isempty(basedir)
        if isdir(basedir)
            s.base_dir = basedir;
        end
    end
    
    % find out which treatments and classes should be displayed and exported
    all_treatments=str2num(s.treatments);
    all_classes=regexprep(s.cellclasses,' ','');
    all_colors=regexprep(s.cellcolors,' ','');
    % make sure that all_colors and all_classes have the same length (add
    % "white" at the end of all_colors if there are more classes than
    % colors
    n1=length(all_classes);
    n2=length(all_colors);
    if n2<n1
        all_colors = [all_colors, 'w'*ones(1,n1-n2)];
    elseif n1<n2
        all_colors = all_colors(1:n1);
    end

    for j=1:nf
        
        % include only data with treatments listed in the metafile processing GUI
        if ismember(tmnt(j),all_treatments)
            
            % load ROIs file, complain if it does not exist
            ctmp=[s.base_dir,fname{j},delimiter,s.cellfile];
            fncells = [s.base_dir, fname{j}, delimiter, s.classificationfile]; 
                
            if exist(ctmp)==2
                c=load(ctmp);
            else
                fprintf(1,'WARNING: File %s does not exist. No ROIs defined.\n',ctmp);
                c.Maskimg=[];
            end
            
            % load ROI classification file, complain if it does not exist
            [cidu,cc,cid,cnum,ss]=load_cell_classes(fncells);
            if isempty(cidu)
                fprintf(1,'WARNING: File %s does not exist. No ROI classes defined.\n',fncells);
            end            
            
            % if both files exist, construct an RGB image with each ROI
            % displayed in color based on its classification
            roi_colors = [1 0 0;
                0 1 0;
                0 0 1;
                0 1 1;
                1 0 1;
                0.95 0.95 0;
                0 0 0;
                0.95 0.95 0.95;
                1 0.5 0;
                0 0.5 1;
                1 0.65 0.8;
                0.76 0.60 0.42;
                0.13 0.55 0.13];
            if ~isempty(cidu) & ~isempty(c.Maskimg)
                roi_rgb=zeros(size(c.Maskimg,1), size(c.Maskimg,2), 3);
                % convert to a 1xN vector of char
                cidu1 = cidu(:)';
                cid1 = cid(:)';
                % colorize the roi_rgb image
                for ii=1:length(cidu1)
                    roi_colorind = strfind(all_classes,cidu1(ii));
                    if ~isempty(roi_colorind)
                        switch all_colors(roi_colorind)
                            case 'r', roi_color{ii}=roi_colors(1,:); 
                            case 'g', roi_color{ii}=roi_colors(2,:); 
                            case 'b', roi_color{ii}=roi_colors(3,:);
                            case 'c', roi_color{ii}=roi_colors(4,:);
                            case 'm', roi_color{ii}=roi_colors(5,:);
                            case 'y', roi_color{ii}=roi_colors(6,:);
                            case 'k', roi_color{ii}=roi_colors(7,:);
                            case 'w', roi_color{ii}=roi_colors(8,:);
                            case 'o', roi_color{ii}=roi_colors(9,:); % orange
                            case 'z', roi_color{ii}=roi_colors(10,:); % azure
                            case 'p', roi_color{ii}=roi_colors(11,:); % pink
                            case 'd', roi_color{ii}=roi_colors(12,:); % desert
                            case 'f', roi_color{ii}=roi_colors(13,:); % forrest green
                        end
                    else
                        roi_color{ii} = 0.25*[1 1 1]; % dark gray if class not found                        
                    end
                    ind=strfind(cid1,cidu1(ii));
                    for jj=1:length(ind)
                        ind2 = find(c.Maskimg==ind(jj));
                        for kk=1:size(roi_rgb,3)
                            rgb_kk = roi_rgb(:,:,kk);
                            rgb_kk(ind2) = roi_color{ii}(kk);
                            roi_rgb(:,:,kk) = rgb_kk;
                        end
                    end
                end
                
                % display the RGB image; use the same code as in
                % plotImageCells.m to place the figure
                mf=my_figure(114); hold off;
                if isempty(get(mf,'children'))
                    FigPos=get(0,'DefaultFigurePosition');
                    FigPos(3:4)=1.2*FigPos(4)*[1 1];
                    ScreenUnits=get(0,'Units');
                    set(0,'Units','pixels');
                    ScreenSize=get(0,'ScreenSize');
                    set(0,'Units',ScreenUnits);
                    FigPos(1)=1/2*(ScreenSize(3)-FigPos(3));
                    FigPos(2)=2/3*(ScreenSize(4)-FigPos(4));
                    fpos=FigPos;
                    set(mf,'Units','pixels');
                    set(mf,'Position',fpos);
                    set(mf,'ToolBar','none','MenuBar','none','Name','RGB');
                else
                    fpos = get(mf,'Position');
                end
                
                image(roi_rgb);
                
                % modify the axis properties to look the same as mass/ratio
                % images
                set(gca,'DataAspectRatio',[1 1 1],'xtick',[],'ytick',[]);            
                sfac=size(roi_rgb,1)/size(roi_rgb,2);
                if sfac<=1
                    set(gca,'Position',[0.1 0.06+0.5*0.9*(1-sfac) 0.8 0.9*sfac]);
                else
                    set(gca,'Position',[0.1+0.5*0.8*(1-1/sfac) 0.11 0.8/sfac 0.8]);
                end
                global additional_settings;
                
                % add title (colored names of the ROI classes)
                dx = size(roi_rgb,2)/(length(cidu1)+1);
                ypos = -size(roi_rgb,1)*0.02;
                %tit = ['\fontsize{' num2str(additional_settings.defFontSize),'}'];
                for ii=1:length(cidu1)
                    %tit = [tit, ' \color{', roi_color_name{ii}, '}', cidu1(ii)];
                    ht=text(ii*dx,ypos, cidu1(ii));
                    set(ht,'FontSize', additional_settings.defFontSize);
                    set(ht,'FontWeight', 'bold');
                    set(ht,'HorizontalAlignment','center');
                    set(ht,'Color',roi_color{ii});
                end
                %   title(tit,'interpreter','tex');
                
                % add xlabel (name of dataset)
                xlab = fname{j};
                % trim it if it's too long
                if length(xlab)>additional_settings.title_length
                    xlab=['...',xlab([(length(xlab)-additional_settings.title_length):length(xlab)])];
                end
                xlabel(xlab,'FontSize',additional_settings.defFontSize,'interpreter','none');
                
                [fnum, outname] = exportImageCells(114,[s.base_dir fname{j}],[CELLSFILE '_rgb'],'eps', ...
                            additional_settings.print_factors(7));
                all_outname{j} = outname;
                
            else
                all_outname{j} = [];
            end
            
        else
            fprintf(1,'WARNING: Treatment %d not in the list of displayed treatments. Skipping %s\n',tmnt(j),fname{j});
        end
        
    end
    fprintf(1,'Done.\n');
    
    create_pdf_output(foutname, all_outname, tmnt, s);
    
end

function create_pdf_output(fout, pdffiles, tmnt, s)
fid=fopen(fout,'w');
fprintf(fid,'\\documentclass[12pt,a4paper]{article}\n','');
fprintf(fid,'\\usepackage{graphicx}\n','');
fprintf(fid,'\\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}\n','');
fprintf(fid,'\\usepackage[bookmarksopen=true,pdfauthor=Look@NanoSIMS,pdftitle=%s]{hyperref}\n',...
    regexprep(s.metafile,'\','/'));
fprintf(fid,'\\begin{document}\n\\begin{center}\n','');
k=1;
for j=1:length(pdffiles)   
    if k==1
        fprintf(fid,'\n\\begin{tabular}{cc}\n');
        if ~isempty(pdffiles{j})
            fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s}\n&\n',j,tmnt(j),pdffiles{j});
        else
            fprintf(fid,'%d[%d]: missing\n&\n',j,tmnt(j));
        end
        k=k+1;
    elseif k==2
        if ~isempty(pdffiles{j})
            fprintf(fid,'%d[%d]: \\includegraphics[width=0.42\\textwidth]{%s}\n',j,tmnt(j),pdffiles{j});
        else
            fprintf(fid,'%d[%d]: missing\n',j,tmnt(j));
        end
        fprintf(fid,'\\end{tabular}\n');
        k=1;
    end
end 
if k==2
    fprintf(fid,'\\end{tabular}\n');
end
fprintf(fid,'\\end{center}\n\\end{document}\n');
fclose(fid);
fprintf(1,'Output written to %s\n',fout);
% compile the tex file to create a PDF output
mepstopdf(fout,'pdflatex',0);
mepstopdf(fout,'pdflatex',1);
