function display_ratios_through_mask(handles, export_graphics_flag, accum_flag, update_special_scale)

p = load_masses_parameters(handles);

global additional_settings;

[opt1,opt3,opt4]=load_options(handles,0);

% if Maskimg was not defined yet, set it to zero here
if ~isfield(p,'Maskimg')
    p.Maskimg=zeros(size(p.im{1},1),size(p.im{1},2));
else
    % always load it from the last saved cells file
    global CELLSFILE MAT_EXT;
    p.Maskimg = load_cells_from_disk(handles,0,[CELLSFILE MAT_EXT]);
end

% find out the title of the graph
if(isempty(my_get(handles.edit63,'string')))
    tit=fixdir(p.fdir);
else
    tit = my_get(handles.edit63,'string');
end
if tit(end)==filesep
    tit=tit(1:(end-1));
end

if(nargin>1)
    ef=export_graphics_flag;
else
    ef=opt1(11);
end

if(nargin>2)
    af=accum_flag;
else
    af=0;
end

if(nargin>3)
    uss=update_special_scale;
else
    uss=1;
end

%sic_mass = str2num(get(handles.edit65,'string'));
sic_mass = get(handles.edit65,'string');

% export ascii flag
eaf = opt1(10) | (opt1(5) & opt1(8));

if opt1(3) || opt1(6) || eaf || opt1(5) || opt1(9) || opt1(13) || opt1(12) || opt1(14)
   
    if ~p.planes_aligned
        
        fprintf(1,'*** Warning: Align and accumulate planes first before analyzing ratio images.\n');
        
    else
    
        %% get the filename with the classification of cells
        % This is needed to display histograms/ranking/scatter plots
        % separately for each cell class.

        if (opt1(3) | opt1(9) | opt1(12)) & eaf
            cellfile = select_classification_file(p);        
        else
            cellfile = [];
        end
        
        %% calculate the ratio images and avg. ratios in ROIs
        [R,Ra,Raim,o,Rconf,Rnom,Rdenom] = calculate_R_images(p, opt4, eaf, opt1(16), sic_mass);
        
        %% display ratio images and export data
        for ii=1:length(R)

            % display ratio image
            if (opt1(3) | opt1(6)) & opt4(ii) & ef
                
                % if log10-transformation reqested, make sure min(scale) is
                % not 0
                if opt1(4)
                    if p.special_scale{ii}(1)<=0
                        scale_auto = find_image_scale(R{ii}, 0, additional_settings.autoscale_quantiles, opt1(4), 0, p.special{ii});
                        p.special_scale{ii}(1) = scale_auto(1);
                    end
                end
                
                plotImageCells(10+ii,R{ii},p.Maskimg,p.fdir,p.special{ii},...
                    [my_get(handles.edit62,'string'),'-'],p.special_scale{ii},...
                    opt1,opt3(ii), ef, p.scale, tit, cellfile, p.images{1},p.planes,Rconf{ii});
                
                % export image as EPS, if requested
                if opt1(6) & opt1(11)
                    exportImageCells(10+ii,p.fdir,p.special{ii},p.ext,...
                        additional_settings.print_factors(1));
                end
                
            end

            % export data as ASCII file, if requested
            if opt4(ii) & eaf & ~af 
                if isempty(o)
                    fprintf(1,'*** WARNING: No ROIs have been defined, so no data can be exported.\n');
                else
                    export_ascii_data_for_ROIS(o{ii}, p.fdir, p.special{ii}, '.dac', 'f');
                end
            end

        end

        %% display RGB image constructed from 3 selected ratio images
        if opt1(5)
            [rgb7, rgb8, xl, yl, zl, xs, ys, zs, rgb_true] = ...
                construct_RGB_image(handles,p.special,p.special_scale,R,Raim,opt1,Rconf,p.Maskimg);
            display_RGB_image(rgb7, rgb8, p, opt1, tit, xl, yl, zl, get(handles.edit62,'string'));                
        end
        
        %% display scatter (x-y-z) plot
        if opt1(9) 
            if opt1(8) | opt1(7)
                display_xyz_graphs(R, Ra, o, p, opt1, cellfile, handles,Rnom,Rdenom);
            else
                fprintf(1,'Warning: Please select "Pixel by pixel" or "Averaged over ROIs" to display the graph.\n');
            end
        end
         
        %% accumulate masses in ROIs over all pixels, but separately in each plane
        % this will be used when displaying cell ranking or depth profiles (see below)
        if opt1(12) | opt1(13)                        
            [m2, dm2]=accumulate_masses_in_cells(p.im,p.Maskimg,p.im,p.images,p.mass);            
        end
        
        %% quantify effect of ROI perimeter
        % (requested: Stephane Escrig, added by LP: 19-05-2018)
        % Specifically, calculate ratios from ion counts accumulated in ...
        % - all ROI pixels, 
        % - pixels at the ROI's perimeter,
        % - pixels inside the ROI (whole ROI excluding the perimeter)  
        ucells = setdiff(unique(p.Maskimg),0);
        if additional_settings.calculate_perimeter & ~isempty(ucells)
            perim_def = 1;
            perim = str2num(cell2mat(inputdlg('Calculating ratios in pixels at ROI''s perimeter. Enter thickness of the perimeter (pix): ','Enter positive number')));
            if isempty(perim), perim = perim_def; elseif perim<1, perim=perim_def; end
                        
            k = 0;
            all_x = [];
            all_ratios = [];            
            Ncells = 0;
            for ii=1:length(p.special)
                if( opt4(ii) & ~isempty(p.special{ii}) )
                    % find the formula in p.special{ii}
                    [formula PoissErr] = parse_formula_lans(p.special{ii},p.mass);
                        
                    oo=[];
                    CELLS_in=zeros(size(p.Maskimg));
                    CELLS_perim=CELLS_in;
                    for nn=1:length(ucells)                  
                                                
                        fprintf(1,'Searching for pixels at the perimeter (thickness=%d) of ROI %d.\n',perim,ucells(nn));
                        [ind_all, ind_inside, ind_perim]=find_points_cell_perimeter_inside(p.Maskimg,ucells(nn),perim);
                        
                        % calculate ratio in the whole cell
                        p4 = zeros(size(p.Maskimg));
                        p4(ind_all)=1;
                        [m, dm]=accumulate_masses_in_cells(p.accu_im,p4,p.im,p.images,p.mass);
                        eval(formula);
                        eval(PoissErr);
                        oo(nn,1:4) = [r per*r per length(ind_all)];
                        
                        % calculate ratio in the inside of the cell and at
                        % the perimeter
                        if ~isempty(ind_inside)
                            % inside
                            p4 = zeros(size(p.Maskimg));                        
                            p4(ind_inside)=1;
                            CELLS_in(ind_inside)=ucells(nn);
                            [m, dm]=accumulate_masses_in_cells(p.accu_im,p4,p.im,p.images,p.mass);
                            eval(formula);
                            eval(PoissErr);
                            oo(nn,5:8) = [r per*r per length(ind_inside)];
                            % perimeter
                            p4 = zeros(size(p.Maskimg));
                            p4(ind_perim)=1;
                            [m, dm]=accumulate_masses_in_cells(p.accu_im,p4,p.im,p.images,p.mass);
                            eval(formula);
                            eval(PoissErr);
                            oo(nn,9:12) = [r per*r per length(ind_perim)];                           
                        else
                            fprintf(1,'WARNING: ROI %d has no inside pixels.\n',ucells(nn));
                            oo(nn,5:8) = 0;
                            oo(nn,9:12) = oo(nn,1:4);
                        end
                        CELLS_perim(ind_perim)=ucells(nn);
                                                                        
                    end
                    
                    % oo format (in columns):
                    % 1=mean whole  5=mean inside   9=mean perim
                    % 2=SD whole    6=SD inside     10=SD perim
                    % 3=CV whole    7=CV inside     11=CV perim (CV=SD/mean)
                    % 4=N whole     8=N inside      12=N perim
                    
                    % show results
                    fig90=figure(90+ii); 
                    hold off
                    errorbar(ucells, oo(:,1), oo(:,2), 'rs-');
                    hold on
                    errorbar(ucells, oo(:,5), oo(:,6), 'gs-');
                    errorbar(ucells, oo(:,9), oo(:,10), 'bs-');                    
                    legend({'whole ROI','inside ROI','ROI perim'},'location','northeast');
                    xlabel('ROI ID');
                    ylabel(p.special{ii});
                    title(sprintf('Perimeter thickness %d pix',perim),'fontweight','normal');
                    
                    a=p.special{ii};
                    a=convert_string_for_texoutput(a);
                    
                    % save data in a dat file
                    mfile = sprintf('%s_perim%d.dat',[p.filename delimiter 'dat', delimiter,a],perim);
                    out = [ucells(:) oo];
                    if 1
                        fid = fopen(mfile,'w');
                        fprintf(fid,'# ratios calculated for perimeter thickness %d pix\n',perim);
                        fprintf(fid,'# ROI\twhole MEAN\twhole SD\twhole CV\twhole N\tinside MEAN\tinside SD\tinside CV\tinside N\tperim MEAN\tperim SD\tperim CV\tperim N\n');
                        fprintf(fid,'%d\t%.5e\t%.5e\t%.5e\t%d\t%.5e\t%.5e\t%.5e\t%d\t%.5e\t%.5e\t%.5e\t%d\n',out');
                        fclose(fid);
                        fprintf(1,'Data in whole ROIs, inside ROIs and at ROI perimeters saved as\n  %s\n',mfile);
                    end
                    
                    % export graph
                    mfile = sprintf('%s_perim%d.eps',[p.filename delimiter 'eps', delimiter,a],perim);
                    print_figure(fig90,mfile,additional_settings.print_factors(2));
                    mepstopdf(mfile,'epstopdf',0,1,1);
                    
                    % export also ROIs images
                    global CELLSFILE MAT_EXT;
                    fout = sprintf('%s%d.png',[p.filename delimiter CELLSFILE '_in'],perim);
                    rgb=ind2rgb(uint16(CELLS_in),clut(max(CELLS_in(:))+1));
                    imwrite(rgb,fout);
                    fprintf(1,'Inside of cells saved as %s\n',fout);
                    fout = sprintf('%s%d.png',[p.filename delimiter CELLSFILE '_perim'],perim);
                    rgb=ind2rgb(uint16(CELLS_perim),clut(max(CELLS_perim(:))+1));
                    imwrite(rgb,fout);
                    fprintf(1,'Perimeters (thickness %d) of cells saved as %s\n',perim, fout);
                    
                end
            end            
        end

        %% perform sensitivity analysis (only if ROIs defined) 
        % this is used only for special tests and requires direct debugging
        if 0 & ~isempty(setdiff(unique(p.Maskimg),0))
            
            % sensitivity analysis will
            % calculate ratios in ROIs modified by the addition and removal
            % of pixels at its perimeter, find the combinations with the
            % highest and lowest ratio, and compare these amongst each
            % other
            
            % for now this is experimental (19-07-2011), and 
            % calculation options must be set manually
            
            nid_def = 1;
            nid = input('Enter ROI ID for which the sensitivity analysis will be done (default 1): ');
            if isempty(nid), nid = nid_def; end
            all_nop = [1:5]; % number of pixels to be added and removed

            k = 0;
            all_x = [];
            all_ratios = [];            
            Ncells = 0;
            for ii=1:length(p.special)
                if( opt4(ii) & ~isempty(p.special{ii}) )
                    % find the formula in p.special{ii}
                    [formula PoissErr] = parse_formula_lans(p.special{ii},p.mass);
                        
                    oo=[];
                    for nn=1:length(all_nop)                        
                        
                        nop = all_nop(nn);
                        
                        fprintf(1,'Adding/removing %d pixel(s)\n',nop);
                                                
                        % return indices at the perimeter (for nop<0) and
                        % just outside of the perimeter (for nop>0)
                        [C,CELLS,indp_p]=add_points_cell_perimeter(p.Maskimg,nid,nop);
                        [C,CELLS,indp_n]=add_points_cell_perimeter(p.Maskimg,nid,-nop);
                        
                        % add pixels with lowest and higest ratios outside
                        % the perimeter and recalculate R
                        
                        % find the ratios in pixels indp, outside the
                        % perimeter
                        indp = indp_p;
                        [Rp,indRp] = sort(R{ii}(indp));
                        
                        % select abs(nop) pixels with the lowest and highest Rp values
                        indl = [1:nop];
                        indh = [-nop+1:0]+length(indp);
                        % these are the actual indices within the indexing
                        % of the CELLS image
                        indl = indp(indRp(indl));
                        indh = indp(indRp(indh));
                        
                        % add pixels with the lowest ratios and accumulate
                        % mass images so that the mean ratio can be
                        % calculated
                        p4 = CELLS;
                        p4(indl) = ones(size(indl));
                        %figure(45); subplot(2,2,1);imagesc(p4);
                        % accumulate masses
                        [m, dm]=accumulate_masses_in_cells(p.accu_im,p4,p.im,p.images,p.mass);
                        % calculate ratio
                        eval(formula);
                        % remember the output
                        oo(nn,1) = r;
                        
                        % add pixels with the highest ratios and accumulate
                        % mass images so that the mean ratio can be
                        % calculated
                        p4 = CELLS;
                        p4(indh) = ones(size(indh));
                        %figure(45); subplot(2,2,2);imagesc(p4);
                        % accumulate masses
                        [m, dm]=accumulate_masses_in_cells(p.accu_im,p4,p.im,p.images,p.mass);                        
                        % calculate ratio
                        eval(formula);
                        % remember the output
                        oo(nn,2) = r;
                        
                        % remove pixels with lowest and higest ratios on
                        % the perimeter and recalculate R
                        
                        % find the ratios in pixels indp, on the
                        % perimeter
                        indp = indp_n;
                        [Rp,indRp] = sort(R{ii}(indp));
                        
                        % select abs(nop) pixels with the lowest and highest Rp values
                        indl = [1:nop];
                        indh = [-nop+1:0]+length(indp);
                        % these are the actual indices within the indexing
                        % of the CELLS image
                        indl = indp(indRp(indl));
                        indh = indp(indRp(indh));
                        
                        % remove pixels with the lowest ratios and accumulate
                        % mass images so that the mean ratio can be
                        % calculated
                        p4 = CELLS;
                        p4(indl) = zeros(size(indl));
                        %figure(45); subplot(2,2,3);imagesc(p4);
                        % accumulate masses
                        [m, dm]=accumulate_masses_in_cells(p.accu_im,p4,p.im,p.images,p.mass);
                        % calculate ratio
                        eval(formula);
                        % remember the output
                        oo(nn,3) = r;
                        
                        % remove pixels with the highest ratios and accumulate
                        % mass images so that the mean ratio can be
                        % calculated
                        p4 = CELLS;
                        p4(indh) = zeros(size(indh));
                        %figure(45); subplot(2,2,4);imagesc(p4);
                        % accumulate masses
                        [m, dm]=accumulate_masses_in_cells(p.accu_im,p4,p.im,p.images,p.mass);
                        % calculate ratio
                        eval(formula);
                        % remember the output
                        oo(nn,4) = r;

                        % remember also the original R and dR values
                        oo(nn,5:6) = o{ii}(nid,4:5);
                                                
                    end
                    
                    fprintf(1,'Sensitivity analysis of %s in ROI %d (N=number of added/removed pixels)\n',p.special{ii},nid);
                    fprintf(1,'N\toriginal\t  min+  \t  max+  \t  min-  \t  max-  \td_min(N)%c\td_max(N)%c\n','%','%');                        
                    for nn=1:length(all_nop)
                        fprintf(1,'%d\t%.3e\t%.3e\t%.3e\t%.3e\t%.3e\t%.1e\t%.1e\n',all_nop(nn),oo(nn,5),oo(nn,1:4),...
                            100*(min(oo(nn,1:4))/oo(nn,5)-1), 100*(max(oo(nn,1:4))/oo(nn,5)-1));
                    end
                    figure(46+ii);
                    hold off
                    errorbar(all_nop(:),oo(:,5),oo(:,6)/2,'ko-');
                    hold on
                    plot(all_nop(:),oo(:,1:4),'s-');
                    legend('original+/-PE','added lowest','added highest','removed lowest','removed highest');
                    xlabel('number of added/removed pixels');
                    ylabel('R_{orig}, R_{mod}');
                    
                    a=p.special{ii};
                    title(a);
                    a=convert_string_for_texoutput(a);
                    mfile = sprintf('%s_%d.dat',[p.filename delimiter 'dat', delimiter,a],nid);
                    out = [all_nop(:) oo];
                    save(mfile,'out','-ascii');
                    
                    if 0
                    k = k+1;
                    all_ratios{k} = p.special{ii};
                    all_x{k} = o;
                    end
                    
                    
                end  
            end

            mfile = [p.filename '.txt'];
            
            % open statistics_gui where all the comparisons will be done
            %statistics_gui(all_x, all_ratios, mfile);
            
        end
                    
        %% display ROIs ranking and differences among ROIs
        % debugged on 06-03-2023 by LP to account for changes in
        % statistics_gui made in the meantime
        if opt1(12)
            
            % define cell classes by loading cell
            % classifications from the disk
            [cidu,cc,cid,cnum,ss]=load_cell_classes(cellfile);
            
            k = 0;
            all_x = [];
            all_ratios = [];
            for ii=1:length(p.special)
                if( opt4(ii) & ~isempty(p.special{ii}) )

                        % find the formula in p.special{ii}
                        [formula PoissErr] = parse_formula_lans(p.special{ii},p.mass);
                        cell_sizes = o{ii}(:,8)*ones(1,size(m2{1},2));
                        lwratios = o{ii}(:,9)*ones(1,size(m2{1},2));
                        
                        % calculate the ratios in each cell based on
                        % accumulated values for every plane
                        all_images=p.images;
                        if isempty(all_images{1})
                            for idx=1:length(p.mass)
                                all_images{idx}=p.planes;
                            end
                        end
                        [o2,r]=calculate_ratios(m2, p.Maskimg, all_images, formula, PoissErr, 2, cell_sizes, lwratios);
                        
                        % r is now a depth profile of ratios for each cell,
                        % so use it as a basis for cell ranking
                        % this was the old way, with multiple windows
                        %%display_cell_ranking(100*ii, r, cellfile, p.special{ii}, p.fdir, opt1(11), opt1(4), opt1(14));

                        % set classes to 'a' if no classes were defined
                        Np = size(r,1);
                        Nc = size(r,2);
                        if isempty(cellfile)
                            cid = 'a'*ones(Nc,1);
                        end

                        % this is the new way, using statistics_gui for all
                        % rois, ratios and classes
                        
                        % produce input compatible with statistics_gui
                        planes = p.images{1}(:)*ones(1,Nc);
                        if isempty(planes)
                            planes = p.planes(:)*ones(1,Nc);
                        end
                        cellnum = ones(Np,1)*[1:Nc];
                        cellclass = ones(Np,1)*cid';
                        treatment = ones(Np,Nc);
                        
                        k = k+1;
                        all_ratios{k} = p.special{ii};
                        all_x{k} = [planes(:) cellnum(:) r(:) cellclass(:) treatment(:)];
                        
                end
            end
            
            mfile = [p.filename '.txt'];
            
            % reorganize data into tables, as required by statistics_gui
            % debugged on 06-03-2023 by LP
            Nrow = size(all_x{1},1);
            cs = cell_sizes(:,planes(:,1))'; 
            lw = lwratios(:,planes(:,1))';
            sizefactor=2/sqrt(pi)*p.scale/size(p.Maskimg,2);
            t1 = table(ones(Nrow,1), ...
                repmat(mfile,Nrow,1), ...
                treatment(:), ...
                cellclass(:), ...
                cellnum(:), ...
                sizefactor*sqrt(cs(:)), ...
                cs(:), ...
                lw(:), ...
                ones(Nrow,1), ...
                ones(Nrow,1), ...
                cellnum(:),...
                'VariableNames',{'id';'file';'treatment'; ...
                'roi_class';'roi_id';'size';'pixels';'l2w'; ...
                 % 'dl2w';
                'xpos';'ypos';'roi_uid'});
            rdr = zeros(size(t1,1), 2*length(all_ratios));
            for k=1:length(all_x)
                rdr(:, (k-1)*2+1) = all_x{k}(:,3);                
            end
            rdr(isinf(rdr))=NaN; 
            t2 = array2table(rdr);
            
            % this was the old way, which got broken at some point and was
            % not fixed further
            %statistics_gui(all_x, all_ratios, mfile,...
            %    additional_settings.print_factors(5));
            
            % open statistics_gui where all the comparisons will be done
            % this is the new way, debugged on 06-03-2023
            statistics_gui(t1, t2, all_ratios, mfile);
            
        end

        %olavius_hack(p,R);    

        %% display depth profiles
        if opt1(13)

            % accumulate masses in cells over all pixels and all planes,
            % but only in selected planes!
            for ii=1:length(m2)
                m3{ii} = sum(m2{ii}(:,p.images{ii}),2);
            end
            
            for ii=1:length(o)
                if ~isempty(o{ii})
                    cell_sizes = o{ii}(:,8)*ones(1,size(m2{1},2));
                end
            end
            
            % display depth profiles of ratios for all cells
            plot_export_ratios_depth(m2, dm2, cell_sizes, p.images, p.planes, ...
                opt1, opt4, p.special, p.mass, p.fdir, ...
                additional_settings.print_factors(3));

            %fprintf(1,'Plotting/exporting depth profiles ... Done.\n');
            
            % calculate ratios based on different types of averages (see
            % comments below)
            if 0
                fprintf(1,'** This is display_ratios_through_mask, line 144.\n** Exporting *.da1 through *.da3\n');
                for ii=1:length(p.special)
                    if( opt4(ii) & ~isempty(p.special{ii}) )

                        % find the formula in p.special{ii}
                        [formula PoissErr] = parse_formula_lans(p.special{ii},p.mass);

                        all_images=p.images;
                        if isempty(all_images{1})
                            for idx=1:length(p.mass)
                                all_images{idx}=p.planes;
                            end
                        end
                        
                        % calculate the ratios in each cell based on averages over all
                        % pixels and all planes
                        [o1,r]=calculate_ratios(p.im, p.Maskimg, all_images, formula, PoissErr, 1);
                        
                        % here, o contains values that were calculated above using function
                        % calculate_R_images(...), but there o(:,4:6) were calculated based 
                        % on masses accumulated over all planes and all pixels in ROIs, so 
                        % replace it here with o1
                        o1 = [o{ii}(:,1:3) o1 o{ii}(:,7:9)];
                        export_ascii_data_for_ROIS(o1, p.fdir, p.special{ii}, '.da1', 'f');

                        % calculate the ratios based on averages over planes of ratios
                        % calculated from accummulated masses in cells in each plane            
                        [o2,r]=calculate_ratios(m2, p.Maskimg, all_images, formula, PoissErr, 2);
                        o2 = [o{ii}(:,1:3) o2 o{ii}(:,7:9)];
                        export_ascii_data_for_ROIS(o2, p.fdir, p.special{ii}, '.da2', 'f');

                        % calculate the ratios based on total count accumulated over
                        % all pixels and all planes  in each cell
                        [o3,r]=calculate_ratios(m3, p.Maskimg, all_images, formula, PoissErr, 3);
                        o3 = [o{ii}(:,1:3) o3 o{ii}(:,7:9)];
                        export_ascii_data_for_ROIS(o3, p.fdir, p.special{ii}, '.da3', 'f');

                    end
                end
            end

            %fprintf(1,'Done.\n');
        
        end
    
        %% display lateral profiles
        if opt1(14)
            % extract the selected planes
            image_stack = p.im;            
            for ii=1:length(image_stack)
                if ~isempty(p.images{ii})
                    image_stack{ii} = image_stack{ii}(:,:,p.images{ii});
                end
            end
            lateral_profile_gui(R,p.special_scale,p.special,...
                p.fdir,p.scale,...
                image_stack,p.mass, ...
                2); %,...
                % additional_settings.print_factors(4));
        end
        
    end 
    
end

%a=0;

% activate the main GUI at the end
figure(handles.figure1);
