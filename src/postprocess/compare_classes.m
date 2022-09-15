function compare_classes(s)
% Function for statistical comparison of ratios in ROI classes. Ratios
% determined in ROIs (for different classes or treatments) are used
% as a basis for the comparison. The comparison is done for ROIs from 
% analyzed datasets specified in the metafile. Classes can be compared
% between each other or for different treatments.
% (c) Lubos Polerecky, 04.07.2011, MPI Bremen

global verbose

fprintf(1,'\n\n\nMetafile processing: compare_classes.m\n');

if(exist(s.base_dir)~=7 || exist(s.metafile)~=2)
    disp(['Dataset directory or metafile does not exist. Nothing done.']);
else

    %% form the final output file basename and the title
    [pathstr, name, ext] = fileparts(s.metafile);
    foutname = [pathstr,delimiter,name];
    if ~isfolder(foutname)
        mkdir(foutname);
    end
    foutname = [foutname delimiter name];

    %% get instructions from the meta file
    %all_cell_types = regexprep(s.cellclasses,' ','');
    all_cell_types= [];
    [id,fname,tmnt,ct,xyz,nf,varnames,plot3d]=getmetainstructions(s.metafile, all_cell_types, s.plot3d);
    tmnt = cell2mat(tmnt);
    
    %% read data from all specified input files
    % note that corrections will also be applied in this step!!
    [t1, t2, xyz, varnames] = read_data_from_input_files(s, fname, xyz, ct, tmnt, varnames);
    
%     % load correction and calculation settings from the global variable
%     global correction_settings;
%     
%     Nvar = length(varnames{1});        
%     
%     all_x = [];
%     all_ratios = [];
%     kk = 0;
%         
%     % define whether corrections should be applied, and the corresponding
%     % correct values and classes
% %     global correction_settings;
% %     apply_corrections = correction_settings.correction_apply;
% %     correction_classes = correction_settings.correction_classes;
% %     corr_values = correction_settings.correction_values;
% %                 
%     for k=1:Nvar % read data for each variable (=ratio) separately
%         
%         q = xyz{1}{k};
%         qq = varnames{1}{k};
%         if strcmp(lower(q),'l2w') | strcmp(lower(q),'lw') | strcmp(lower(q),'lwratio')
%             q='l2w';
%         end;
%                     
%         fprintf(1,'Formatting "%s" data for statistical testing ... \n',qq);        
%         
%         if strcmp(lower(q),'x') | strcmp(lower(q),'y')
%         
%             % do not compare position
%             fprintf(1,'%s will not be compared. Skipping.\n',q);
%             
%         else
%             
%             % read raw data
%             planes = []; ratios = []; cellnum = []; cellclass = []; treatment = [];
%             Ncell = 0;
%             for j=1:nf
% 
%                 fncells = [s.base_dir, fname{j}, delimiter, s.classificationfile];                
%                 rname = q;
%                 if strcmp(lower(q),'size') | strcmp(lower(q),'l2w')
%                     rname = 'cells';
%                 end;
%                 fn = [s.base_dir, fname{j}, delimiter, 'dat', delimiter, rname, dext];
% 
%                 % load accumulated ratios q in all cells
%                 [d,cellid,area,pixels,xpos,ypos,l2w,cls]=getratiodata(ct{j},fn,fncells,q,1);  
%                                 
%                 if correction_settings.correction_apply(k)
%                     % search for class based on which corrections are to be
%                     % made, and find the correction factor
%                     corr_class = correction_settings.correction_classes(k);
%                     corr_value = correction_settings.correction_values(k);
%                     % apply correction
%                     d_new = make_data_correction(d, cls, corr_class, corr_value, k, q);
%                     d = d_new;                    
%                 end
%                 
%                 % Calculate rate (implemented on 11-02-2019)
%                 if correction_settings.calculate_rate(k)
%                     data_tmnt = tmnt(j);
%                     [Lia, Locb] = ismember(data_tmnt,correction_settings.treatments);
%                     if Lia
%                         bkg = correction_settings.correction_values(k);
%                         medium = correction_settings.medium_value{k}(Locb);
%                         dt = correction_settings.incubation_times(Locb);
%                         % calculate rate for all values in a (note: the
%                         % input values of "a" may be modified by the
%                         % correction above!)
%                         d_new = calculate_rate(d, bkg, medium, dt, data_tmnt, k, xyz{j}{k}, fname{j});
%                         d = d_new;
%                         if j==1
%                             qq=sprintf('k(%s)',qq);
%                         end
%                     else
%                         fprintf(1,'WARNING: Treatment %d not included in the rate calculation settings. Rate not calculated for %s.\n',data_tmnt,fname{j});
%                     end
%                 end
%                 
%                 pp = []; rr = []; cn = []; cc = []; tt = [];
%                 
%                 for ii=1:length(d)
%                     if ~isempty(d{ii})
%                         Nc = length(cellid{ii});
%                         pp = [pp; ones(Nc,1)];
%                         data = d{ii}(:,1);
%                         if strcmp(lower(q),'size')
%                             data = area{ii}(:,1);
%                         elseif strcmp(lower(q),'l2w')
%                             data = l2w{ii}(:,1);
%                         end;
%                         rr = [rr; data];
%                         cn = [cn; cellid{ii} + Ncell];
%                         cc = [cc; cls{ii}];
%                         tt = [tt; tmnt(j)*ones(Nc,1)];
%                     end
%                 end
%                 
%                 Ncell = max(cn);                                                 
%                 planes{j}=pp;
%                 ratios{j}=rr;
%                 cellnum{j}=cn;
%                 cellclass{j}=cc;
%                 treatment{j}=tt;
%                 
%             end;           
%             
%             % reformat the data into a matrix with columns:
%             % [plane, cell_number, ratio, class, treatment]
%             
%             xx = [];
%             for j=1:nf
%                 xx = [xx; planes{j} cellnum{j} ratios{j} cellclass{j} treatment{j}];
%             end;
%             
%             % data for ratio qq is ready for statistical test
%             kk = kk+1;
%             all_x{kk} = xx;
%             all_ratios{kk} = qq;
%             fprintf(1,'Done\n');
%             
%         end
%         
%     end
    
    if ~isempty(t2)
        
        %% run the statistics_gui to do statistical testing interactively
        %global additional_settings;
        statistics_gui(t1, t2, varnames{1}, s.metafile)
        %additional_settings.print_factors(5));
        
    end
    
end
