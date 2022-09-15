function test_levene(x,g,r,cls,tt,metafile,ax,compare,handles,ef)
% test for variance homogeneity
defFontSize=10;

% test can be done only when there are multiple measurements for each group
if length(g)==length(unique(g))
    
    fprintf(1,'ERROR: Number of measurements of %s for each ROI is 1. ROIs cannot be compared now.\n', r);
    fprintf(1,'Compare classes or treatments.\n');
    
else
    
    % first, use Levene's test to see whether variances of x are homogeneous
    [p,stats]=vartestn(x,g,'off','robust');

    % calculate means, std, etc.
    [mm,ss,gn,nn]=grpstats(x,g,{'mean','std','gname','numel'});
    [mc]=grpstats(cls,g,{'mean'});
    [mt]=grpstats(tt,g,{'mean'});

    apos = get(ax,'position');
    hold off;
    
    % display boxplot
    %boxplot(ax,x,g,'orientation','horizontal');
    
    % add data points together with estimates of the density and quantiles
    %gu = unique(g);
    xks=linspace(quantile(x,0.001), quantile(x,0.995),100);
    for i=1:length(gn)
        if strcmp(compare,'treat')
            ii=find(g==str2num(gn{i}));
        else
            ii=find(g==gn{i});
        end
        xi=x(ii);
        f=ksdensity(xi,xks);        
        plot(xks,0.9*f/max(f)+(i),'b-');
        if i==1, hold on; end
        plot(xi,i*ones(size(xi)),'+','MarkerEdgeColor',[0 0.5 0])
        q1=quantile(xi,[0.25 0.5 0.75]);
        for j=1:length(q1)
            ij=find( abs(xks-q1(j))==min(abs(xks-q1(j))) );
            if j==2
                lj='k-';
            else
                lj='k--';
            end
            plot(q1(j)*[1 1],[i 0.9*f(ij)/max(f)+i],lj);
        end        
    end    
    
    % add also the mean values
    plot(mm,[1:length(mm)],'rs','MarkerFaceColor','r','MarkerSize',10);
    %hold on

    % set tick labels properly
    ylim([0.8 length(gn)+1.1])
    set(ax,'ytick',[1:length(gn)],'yticklabel',(gn))
    
    xlabel(r,'Fontsize',defFontSize)
    ylabel(compare,'Fontsize',defFontSize);
    set(handles.axes1,'Fontsize',defFontSize);

    set(ax,'position',apos);

    if ~get(handles.checkbox100,'value')
        xs=str2num(get(handles.edit1,'String'));
        set(handles.axes1,'xlim',xs);
        ys=str2num(get(handles.edit2,'String'));
        set(handles.axes1,'ylim',ys);
    end;
    
    if p<0.05
        title(sprintf('Variances are not homogeneous (LeveneQuadratic; p=%.2e)',p),...
			'Fontsize',defFontSize,'fontweight','normal');
    else
        title(sprintf('Variances are homogeneous (LeveneQuadratic; p=%.2e)',p),...
			'Fontsize',defFontSize,'fontweight','normal');
    end;

    % print text output to a default filename a, if export flag ef==1
    if ef
        
        a = construct_output_fname(metafile,r,compare,'tests','lev','.txt');
        
        [filepath filename ext]=fileparts(a);
        
        if 0 & isunix
            % use this if uiputfile crashes when using the default pathname as input            
            [FileName,PathName] = uiputfile('*.txt','Save statistical test as',[filepath delimiter]);
            if FileName == 0 & PathName == 0
                % when cancel pressed, the name will be constructed from
                % default filename
                PathName = [filepath delimiter];
                FileName = [filename ext];
            end;
        else
            % use this when uiputfile doesn't crash
            fprintf(1,'Warning: this is where Matlab can crash. test_levene.m: 61\n');
            [FileName,PathName] = uiputfile('*.txt','Save statistical test as',a);
        end;
                
        if length(PathName)>0 % if cancel was not pressed
            
            a = [PathName FileName];
            
            fid = fopen(a,'w');

            global LANS_version;
            fprintf(fid,'%c Generated by Look@NanoSIMS (version %s) on %s\n','%',LANS_version,datestr(now));

            if strcmp(compare,'ROI')
                fprintf(fid,'\nAnalysis of %s in ROIs from classes "%s":\n',r, char(unique(cls))');
            end;
            if strcmp(compare,'class')
                fprintf(fid,'\nAnalysis of %s averaged over ROIs from classes "%s":\n',r, char(unique(cls)));
            end;
            if strcmp(compare,'treat')
                fprintf(fid,'\nAnalysis of %s averaged over ROIs from class "%s":\n',r, char(unique(cls)));
            end;

            fprintf(fid,'------------------------------------------------------------------------\n');
            fprintf(fid,'mean\t\tstd_devi\t\t%s\t\tN\t\tc\t\tt\n',compare);
            fprintf(fid,'------------------------------------------------------------------------\n');
            for ii=1:length(mm)
                if strcmp(compare,'ROI') | strcmp(compare,'treat')
                    fprintf(fid,'%.4e\t\t%.4e\t\t%s\t\t%d\t\t%c\t\t%d\n',mm(ii),ss(ii),gn{ii},nn(ii),mc(ii),mt(ii));
                end;
                if strcmp(compare,'class')
                    if isempty(str2num(gn{ii}))
                        fprintf(fid,'%.4e\t\t%.4e\t\t%c\t\t%d\t\t%c\t\t%d\n',mm(ii),ss(ii),gn{ii},nn(ii),mc(ii),mt(ii));
                    else
                        fprintf(fid,'%.4e\t\t%.4e\t\t%c\t\t%d\t\t%c\t\t%d\n',mm(ii),ss(ii),str2num(gn{ii}),nn(ii),mc(ii),mt(ii));
                    end;
                end;                                
            end;
            fprintf(fid,'------------------------------------------------------------------------\n');
            fprintf(fid,'LeveneQuadratic test of variance homogeneity: p = %.2e\n',p);
            if p<0.05
                fprintf(fid,'Variances are not homogeneous.\nMeans should be compared using Kruskal-Wallis test.\n');
                title(sprintf('Variances are not homogeneous (LeveneQuadratic; p=%.2e)',p),...
					'Fontsize',defFontSize,'fontweight','normal');
            else
                fprintf(fid,'Variances are homogeneous.\nMeans can be compared using ANOVA.\n');
                title(sprintf('Variances are homogeneous (LeveneQuadratic; p=%.2e)',p),...
					'Fontsize',defFontSize,'fontweight','normal');
            end;

            % append also the actual data, for completeness
            fprintf(fid, '*********\nALL DATA:\ncls\ttmnt\t%s\n',r);
            out=[cls g x];
            fprintf(fid, '%c\t%d\t%.4e\n',out');
            
            fclose(fid);
            fprintf(1,'Results of statistical comparison saved in %s\n',a);

            % print as EPS, convert to PDF
            [filepath filename ext]=fileparts(a);
            filepath = fileparts(filepath);            
            a = [filepath delimiter 'eps' delimiter filename '.eps'];
            
            % set all objects except axes1 as invisible before printing
            set_stats_objects_visibility(handles,'off');
            
            global additional_settings;
            
            print_figure(handles.figure1,a,additional_settings.print_factors(5));
            %fprintf(1,'EPS output generated in %s\n',a);
            mepstopdf(a,'epstopdf',1,1);

            % set all objects back to visible
            set_stats_objects_visibility(handles,'on');
            
        end;      
        
    end;

end;
