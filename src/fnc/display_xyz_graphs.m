function display_xyz_graphs(R, Ra, oall, p, opt1, cellfile, handles)
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
        y=R{i2}; yl=p.special{i2}; ys=p.special_scale{i2};
        z=R{i3}; zl=p.special{i3}; zs=p.special_scale{i3};
        if ~isempty(x) & ~isempty(y) & ~isempty(z)
            if(opt1(8))
                dx=oall{i1}(:,5); 
                dy=oall{i2}(:,5); 
                dz=oall{i3}(:,5); 
                special_x = Ra{i1}; % it's the same as oall{i1}(:,4)
                special_y = Ra{i2};
                special_z = Ra{i3};
            end;
        else
            error_flag = 1;
        end;
        plot3d=1;
    else
        if(i1>0 & i2>0)
            plot3d=0;
            x=R{i1}; xl=p.special{i1}; xs=p.special_scale{i1};
            y=R{i2}; yl=p.special{i2}; ys=p.special_scale{i2};
            if ~isempty(x) & ~isempty(y) & ~isempty(oall)
                if(opt1(8))
                    dx=oall{i1}(:,5); 
                    dy=oall{i2}(:,5); 
                    special_x = Ra{i1};
                    special_y = Ra{i2};
                end;
            else
                error_flag = 1;
            end;
        end;
        if(i1>0 & i3>0)
            plot3d=0;
            x=R{i1}; xl=p.special{i1}; xs=p.special_scale{i1};
            y=R{i3}; yl=p.special{i3}; ys=p.special_scale{i3};
            if ~isempty(x) & ~isempty(y) & ~isempty(oall)
                if(opt1(8))
                    dx=oall{i1}(:,5); 
                    dy=oall{i3}(:,5); 
                    special_x = Ra{i1};
                    special_y = Ra{i3};
                end;
            else
                error_flag = 1;
            end;
        end;
        if(i2>0 & i3>0)
            plot3d=0;
            x=R{i2}; xl=p.special{i2}; xs=p.special_scale{i2};
            y=R{i3}; yl=p.special{i3}; ys=p.special_scale{i3};
            if ~isempty(x) & ~isempty(y) & ~isempty(oall)
                if(opt1(8))
                    dx=oall{i2}(:,5); 
                    dy=oall{i3}(:,5); 
                    special_x = Ra{i2};
                    special_y = Ra{i3};
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
                my_figure(38);
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
                end;
                if opt1(10)
                    % export the data in case the user wants to use it for
                    % post-processing
                    xyfile0=[xl,'-vs-',yl,'-vs-',zl];
                    xyfile=[xyfile0,'-pix.dat'];
                    xyfile=convert_string_for_texoutput(xyfile);
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
                    xyfile=[xyfile0,'-pix.eps'];
                    xyfile=convert_string_for_texoutput(xyfile);
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
                my_figure(39);
                hold off;
                if(isempty(cidu))
                    plot3(special_x,special_y,special_z,'o','MarkerSize',12);
                    my_errorbar3(special_x,special_y,special_z,dx/2,dy/2,dz/2,'b');
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
                        end;
                    end;
                    for ii=1:length(cidu)
                        if ismember(cidu(ii),i4)
                            ind=find(cid==cidu(ii));
                            my_errorbar3(special_x(ind),special_y(ind),special_z(ind),dx(ind)/2,dy(ind)/2,dz(ind)/2,cc(ii));
                        end;
                    end;
                end;
                % add also the ROI numbers next to the points
                for ii=1:length(special_x)
                    if isempty(cid) 
                        text(special_x(ii),special_y(ii),special_z(ii),num2str(ii),'horizontalalignment','center','FontSize',8);
                    else
                        if ismember(cid(ii),i4)
                            text(special_x(ii),special_y(ii),special_z(ii),num2str(ii),'horizontalalignment','center','FontSize',8);
                        end;
                    end;
                end;
                xlabel(['x=' xl],'FontSize',defFontSize); 
				ylabel(['y=' yl],'FontSize',defFontSize); 
				zlabel(['z=' zl],'FontSize',defFontSize);
                set(gca,'FontSize',defFontSize,'box','on');
                if opt1(15)
                    add_title(p.fdir, additional_settings.title_length, defFontSize);
                end;
                if ~isempty(leg)
                    legend(leg,'Location','east'); 
                    legend(gca,'boxoff'); 
                end;                
                set(gcf,'color',[1 1 1])
                if(opt1(4))
                    set(gca,'xscale','log','yscale','log','zscale','log');
                end;
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
                    end;
                    xyfile=[p.fdir,'eps',delimiter,xyfile];
                    print_figure(figure(39),xyfile,additional_settings.print_factors(2));
                    mepstopdf(xyfile,'epstopdf');
                end;
            end;

        else

            % plot 2d graph of x-y, for all pixels
            if(opt1(7))
                my_figure(38);
                if ~isempty(cid)
                    % find pixels that belong to different ROI classes and
                    % plot them in different colors
                    % include only classes specified in the "Classes" field
                    xall=[]; yall=[]; class=[];
                    jleg=0;
                    for j=1:length(cidu)
                        if ismember(cidu(j),i4)
                            jleg=jleg+1;
                            ind = find(cid==cidu(j));
                            xc=[]; yc=[];
                            for i=1:length(ind)
                                indc = find(p.Maskimg == ind(i));
                                xc = [xc; x(indc)];
                                yc = [yc; y(indc)];
                            end;
                            if ~isempty(xc)
                                if jleg==1
                                    hold off;
                                else
                                    hold on;
                                end;
                                plot(xc,yc,[cc(j),'.']);
                            end;
                            leg{jleg}=['ROIs ',cidu(j)];
                            xall=[xall; xc];
                            yall=[yall; yc];
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
                    else
                        xall=x(:); yall=y(:);
                    end;
                    class = ones(length(xall),1);
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
                    print_figure(f2d,xyfile,additional_settings.print_factors(2));
                    mepstopdf(xyfile,'epstopdf');
                end;
            end;
            
            % plot the x-y graph for all ROIs
            if(opt1(8))                
                my_figure(39);
                hold off;
                if(isempty(cidu))
                    plot(special_x,special_y,'o','MarkerSize',14);
                    my_errorbar2(special_x,special_y,dx/2,dy/2,'b');
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
                        end;
                    end;
                    for ii=1:length(cidu)
                        ind=find(cid==cidu(ii));
                        if ismember(cidu(ii),i4)
                            my_errorbar2(special_x(ind),special_y(ind),dx(ind)/2,dy(ind)/2,cc(ii));
                        end;
                    end;
                end;
                % add also the ROI numbers next to the points
                for ii=1:length(special_x)
                    if isempty(cid)
                        text(special_x(ii),special_y(ii),num2str(ii),'horizontalalignment','center','FontSize',10);
                    else
                        if ismember(cid(ii),i4) 
                            text(special_x(ii),special_y(ii),num2str(ii),'horizontalalignment','center','FontSize',10);
                        end;
                    end;
                end;
                xlabel(xl,'FontSize',defFontSize); 
				ylabel(yl,'FontSize',defFontSize);
                if ~isempty(leg), legend(leg); legend(gca,'boxoff'); end;
                set(gca,'FontSize',defFontSize);
                if opt1(15)
                    add_title(p.fdir, additional_settings.title_length, defFontSize);
                end;
                if(opt1(4))
                    set(gca,'xscale','log','yscale','log');
                end;                
                if opt1(11)
                    % export this figure as eps
                    xyfile0=[xl,'-vs-',yl];
                    xyfile=convert_string_for_texoutput(xyfile0);
                    xyfile=[xyfile,'.eps'];                    
                    fdir = [p.fdir,'eps'];
                    if ~isdir(fdir)
                        mkdir(fdir);
                        fprintf(1,'Directory %s did not exist, so it was created.\n',fdir);
                    end;
                    xyfile=[p.fdir,'eps',delimiter,xyfile];
                    print_figure(figure(39),xyfile,additional_settings.print_factors(2));
                    mepstopdf(xyfile,'epstopdf');
                end;
            end;

        end;
        fprintf(1,'*** Note: Length of the error-bars corresponds to Poisson error.\n');
    
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

