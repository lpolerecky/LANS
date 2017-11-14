function fig=plot_2Dhist(x,y,xlims,ylims,Nbins,fig,xl,yl,log_flag)

global additional_settings;
edges{1}=linspace(xlims(1),xlims(2),Nbins+1);
edges{2}=linspace(ylims(1),ylims(2),Nbins+1);

[n,c]=hist3([x y],'Edges',edges);
fig=my_figure(fig);
subplot(1,1,1); hold off;
ind0=find(n==0);
n(ind0)=0.9*ones(size(ind0));
fprintf(1,'*** Displaying log10 of the 2D-histogram values...')
imagesc(c{1},c{2},log10(n'));
fprintf(1,'Done.\n');
set(gca,'ydir','normal')
add_title('2D-histogram plot of the 2D graph',[],additional_settings.defFontSize);
if log_flag
    xl = ['log(',xl,')'];
    yl = ['log(',yl,')'];
end;
xlabel(xl,'FontSize',additional_settings.defFontSize); 
ylabel(yl,'FontSize',additional_settings.defFontSize);
set(gca,'FontSize',additional_settings.defFontSize);
%colormap(clut(32));
colormap(get_colormap(additional_settings.colormap));
%cb=colorbar('FontSize',additional_settings.defFontSize);
%axes(cb);
%ylabel('log_{10}(counts)','FontSize',additional_settings.defFontSize)
cb=colorbar;
cb.Label.String = 'log(counts)';
cb.Label.FontSize = additional_settings.defFontSize;

%xlim(xlims);
%ylim(ylims);


