function compare_classes(s)
% Function for statistical comparison of ratios in ROI classes. Ratios
% determined in single ROIs (for different classes or treatments) are used
% as a basis for the comparison. The comparison is done for cells from 
% analyzed datasets specified in the metafile. Classes can be compared
% between each other or for different treatments.
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

    dext = '.dac';

    Nvar = length(all{1});        
    
    all_x = [];
    all_ratios = [];
    kk = 0;
        
    for k=1:Nvar % read data for each variable (=ratio) separately
        
        q = xyz{1}{k};
        qq = all{1}{k};
        if strcmp(lower(q),'l2w') | strcmp(lower(q),'lw') | strcmp(lower(q),'lwratio')
            q='l2w';
        end;
                    
        fprintf(1,'Formatting "%s" data for statistical testing ... \n',qq);        
        
        if strcmp(lower(q),'x') | strcmp(lower(q),'y')
        
            % do not compare position
            fprintf(1,'%s will not be compared. Skipping.\n',q);
            
        else
            
            % read raw data
            planes = []; ratios = []; cellnum = []; cellclass = []; treatment = [];
            Ncell = 0;
            for j=1:nf

                fncells = [s.base_dir, fname{j}, delimiter, s.classificationfile];                
                rname = q;
                if strcmp(lower(q),'size') | strcmp(lower(q),'l2w')
                    rname = 'cells';
                end;
                fn = [s.base_dir, fname{j}, delimiter, 'dat', delimiter, rname, dext];

                % load accumulated ratios q in all cells
                [d,cellid,area,pixels,xpos,ypos,l2w,cls]=getratiodata(ct{j},fn,fncells,q,1);                                                                   

                pp = []; rr = []; cn = []; cc = []; tt = [];
                
                for ii=1:length(d)
                    if ~isempty(d{ii})
                        Nc = length(cellid{ii});
                        pp = [pp; ones(Nc,1)];
                        data = d{ii}(:,1);
                        if strcmp(lower(q),'size')
                            data = area{ii}(:,1);
                        elseif strcmp(lower(q),'l2w')
                            data = l2w{ii}(:,1);
                        end;
                        rr = [rr; data];
                        cn = [cn; cellid{ii} + Ncell];
                        cc = [cc; cls{ii}];
                        tt = [tt; tmnt{j}*ones(Nc,1)];
                    end;
                end;
                
                Ncell = max(cn);                                                 
                planes{j}=pp;
                ratios{j}=rr;
                cellnum{j}=cn;
                cellclass{j}=cc;
                treatment{j}=tt;
                
            end;           
            
            % reformat the data into a matrix with columns:
            % [plane, cell_number, ratio, class, treatment]
            
            xx = [];
            for j=1:nf
                xx = [xx; planes{j} cellnum{j} ratios{j} cellclass{j} treatment{j}];
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
