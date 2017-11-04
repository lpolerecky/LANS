function add_to_plot2d(x,y,cc,p1,p2,tmnt,xlab,ylab,grtitle,xscale,yscale,...
    logscalex,logscaley,disp_errorbars,fname,cellid,treatment)

for k=1:min([length(x) length(cc)])
    if(~isempty(x) & ~isempty(x{k}))
        
        % make data corrections, if necessary
        if 0
            [x,y,z,aumean]=make_data_correction(x,y,z,k,j);
        else
            aumean=0;
        end;
        
        for ii=1:size(x{k},1)
            tag=sprintf('ROI/CLASS/TREATMENT - FILE\n%d/%s/%d - %s',cellid{k}(ii),cc(k),treatment,fname);
            my_plot(x{k}(ii,1), y{k}(ii,1), [p1(k),p2(tmnt)],'markersize',10,'tag',tag); 
            if(ii==1), hold on; end;
            if(disp_errorbars)
                my_errorbar2(x{k}(ii,1), y{k}(ii,1), x{k}(ii,2), y{k}(ii,2), p1(k));
            end;
            % also add numbers of the treatment
            %tt=text(x{k}(ii,1), y{k}(ii,1), num2str(id{j}), 'FontSize',10,'Color',p1(k));
        end;
        
    end;
end;

global additional_settings;

xlabel(xlab,'FontSize',additional_settings.defFontSize);
ylabel(ylab,'FontSize',additional_settings.defFontSize);
title(grtitle,'FontSize',additional_settings.defFontSize,'interpreter','none');
set(gca,'box','on','FontSize',additional_settings.defFontSize);
if ischar(xscale)
    xscale=str2num(xscale);
end;
if ischar(yscale)
    yscale=str2num(yscale);
end;
if(~isempty(xscale))
    set(gca,'xlim',xscale);
end;
if(~isempty(yscale))
    set(gca,'ylim',yscale);
end;
set(gca,'FontSize',additional_settings.defFontSize);
if(logscalex)
    set(gca,'xscale','log');
else
    set(gca,'xscale','linear');
end;
if(logscaley)
    set(gca,'yscale','log');
else
    set(gca,'yscale','linear');
end;

