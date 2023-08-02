function [out pdfout f30 cid] = display_depth_profiles_ROIS(m,dm,cid,cnum,images,masses,Maskimg,ratios,fname,cellclasses)

global additional_settings;

counts = m;
dcounts = dm;
Nrois = length(cid);
plane_range = images{1};
if isempty(plane_range)
    plane_range = 1:size(m{1},2);
end

out=[];
pdfout=[];out_counts = zeros(length(plane_range), 2*Nrois);

out_counts = zeros(length(masses), length(plane_range), 2*Nrois);
out_ratios = zeros(length(ratios), length(plane_range), 2*Nrois);

MAX_GRAPHS=9;

for ii=1:length(ratios)
        
    [formula, PoissErr, mass_index] = parse_formula_lans(ratios{ii}, masses);
    
    if ~isempty(mass_index)
        
        f30{ii}=figure(30+ii);
        sz = get( 0, 'ScreenSize' );
        fp = get(f30{ii},'Position');
        set(f30{ii},'Position',[sz(3)/2 1 sz(3)/2 sz(4)]);                

        nrows = ceil(MAX_GRAPHS/3);

        if Nrois>MAX_GRAPHS
            fprintf(1,'*** WARNING: Number of ROIs>%d. Depth profiles for only the first %d ROIs will be displayed.\n',MAX_GRAPHS,MAX_GRAPHS);
        end

        ll = 0;
        for jj=1:Nrois

            y=[];
            for kk=1:length(mass_index)
                y(:,kk) = counts{mass_index(kk)}(jj,plane_range);
            end

            ROIsize=length(find(Maskimg==jj));
            y=y/ROIsize;            

            m=[];
            for kk=1:length(masses)
                m{kk}=counts{kk}(jj,plane_range);
                
                % store accoumulated counts per ROI for later export
                if ii==1
                    out_counts(kk, :, 2*(jj-1)+[1 2]) = [m{kk}(:) sqrt(m{kk}(:))];
                end
            end

            % calculate depth profile of the ratio
            eval(formula);
            r_profile = r;
            eval(PoissErr);
            dr_profile = per;
            values = [r(:) per(:).*r(:)];
            values(isnan(values)) = 0;
            out_ratios(ii, :, 2*(jj-1)+[1 2]) = values;
            
            % calculate correction for variance in r due to Poisson contribution
            % NOTE: the formula only works for a *simple ratio of two* variables (R/S), i.e.,
            % not when the expression is like R/(R+S).
            if length(mass_index)==2
                R = m{mass_index(1)};
                S = m{mass_index(2)};
                var_poiss = (mean(R)/mean(S)*sqrt(1/mean(R)+1/mean(S)))^2;
            else
                var_poiss = 0;
            end
            % total variance in ratio (due to depth AND Poisson)
            var_r = var(r_profile(find(isfinite(r_profile))));
            % variance due to depth
            var_depth = var_r-var_poiss;
            if var_depth<0
                var_depth=0;
            end
            
            % gather statistics from the depth profile
            out1 = [ sqrt(var_r) sqrt(var_poiss) sqrt(var_depth) quantile(r_profile,[0.025 0.975]) ];
            % mean ratio value needs to be calculated from the accumulated counts
            m=[];
            for kk=1:length(masses)
                m{kk}=sum(counts{kk}(jj,plane_range));
            end
            eval(formula);
            out{ii}(jj,:) = [r out1];

            % display depth profiles of the ion_counts/pixel and of the ratio
            % in the ROI, but only if its class is member of the
            % cellclasses specified by the user
            % NOTE: both ion counts and ratios will be *normalized* by the
            % mean value to better highlight the variability over depth
            if sum(ismember(cellclasses,cid(jj))) > 0
                ll=ll+1;
                if ll<=MAX_GRAPHS                
                    subplot(nrows, 3, ll);
                    % normalize ion counts and ratios to their respective mean
                    ind1 = ~isnan(r_profile);
                    ind2 = ~isinf(abs(r_profile));
                    ind = ind1 & ind2;
                    r_norm = r_profile/mean(r_profile(ind));
                    y_norm = y ./ (ones(size(y,1),1)*mean(y));
                    hold off;
                    [ax,h1,h2]=plotyy(plane_range,r_norm,plane_range,y_norm);                    
                    % calculate scaling
                    sc = quantile(r_norm(ind),[0.01 0.99]);
                    if sc(1)==sc(2)
                        sc=[min(r_norm(ind)) max(r_norm(ind))];
                    end
                    if sc(2)>sc(1)
                        minr = sc(1) - diff(sc)/10;
                        maxr = sc(2) + diff(sc)/10;                
                        minr = floor(minr*100)/100;
                        maxr = ceil(maxr*100)/100;
                    else
                        minr = -1;
                        maxr = 1;
                    end
                    sc = quantile(y_norm(:),[0.01 0.99]);
                    if sc(1)==sc(2)
                        sc=[min(y_norm(:)) max(y_norm(:))];
                    end
                    if sc(2)>sc(1)
                        miny = sc(1) - diff(sc)/10;
                        maxy = sc(2) + diff(sc)/10;
                        miny = floor(miny*100)/100;
                        maxy = ceil(maxy*100)/100;
                    else
                        miny = -1;
                        maxy = 1;
                    end
                    % set axes properties to make them look nicer
                    set(ax(1),'YColor',[1 0 0]);
                    set(get(ax(1),'Ylabel'),'String', sprintf('(%s) / %.2e',ratios{ii},r));
                    xlabel('plane')
                    title(sprintf('ROI %d (%c) [CV=%2.1f%c (z:%2.0f%c)]',cnum(jj),cid(jj),...
                        out1(1)/r*100, '%', (out1(3)/out1(1))^2*100, '%'), 'color','b');
                    set(ax(1),'FontSize',additional_settings.defFontSize);
                    set(ax(2),'FontSize',additional_settings.defFontSize);
                    %mcols = 'gbmc';
                    mcols = 'x+';
                    for kk=1:length(h2)
                        %set(h2(kk),'linestyle','none','Marker','.',...
                        %    'MarkerSize',12,'Color',mcols(kk));
                        set(h2(kk),'linestyle','none','Marker',mcols(kk),...
                            'MarkerSize',8,'Color','k');
                    end
                    set(h1,'linestyle','-','Marker','*','MarkerSize',8,'Color','r');
                    set(ax(1),'ylim',[minr maxr],'xlim',[min(plane_range)-1 max(plane_range)],...
                        'ytick',[minr, 1, maxr]); %linspace(minr,maxr,2));
                    set(get(ax(1),'YLabel'),'Position', [min(plane_range)-3, mean([minr, maxr]), -1]);
                    set(ax(2),'ylim',[miny maxy],'xlim',[min(plane_range)-1 max(plane_range)],...
                        'ytick',[]); %linspace(miny,maxy,2));
                    set(get(ax(2),'Ylabel'),'String', sprintf('%s(%s), %s(%s)',masses{mass_index(1)}, mcols(1), masses{mass_index(2)}, mcols(2)));
                    set(get(ax(2),'Ylabel'),'Position', [max(plane_range)+1, mean([miny, maxy]), -1]);
                    a=0;
                end
            end
        end

        [fdir, fn, fext] = fileparts(fname);
        set(f30{ii},'name',fn);
        
        a=convert_string_for_texoutput(ratios{ii});
        % first print as eps, then convert to pdf
        fout=[fname delimiter 'eps' delimiter a '-rois-z.eps'];
        pdfout{ii}=[fname delimiter 'pdf' delimiter a '-rois-z.pdf'];
        print_figure(f30{ii},fout,additional_settings.print_factors(3));
        % create also PDF file, so that it can be included by pdflatex 
        mepstopdf(fout,'epstopdf');

        %a=0;
        %close(f30);
        
        % export depth profiles of ion counts
        if ii==1
            for kk=1:length(masses)
                fout = [fname delimiter 'dat' delimiter masses{kk} '-z.dat'];
                fid = fopen(fout, 'w');
                fprintf(fid, '# %s/: %s\n', fname, masses{kk});
                fprintf(fid, '# cell');
                for jj=1:Nrois
                    fprintf(fid, '\tMEAN%d\tPoiss_E%d', jj,jj);
                end
                fprintf(fid,'\n# plane');
                fmt = '%d';
                for jj=1:Nrois
                    fprintf(fid, '\tPOL=NaN\t');
                    fmt = [fmt, '\t%.3e\t%.3e'];
                end
                fmt = [fmt, '\n'];
                fprintf(fid,'\n');
                fprintf(fid, fmt, [plane_range(:) squeeze(out_counts(kk,:,:))]');
                fclose(fid);
                fprintf(1,'Depth profiles of %s ion counts per ROI exported to %s\n', masses{kk}, fout);
            end
        end
        
        % export depth profile of ion count ratios
        fout = [fname delimiter 'dat' delimiter convert_string_for_texoutput(ratios{ii}) '-z.dat'];
        fid = fopen(fout, 'w');
        fprintf(fid, '# %s/: %s\n', fname, ratios{ii});
        fprintf(fid, '# cell');
        for jj=1:Nrois
            fprintf(fid, '\tMEAN%d\tPoiss_E%d', jj,jj);
        end
        fprintf(fid,'\n# plane\t');
        fmt = '%d';
        for jj=1:Nrois
            fprintf(fid, '\tPOL=NaN');
            fmt = [fmt, '\t%.3e\t%.3e'];
        end
        fmt = [fmt, '\n'];
        fprintf(fid,'\n');
        fprintf(fid, fmt, [plane_range(:) squeeze(out_ratios(ii,:,:))]');
        fclose(fid);
        fprintf(1,'Depth profiles of %s ratios in ROIs exported to %s\n', ratios{ii}, fout);
        
    else
        
        out{ii} = [];
        pdfout{ii} = [];
        
    end
    
end
