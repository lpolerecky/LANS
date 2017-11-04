function compare_all_cells(s)
% Function for statistical comparison of ratios in single ROIs. Depth
% profiles of the ratios are used as a basis for the comparison. The
% comparison is done for cells from analyzed datasets specified in the
% metafile. ROIs can be compared within classes, between classes, between
% treatments.
% (c) Lubos Polerecky, 04.07.2011, MPI Bremen

if(exist(s.base_dir)~=7 | exist(s.metafile)~=2)
    disp(['Dataset directory or metafile does not exist. Nothing done.']);
else

    % form the final output file basename and the title
    [pathstr, name, ext] = fileparts(s.metafile);
    foutname = [pathstr,delimiter,name];

    % get instructions from the meta file
    all_cell_types = regexprep(s.cellclasses,' ','');
    [id,fname,tmnt,ct,xyz,nf,all,plot3d]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);
    plot2d = s.plot2d;

    dext = '-z.dat';
    
    Nvar = length(all{1});        
    
    all_x = [];
    all_ratios = [];
    kk = 0;
        
    for k=1:Nvar % read data for each variable (=ratio) separately
        
        q = xyz{1}{k};
        qq = all{1}{k};
        
        fprintf(1,'Formatting data for %s for statistical testing ... \n',qq);        
        
        if strcmp(lower(q),'size') | strcmp(lower(q),'x') | strcmp(lower(q),'y') | strcmp(lower(q),'l2w')
        
            % do not compare size, position or shape
            fprintf(1,'%s will not be compared. Skipping.\n',q);
            
        else
            
            % read raw data
            planes = []; ratios = []; cellnum = []; cellclass = []; treatment = [];
            for j=1:nf

                fncells = [s.base_dir, fname{j}, delimiter, s.classificationfile];
                fn = [s.base_dir, fname{j}, delimiter, 'dat', delimiter, xyz{j}{k}, dext];

                % load profiles of ratio q in all cells
                [pp,rr,cn,cc]=getratioprofiles(ct,fn,fncells,q,1);                                                                   

                planes{j}=pp;
                ratios{j}=rr;
                cellnum{j}=cn;
                cellclass{j}=cc;                
                
            end;           
            
            % reformat the data into a matrix with columns:
            % [plane, cell_number, ratio, class, treatment]
            
            treatments = unique(cell2mat(tmnt)); %unique treatments
            cellclasses = unique(cell2mat(cellclass)); %unique classes
            Nt = length(treatments);
            Nc = length(cellclasses);           
            
            cell_cnt = 0;
            xx = []; Ncells = 0;
            for j=1:nf
                
                % add data for all cells in all files                
                for cls = 1:Nc
                    
                    % find cells of class cellclasses(cls)
                    ind_c = find(cellclass{j}==cellclasses(cls));
                    Nr = length(ind_c);
                    Np = length(planes{j});
                    
                    if Nr>0
                        p = planes{j}*ones(1,Nr);
                        cc = cellclasses(cls)*ones(Np,Nr);
                        cnum = ones(Np,1)*cellnum{j}(ind_c)+Ncells;                        
                        r = ratios{j}(:,ind_c);
                        t = ones(Np,Nr)*tmnt{j};
                        % add data to xx
                        xx = [xx; p(:) cnum(:) r(:) cc(:) t(:)];
                    end;
                    
                end;
                
                Ncells = Ncells + length(cellnum{j});
                 
            end;
            
            % data for ratio qq is ready for statistical test
            kk = kk+1;
            all_x{kk} = xx;
            all_ratios{kk} = qq;
            fprintf(1,'Done\n');
            
        end;
        
    end;
    
    if ~isempty(all_x)
        
        % run the statistics_gui to do statistical testing interactively
	global additional_settings;
        statistics_gui(all_x, all_ratios, s.metafile, ...
            additional_settings.print_factors(5));
        
    end;
    
end;
