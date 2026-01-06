function display_xyz_graphs(R, Ra, oall, p, opt1, cellfile, handles, Rnom, Rdenom)
% display also x-y-z graphs, if requested

i1=str2num(my_get(handles.edit59,'string'));
i2=str2num(my_get(handles.edit60,'string'));
i3=str2num(my_get(handles.edit61,'string'));
i4=my_get(handles.edit64,'string');

error_flag = 0;

global additional_settings;

if isfield(additional_settings,'defFontSize')
    defFontSize = additional_settings.defFontSize;
else 
    defFontSize=10;
end;

if opt1(9)
    if(i1>0 & i2>0 & i3>0)
        x=R{i1}; xl=p.special{i1}; xs=p.special_scale{i1};
        xnom=Rnom{i1}; xdenom=Rdenom{i1};
        y=R{i2}; yl=p.special{i2}; ys=p.special_scale{i2};
        ynom=Rnom{i2}; ydenom=Rdenom{i2};
        z=R{i3}; zl=p.special{i3}; zs=p.special_scale{i3};
        znom=Rnom{i3}; zdenom=Rdenom{i3};
        if ~isempty(x) & ~isempty(y) & ~isempty(z)
            if(opt1(8))
                dx=oall{i1}(:,5); 
                dy=oall{i2}(:,5); 
                dz=oall{i3}(:,5); 
                special_x = oall{i1}(:,4);
                special_y = oall{i2}(:,4);
                special_z = oall{i3}(:,4);
            end;
        else
            error_flag = 1;
        end;
        plot3d=1;
    else
        if(i1>0 & i2>0)
            plot3d=0;
            x=R{i1}; xl=p.special{i1}; xs=p.special_scale{i1};
            xnom=Rnom{i1}; xdenom=Rdenom{i1};
            y=R{i2}; yl=p.special{i2}; ys=p.special_scale{i2};
            ynom=Rnom{i2}; ydenom=Rdenom{i2};
            if ~isempty(x) & ~isempty(y) & ~isempty(oall)
                if(opt1(8))
                    dx=oall{i1}(:,5); 
                    dy=oall{i2}(:,5); 
                    special_x = oall{i1}(:,4);
                    special_y = oall{i2}(:,4);
                end;
            else
                error_flag = 1;
            end;
        end;
        if(i1>0 & i3>0)
            plot3d=0;
            x=R{i1}; xl=p.special{i1}; xs=p.special_scale{i1};
            xnom=Rnom{i1}; xdenom=Rdenom{i1};
            y=R{i3}; yl=p.special{i3}; ys=p.special_scale{i3};
            ynom=Rnom{i3}; ydenom=Rdenom{i3};
            if ~isempty(x) & ~isempty(y) & ~isempty(oall)
                if(opt1(8))
                    dx=oall{i1}(:,5); 
                    dy=oall{i3}(:,5); 
                    special_x = oall{i1}(:,4);
                    special_y = oall{i3}(:,4);
                end;
            else
                error_flag = 1;
            end;
        end;
        if(i2>0 & i3>0)
            plot3d=0;
            x=R{i2}; xl=p.special{i2}; xs=p.special_scale{i2};
            xnom=Rnom{i2}; xdenom=Rdenom{i2};
            y=R{i3}; yl=p.special{i3}; ys=p.special_scale{i3};
            ynom=Rnom{i3}; ydenom=Rdenom{i3};
            if ~isempty(x) & ~isempty(y) & ~isempty(oall)
                if(opt1(8))
                    dx=oall{i2}(:,5); 
                    dy=oall{i3}(:,5); 
                    special_x = oall{i2}(:,4);
                    special_y = oall{i3}(:,4);
                end;
            else
                error_flag = 1;
            end;
        end;
    end;
        
    % load ROI classifications from the disk
    [cidu,cc,cid,cnum,ss]=load_cell_classes(cellfile);
    
    % if no classes for plotting were selected, select all
    if isempty(i4), i4=cidu(:)'; end;

    % if number of classified ROIs in the classification file differs from
    % the number of defined ROIs, issue warning and continue smoothly
    if opt1(8) & ~isempty(cid)
        if length(cid) > length(special_x)
            cnum = [1:length(special_x)];
            cid = cid(cnum);
            cidu = unique(cid);
            fprintf(1,'%s\n',upper('*** Warning: Number of classified ROIs greater than number of defined ROIs.'));
            fprintf(1,'%s\n',upper('             Consider revising ROI definition or classification file!\n'));
        elseif length(cid) < length(special_x)
            cnum1 = [1:length(special_x)];
            ind = setdiff(cnum1,cnum);
            cid(ind) = 'i'*ones(size(ind));
            cidu = unique(cid);
            cnum = cnum1(:);
            fprintf(1,'%s\n',upper('*** Warning: number of classified ROIs lower than number of defined ROIs.\n'));
            fprintf(1,'%s\n',upper('             Consider revising ROI definition or classification file!\n'));
        end;
    end;
       
    if ~error_flag
                
        if(plot3d)

            % plot 3d graph of x-y-z, for all pixels
            if(opt1(7))
                %my_figure(38);
                figure(38);
                ax=subplot(1,1,1);
                if ~isempty(cid)
                    % find pixels that belong to different ROI classes and
                    % plot them in different colors
                    % include only pixels of classes in the Classes field
                    xall=[]; yall=[]; zall=[]; class=[];
                    jleg=0;
                    for j=1:length(cidu)
                        if ismember(cidu(j),i4)
                            jleg=jleg+1;
                            ind = find(cid==cidu(j));
                            xc=[]; yc=[]; zc=[];
                            for i=1:length(ind)
                                indc = find(p.Maskimg == ind(i));
                                xc = [xc; x(indc)];
                                yc = [yc; y(indc)];
                                zc = [zc; z(indc)];
                            end;
                            if ~isempty(xc)
                                if jleg==1
                                    hold off;
                                else
                                    hold on;
                                end;
                                plot3(xc,yc,zc,[cc(j),'.']);
                            end;                            
                            leg{jleg}=['ROIs ',cidu(j)];
                            xall=[xall; xc];
                            yall=[yall; yc];
                            zall=[zall; zc];
                            class = [class; j*ones(length(xc),1)];
                        end;
                    end;
                    if ~isempty(leg), legend(leg); legend(gca,'boxoff'); end;
                else
                    % if no ROI classes were defined, just plot values for
                    % all pixels in ROIs
                    vc=setdiff(unique(p.Maskimg),0);
                    numObjects=length(vc);
                    if(numObjects>0)
                        ind=find(p.Maskimg>0);
                        xall=x(ind);
                        yall=y(ind);
                        zall=z(ind);
                    else
                        xall=x(:); yall=y(:); zall=z(:);
                    end;
                    class = ones(length(xall),1);
                    hold off;
                    plot3(xall,yall,zall,'.');
                end;
                % set the labels and scaling
                xlabel(['x=' xl],'FontSize',defFontSize); 
				ylabel(['y=' yl],'FontSize',defFontSize);
                zlabel(['z=' zl],'FontSize',defFontSize);
                set(gca,'FontSize',defFontSize,'box','on');
                set(gcf,'color',[1 1 1])
                if opt1(15)
                    add_title(p.fdir, additional_settings.title_length, defFontSize);
                end;
                if(opt1(4))
                    set(gca,'xscale','log','yscale','log','zscale','log');
                    fprintf(1,'WARNING: note that data-points with zero values are NOT visible in the log-log scatter plot.\n');
                end;
                if opt1(10)
                    % export the data in case the user wants to use it for
                    % post-processing
                    xyfile0=[xl,'-vs-',yl,'-vs-',zl];
                    xyfile0=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile0,'-pix.dat'];
                    fdir = [p.fdir,'dat'];
                    if ~isdir(fdir)
                        mkdir(fdir);
                        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
                    end;
                    xyfile=[p.fdir,'dat',delimiter,xyfile];
                    out = [class xall yall zall];
                    fid=fopen(xyfile,'w');
                    fprintf(fid,'#class\t%s\t%s\t%s\n',xl,yl,zl);
                    fprintf(fid,'%d\t%.4e\t%.4e\t%.4e\n',out');
                    fclose(fid);
                    fprintf(1,'Data exported to %s\n',xyfile);
                end;
                if opt1(11)
                    % export this figure as eps
                    xyfile0=[xl,'-vs-',yl,'-vs-',zl];
                    xyfile0=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile0,'-pix.eps'];
                    fdir = [p.fdir,'eps'];
                    if ~isdir(fdir)
                        mkdir(fdir);
                        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
                    end;
                    xyfile=[p.fdir,'eps',delimiter,xyfile];
                    print_figure(figure(38),xyfile,additional_settings.print_factors(2));
                    mepstopdf(xyfile,'epstopdf');
                end;
            end;

            % plot the x-y-z graph for all ROIs
            if(opt1(8))
                %my_figure(39);
                figure(39);
                ax=subplot(1,1,1);
                hold off;
                if(isempty(cidu))
                    plot3(special_x,special_y,special_z,'o','MarkerSize',12);
                    global additional_settings;
                    if additional_settings.display_error_bars
                        my_errorbar3(special_x,special_y,special_z,dx/2,dy/2,dz/2,'b');
                    end
                    hold on;
                    leg='all ROIs';
                else
                    leg=[]; jleg=0;
                    for ii=1:length(cidu)
                        if ismember(cidu(ii),i4)
                            ind=find(cid==cidu(ii));                                
                            plot3(special_x(ind),special_y(ind),special_z(ind),[cc(ii),ss(ii)],'MarkerSize',12);
                            hold on;
                            jleg=jleg+1;
                            leg{jleg}=['ROIs ',cidu(ii)];
                        end
                    end
                    global additional_settings;
                    if additional_settings.display_error_bars
                        for ii=1:length(cidu)
                            if ismember(cidu(ii),i4)
                                ind=find(cid==cidu(ii));
                                my_errorbar3(special_x(ind),special_y(ind),special_z(ind),dx(ind)/2,dy(ind)/2,dz(ind)/2,cc(ii));
                            end
                        end
                    end
                end
                % add also the ROI numbers next to the points
                for ii=1:length(special_x)
                    if isempty(cid) 
                        text(special_x(ii),special_y(ii),special_z(ii),num2str(ii),'horizontalalignment','center','FontSize',8);
                    else
                        if ismember(cid(ii),i4)
                            text(special_x(ii),special_y(ii),special_z(ii),num2str(ii),'horizontalalignment','center','FontSize',8);
                        end
                    end
                end
                xlabel(['x=' xl],'FontSize',defFontSize); 
				ylabel(['y=' yl],'FontSize',defFontSize); 
				zlabel(['z=' zl],'FontSize',defFontSize);
                set(gca,'FontSize',defFontSize,'box','on');
                if opt1(15)
                    add_title(p.fdir, additional_settings.title_length, defFontSize);
                end
                if ~isempty(leg)
                    legend(leg,'Location','east'); 
                    legend(gca,'boxoff'); 
                end
                set(gcf,'color',[1 1 1])
                if(opt1(4))
                    set(gca,'xscale','log','yscale','log','zscale','log');
                    fprintf(1,'WARNING: note that data-points with zero values are NOT visible in the log-log scatter plot.\n');
                end
                %axis tight
                if opt1(11)
                    % export this figure as eps
                    xyfile0=[xl,'-vs-',yl,'-vs-',zl];
                    xyfile=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile,'.eps'];                    
                    fdir = [p.fdir,'eps'];
                    if ~isdir(fdir)
                        mkdir(fdir);
                        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
                    end
                    xyfile=[p.fdir,'eps',delimiter,xyfile];
                    print_figure(figure(39),xyfile,additional_settings.print_factors(2));
                    mepstopdf(xyfile,'epstopdf');
                end
            end

        else

            % plot 2d graph of x-y, for all pixels
            if(opt1(7))
                %f38=my_figure(38);
                f38=figure(38);
                ax=subplot(1,1,1);
                if ~isempty(cid)
                    % find pixels that belong to different ROI classes and
                    % plot them in different colors
                    % include only classes specified in the "Classes" field
                    xall=[]; yall=[]; class=[];
                    jleg=0;
                    CVx = []; CVy = [];
                    for j=1:length(cidu)
                        if ismember(cidu(j),i4)
                            jleg=jleg+1;
                            ind = find(cid==cidu(j));
                            xc=[]; yc=[];
                            xc_nom = []; xc_denom = [];
                            yc_nom = []; yc_denom = [];                            
                            for i=1:length(ind)
                                indc = find(p.Maskimg == ind(i));
                                xc = [xc; x(indc)];
                                yc = [yc; y(indc)];
                                if ~isempty(xnom) && ~isempty(xdenom) && ~isempty(ynom) && ~isempty(ydenom)
                                    xc_nom = [xc_nom; xnom(indc)];
                                    xc_denom = [xc_denom; xdenom(indc)];
                                    yc_nom = [yc_nom; ynom(indc)];
                                    yc_denom = [yc_denom; ydenom(indc)];
                                else
                                    if i==1
                                        fprintf(1,'Numerator or denominator empty. Nothing can be displayed.\n')
                                    end
                                end
                            end
                            if ~isempty(xc)
                                figure(f38);
                                if jleg==1
                                    hold off;
                                else
                                    hold on;
                                end                           
                                plot(xc,yc,[cc(j),'.']);
                            end
                            leg{jleg}=cidu(j);
                            xall=[xall; xc];
                            yall=[yall; yc];
                            class = [class; j*ones(length(xc),1)];

                            %% added 20-05-2018
                            % calculate variability of the ratios among
                            % pixels within ROIs of a given class
                            % NOTE: only "pure" ratios are supported (e.g.
                            % 13C/12C, or 1215N/12C14N), because for more
                            % complicated formulas the formula for the
                            % nominator and denominator is difficult to
                            % figure out and thus may me incorrect (see
                            % calculate_R_images.m)
                            if additional_settings.calculate_roi_variability
                                if ~isempty(xc_nom) && ~isempty(xc_denom)
                                    CVx(jleg,1:5) = get_variability_in_roi(xc_nom,xc_denom,xl,cidu(j),[cc(j),'.'],80+j);
                                end
                                if ~isempty(yc_nom) && ~isempty(yc_denom)
                                    CVy(jleg,1:5) = get_variability_in_roi(yc_nom,yc_denom,yl,cidu(j),[cc(j),'.'],90+j);
                                end
                            end
                            
                            % activate f38
                            figure(f38);
                            
                        end
                    end
                    
                    figure(f38);
                    if ~isempty(leg), legend(leg); legend(gca,'boxoff'); end
                                                                    
                else
                    % if no ROI classes were defined, just plot values for
                    % all pixels in ROIs
                    vc=setdiff(unique(p.Maskimg),0);
                    numObjects=length(vc);
                    if(numObjects>0)
                        ind=find(p.Maskimg>0);
                        xall=x(ind);
                        yall=y(ind);
                        if ~isempty(xnom) && ~isempty(xdenom) && ~isempty(ynom) && ~isempty(ydenom)
                            xc_nom = xnom(ind); xc_denom = xdenom(ind);
                            yc_nom = ynom(ind); yc_denom = ydenom(ind);
                        else
                            fprintf(1,'Numerator or denominator empty. Nothing can be displayed.\n')
                        end
                    else
                        xall=x(:); yall=y(:);
                        if ~isempty(xnom) && ~isempty(xdenom) && ~isempty(ynom) && ~isempty(ydenom)
                            xc_nom = xnom(:); xc_denom = xdenom(:);
                            yc_nom = ynom(:); yc_denom = ydenom(:);                        
                        else
                            fprintf(1,'Numerator or denominator empty. Nothing can be displayed.\n')
                        end
                    end
                    class = ones(length(xall),1);
                    
                    %% added 20-05-2018
                    % calculate variability of the ratios among
                    % pixels within ROIs of a given class
                    if additional_settings.calculate_roi_variability
                        if ~isempty(xc_nom) && ~isempty(xc_denom)
                            CVx = get_variability_in_roi(xc_nom,xc_denom,xl,cidu(j),[cc(j),'.'],80+j);
                        end
                        if ~isempty(yc_nom) && ~isempty(yc_denom)
                            CVy = get_variability_in_roi(yc_nom,yc_denom,yl,cidu(j),[cc(j),'.'],90+j);
                        end
                    end
                    
                    leg{1} = 'a';                    
                    figure(f38);
                    hold off;
                    plot(xall,yall,'.');
                    
                end;
                
                % set the labels and scaling
                xlim(xs);
                ylim(ys);
                xlabel(xl,'FontSize',defFontSize); 
				ylabel(yl,'FontSize',defFontSize);
                set(gca,'FontSize',defFontSize);
                if opt1(15)
                    add_title(p.fdir, additional_settings.title_length, defFontSize);
                end;                          
                xlims=xs;
                ylims=ys;
                xx=xall;
                yy=yall;                
                if(opt1(4))
                    set(gca,'xscale','log','yscale','log');
                    fprintf(1,'WARNING: note that data-points with zero values are NOT visible in the log-log scatter plot.\n');
                    % log-transform values, for later 2D histogram plotting
                    ind_log=find(xall>0 & yall>0);
                    xx=log10(xall(ind_log));
                    yy=log10(yall(ind_log));
                    global additional_settings;
                    if xlims(1)>0
                        xlims(1)=log10(xlims(1));
                    else
                        xlims(1)=quantile(xx,additional_settings.autoscale_quantiles(1));
                    end;
                    xlims(2)=log10(xlims(2));
                    if ylims(1)>0
                        ylims(1)=log10(ylims(1));
                    else
                        ylims(1)=quantile(yy,additional_settings.autoscale_quantiles(1));
                    end;
                    ylims(2)=log10(ylims(2));
                    %xlim(xlims);
                    %ylim(ylims);
                end;
                
                % display the range of the x and y scale in permil
                if 1
                    xlimits = get(gca, 'xlim');
                    ylimits = get(gca, 'ylim');
                    fprintf(1,'Limits of the scatter plot:\n');
                    fprintf(1,'X-limits: [%.3e %.3e] <=> [%.1f %.1f] permil\n', ...
                        xlimits, (xlimits/mean(xlimits)-1)*1e3)
                    fprintf(1,'Y-limits: [%.3e %.3e] <=> [%.1f %.1f] permil\n', ...
                        ylimits, (ylimits/mean(ylimits)-1)*1e3)
                end
                
                % plot data also as a 2D-histogram
                f2d=plot_2Dhist(xx,yy,xlims,ylims,50,48,xl,yl,opt1(4));
                if opt1(10)
                    % export the data in case the user wants to use it for
                    % post-processing
                    xyfile0=[xl,'-vs-',yl];
                    xyfile=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile,'-pix.dat'];
                    fdir = [p.fdir,'dat'];
                    if ~isdir(fdir)
                        mkdir(fdir);
                        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
                    end;
                    xyfile=[p.fdir,'dat',delimiter,xyfile];
                    out = [class xall yall];
                    fid=fopen(xyfile,'w');
                    fprintf(fid,'#class\t%s\t%s\n',xl,yl);
                    fprintf(fid,'%d\t%.4e\t%.4e\n',out');
                    fclose(fid);
                    fprintf(1,'Data exported to %s\n',xyfile);
                end;
                
                if opt1(11)
                    % export this figure as eps                
                    xyfile0=[xl,'-vs-',yl];
                    xyfile=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile,'-pix.eps'];
                    fdir = [p.fdir,'eps'];
                    if ~isdir(fdir)
                        mkdir(fdir);
                        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
                    end;
                    xyfile=[p.fdir,'eps',delimiter,xyfile];
                    print_figure(figure(38),xyfile,additional_settings.print_factors(2));
                    mepstopdf(xyfile,'epstopdf');
                    % export also the 2D histogram
                    xyfile=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile,'-hist2d.eps'];
                    fdir = [p.fdir,'eps'];
                    xyfile=[p.fdir,'eps',delimiter,xyfile];
                    print_figure(f2d,xyfile,additional_settings.print_factors(2)*[6/5 1]);
                    mepstopdf(xyfile,'epstopdf');
                end;
                
                % save the within-ROI variability results
                if additional_settings.calculate_roi_variability
                    fprintf(1,'Within-ROI variability results saved in:\n');
                    fout = [p.fdir 'dat' delimiter convert_string_for_texoutput(xl) '_cv.dat'];
                    fid = fopen(fout,'w');
                    fprintf(fid,'# Coefficient of variability (CV=sqrt(VAR)/MEAN): %s\n',xl);
                    fprintf(fid,'# class\texp.\tmodel.1\tmodel.2\tunexpl.1\tunexpl.2\n');
                    for i=1:size(CVx,1)
                        fprintf(fid,'%c\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n',leg{i},CVx(i,:));
                    end
                    fclose(fid);
                    fprintf(1,'%s: %s\n',xl,fout);
                    fout = [p.fdir 'dat' delimiter convert_string_for_texoutput(yl) '_cv.dat'];
                    fid = fopen(fout,'w');
                    fprintf(fid,'# Coefficient of variability (CV=sqrt(VAR)/MEAN): %s\n',yl);
                    fprintf(fid,'# class\texp.\tmodel.1\tmodel.2\tunexpl.1\tunexpl.2\n');
                    for i=1:size(CVy,1)
                        fprintf(fid,'%c\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n',leg{i},CVy(i,:));
                    end
                    fclose(fid);
                    fprintf(1,'%s: %s\n',yl,fout);
                end
                
            end
            
            % plot the x-y graph for all ROIs
            if(opt1(8))                
                %f2=my_figure(39);
                f2=figure(39);
                ax=subplot(1,1,1);
                hold off;
                if(isempty(cidu))
                    plot(special_x,special_y,'o','MarkerSize',14);
                    global additional_settings;
                    if additional_settings.display_error_bars
                        my_errorbar2(special_x,special_y,dx/2,dy/2,'b');
                    end
                    hold on;
                    leg=[]; %'all ROIs';
                else
                    leg=[]; ileg=0;
                    for ii=1:length(cidu)
                        ind=find(cid==cidu(ii));
                        % include the point in the plot only if the class was selected
                        if ismember(cidu(ii),i4)
                            plot(special_x(ind),special_y(ind),[cc(ii),ss(ii)],'MarkerSize',14);
                            hold on;
                            ileg=ileg+1;
                            leg{ileg}=['ROIs ',cidu(ii)];
                        end
                    end
                    global additional_settings;
                    if additional_settings.display_error_bars
                        for ii=1:length(cidu)
                            ind=find(cid==cidu(ii));
                            if ismember(cidu(ii),i4)
                                my_errorbar2(special_x(ind),special_y(ind),dx(ind)/2,dy(ind)/2,cc(ii));
                            end
                        end
                    end
                end
                % add also the ROI numbers next to the points
                global additional_settings;
                if additional_settings.display_roi_ids
                    roi_id = 1:length(special_x);
                    if isempty(cid)
                        text(special_x,special_y,num2str(roi_id'),'horizontalalignment','center','FontSize',10);
                    else
                        for ii=roi_id
                            if ismember(cid(ii),i4)
                                text(special_x(ii),special_y(ii),num2str(ii),'horizontalalignment','center','FontSize',10);
                            end
                        end
                    end
                end
                xlabel(xl,'FontSize',defFontSize); 
				ylabel(yl,'FontSize',defFontSize);
                if ~isempty(leg), legend(leg); legend(gca,'boxoff'); end;
                set(gca,'FontSize',defFontSize);
                if opt1(15)
                    add_title(p.fdir, additional_settings.title_length, defFontSize);
                end
                if(opt1(4))
                    set(gca,'xscale','log','yscale','log');
                    fprintf(1,'WARNING: note that data-points with zero values are NOT visible in the log-log scatter plot.\n');
                end
                % display the range of the x and y scale in permil
                if 1
                    xlimits = get(gca, 'xlim');
                    ylimits = get(gca, 'ylim');
                    fprintf(1,'Limits of the scatter plot:\n');
                    fprintf(1,'X-limits: [%.3e %.3e] <=> [%.1f %.1f] permil\n', ...
                        xlimits, (xlimits/mean(xlimits)-1)*1e3)
                    fprintf(1,'Y-limits: [%.3e %.3e] <=> [%.1f %.1f] permil\n', ...
                        ylimits, (ylimits/mean(ylimits)-1)*1e3)
                end
                if opt1(11)
                    % export this figure as eps
                    xyfile0=[xl,'-vs-',yl];
                    xyfile=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile,'.eps'];                    
                    fdir = [p.fdir,'eps'];
                    if ~isdir(fdir)
                        mkdir(fdir);
                        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
                    end
                    xyfile=[p.fdir,'eps',delimiter,xyfile];
                    % make the button invisible during printing
                    fb = findobj('tag','fit_button');
                    if ~isempty(fb)
                        set(fb,'Visible','off');
                    end
                    print_figure(figure(39),xyfile,additional_settings.print_factors(2));
                    mepstopdf(xyfile,'epstopdf');
                    if ~isempty(fb)
                        set(fb,'Visible','on');
                    end                    
                end
                
                % add button for fitting data
                %a=0;
                if ~isempty(f2)
                    % remember data in the scatter plot for the 'Fit data' function
                    global XY_DATA_SCATTER_PLOT1;
                    XY_DATA_SCATTER_PLOT1 = [special_x(:), dx(:), special_y(:), dy(:)];  
                    % define the button to call the 'Fit data' function
                    fb = findobj('tag','fit_button');
                    if isempty(fb)
                        btn1 = uicontrol(f2,'Style', 'pushbutton', 'String', 'Fit data',...
                            'Units','normalized', 'Position', [0.002 0.002 0.15 0.05],...
                            'BackgroundColor',[0 0.6 0],'ForegroundColor',[1 1 1],'FontWeight', 'bold', ...
                            'Callback', @getstats_in_2D_plot,'tag','fit_button',...
                            'Tooltip','Draw a polygon and calculate statistics on data inside it.');
                    end    
                end
                
            end

        end
        if opt1(8)
            global additional_settings;
            if additional_settings.display_error_bars
                fprintf(1,'*** Note: Length of the error-bars corresponds to Poisson standard error.\n');
            end
        end
    
    else
        
        fprintf(1,'*** Error: x-y-z graph could not be plotted. Check');
        if isempty(x)
            fprintf(1,' the definition of x');
        end;
        if isempty(y)
            fprintf(1,' the definition of y');
        end;
        if plot3d & isempty(z)
            fprintf(1,' the definition of z');
        end;
        if isempty(oall)
            fprintf(1,' the Export ASCII data checkbox');
        end;
        fprintf(1,'.\n');
        
    end;
        
end;      

