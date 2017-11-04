function [out pdfout f30 cid] = display_depth_profiles_ROIS(m,dm,cid,cnum,images,masses,Maskimg,ratios,fname)

global additional_settings;

counts = m;
dcounts = dm;
plane_range = images{1};
if isempty(plane_range)
    plane_range = 1:size(m{1},2);
end;

out=[];
pdfout=[];

MAX_GRAPHS=12;

for ii=1:length(ratios)
        
    [formula PoissErr mass_index] = parse_formula(ratios{ii},masses);
    
    if ~isempty(mass_index)
        
        f30{ii}=figure(30+ii);

        Nrois = length(cid);

        nrows = ceil(MAX_GRAPHS/4);

        if Nrois>MAX_GRAPHS
            fprintf(1,'*** WARNING: Number of ROIs>%d. Depth profiles for only the first %d ROIs will be displayed.\n',MAX_GRAPHS,MAX_GRAPHS);
        end;

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

            if jj<=MAX_GRAPHS
                % display depth profiles of the ion_counts/pixel and of the ratio
                subplot(nrows, 4, jj);

                % transform r for better scaling
                sc = quantile(r,[0.01 0.99]);
                minr=floor(sc(1)*10)/10;
                maxr=ceil(sc(2)*10)/10;        
                fac = 1/10^floor(log10(maxr));
                r=r*fac;
                minr=minr*fac;
                maxr=maxr*fac;

                hold off;
                [ax,h1,h2]=plotyy(plane_range,y,plane_range,r,'semilogy','plot');

                set(get(ax(1),'Ylabel'),'String','counts/pixel') 
                if fac==1
                    set(get(ax(2),'Ylabel'),'String', ratios{ii})
                else
                    set(get(ax(2),'Ylabel'),'String',[num2str(fac) ' x ' ratios{ii}])
                end;
                xlabel('plane')
                title(sprintf('ROI %d (%c)',cnum(jj),cid(jj)));
                for kk=1:length(h1)
                    set(h1(kk),'linestyle','none');
                    set(h1(kk),'Marker','.');
                end;
                set(h2,'linestyle','none');        
                set(h2,'Marker','x');
                sc = quantile(y,[0.01 0.99]);
                miny = min(sc(1,:));
                if miny==0
                    miny=min(mean(y));
                end;
                maxy = max(sc(2,:));                
                miny=10^floor(log10(miny));
                maxy=10^ceil(log10(maxy));
                if miny~=0
                    yt=10.^linspace(log10(miny),log10(maxy),log10(maxy/miny)+1);
                    set(ax(1),'ylim',[miny maxy],'ytick',yt,'xlim',[min(plane_range) max(plane_range)]);
                else
                    yt=10.^linspace(log10(maxy*1e-3),log10(maxy),4);
                    set(ax(1),'ylim',[1e-3*maxy maxy],'ytick',yt,'xlim',[min(plane_range) max(plane_range)]);
                end;
                set(ax(2),'ylim',[minr maxr],'xlim',[min(plane_range) max(plane_range)]);
            end;

            % gather statistics from the depth profiles
            a=0;
            out1 = [ std(r(find(isfinite(r)))) quantile(r,additional_settings.autoscale_quantiles) ];
            % mean ratio value needs to be calculated from the accumulated counts
            m=[];
            for kk=1:length(masses)
                m{kk}=sum(counts{kk}(jj,plane_range));
            end;
            eval(formula);
            out{ii}(jj,:) = [r out1];

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
