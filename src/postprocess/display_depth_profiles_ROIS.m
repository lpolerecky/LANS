function [out pdfout f30 cid] = display_depth_profiles_ROIS(m,dm,cid,cnum,images,masses,Maskimg,ratios,fname,cellclasses)

global additional_settings;

counts = m;
dcounts = dm;
plane_range = images{1};
if isempty(plane_range)
    plane_range = 1:size(m{1},2);
end;

out=[];
pdfout=[];

MAX_GRAPHS=9;

for ii=1:length(ratios)
        
    [formula PoissErr mass_index] = parse_formula(ratios{ii},masses);
    
    if ~isempty(mass_index)
        
        f30{ii}=figure(30+ii);
        sz = get( 0, 'ScreenSize' );
        fp = get(f30{ii},'Position');
        set(f30{ii},'Position',[sz(3)/2 1 sz(3)/2 sz(4)]);
        
        Nrois = length(cid);

        nrows = ceil(MAX_GRAPHS/3);

        if Nrois>MAX_GRAPHS
            fprintf(1,'*** WARNING: Number of ROIs>%d. Depth profiles for only the first %d ROIs will be displayed.\n',MAX_GRAPHS,MAX_GRAPHS);
        end;

        ll = 0;
        for jj=1:Nrois

            y=[];
            for kk=1:length(mass_index)
                y(:,kk) = counts{mass_index(kk)}(jj,plane_range);
            end;

            ROIsize=length(find(Maskimg==jj));
            y=y/ROIsize;            

            m=[];
            for kk=1:length(masses)
                m{kk}=counts{kk}(jj,plane_range);
            end;

            % calculate depth profile of the ratio
            eval(formula);
            r_profile = r;
            
            % gather statistics from the depth profile
            out1 = [ std(r_profile(find(isfinite(r_profile)))) quantile(r_profile,[0.025 0.975]) ];
            % mean ratio value needs to be calculated from the accumulated counts
            m=[];
            for kk=1:length(masses)
                m{kk}=sum(counts{kk}(jj,plane_range));
            end;
            eval(formula);
            out{ii}(jj,:) = [r out1];

            % display depth profiles of the ion_counts/pixel and of the ratio
            % in the ROI, but only if its class is member of the
            % cellclasses specified by the user
            % NOTE: both ion counts and ratios will be normalized to mean
            % to highlight the variability
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
                    minr = sc(1) - diff(sc)/10;
                    maxr = sc(2) + diff(sc)/10;                
                    minr = floor(minr*100)/100;
                    maxr = ceil(maxr*100)/100;
                    sc = quantile(y_norm(:),[0.01 0.99]);
                    miny = sc(1) - diff(sc)/10;
                    maxy = sc(2) + diff(sc)/10;
                    miny = floor(miny*100)/100;
                    maxy = ceil(maxy*100)/100;
                    % set axes properties to make them look nicer
                    set(ax(1),'YColor',[1 0 0]);
                    set(get(ax(1),'Ylabel'),'String', sprintf('(%s) / %.2e',ratios{ii},r));
                    xlabel('plane')
                    title(sprintf('ROI %d (%c) [cvar=%2.0f%c]',cnum(jj),cid(jj),round(out1(1)/r*100),'%'));
                    set(ax(1),'FontSize',additional_settings.defFontSize);
                    set(ax(2),'FontSize',additional_settings.defFontSize);
                    mcols = 'gbmc';
                    for kk=1:length(h2)
                        set(h2(kk),'linestyle','none','Marker','.',...
                            'MarkerSize',12,'Color',mcols(kk));
                    end;
                    set(h1,'linestyle','-','Marker','x','Color','r');
                    set(ax(1),'ylim',[minr maxr],'xlim',[min(plane_range)-1 max(plane_range)],...
                        'ytick',linspace(minr,maxr,2));
                    set(ax(2),'ylim',[miny maxy],'xlim',[min(plane_range)-1 max(plane_range)],...
                        'ytick',linspace(miny,maxy,2));
                    a=0;
                end;
            end;
        end;

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

    else
        
        out{ii} = [];
        pdfout{ii} = [];
        
    end;
    
end;
