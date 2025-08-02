function display_sdm_ranks(sdm, nms, minmaxband, ranking, ax)

% font size
fs=8;

Nc = size(sdm,1);
y=[Nc:-1:1]';

% display the ranking of the cells
axes(ax);
% remove everything from the axes first
cax = get(ax,'children');
for ii=1:length(cax)
    delete(cax(ii));
end;

set(ax,'xlim',[min(min(minmaxband(:,2:3))) max(max(minmaxband(:,2:3)))],'ylim',[min(y)-1 max(y)+1]);

% add the patches for each rank, incl. the rank name
for jj=1:size(minmaxband,1)        
    patch([minmaxband(jj,2) minmaxband(jj,3) minmaxband(jj,3) minmaxband(jj,2)],...
        [min(y)-1 min(y)-1 max(y)+1 max(y)+1],[jj jj jj jj], ...
        'FaceAlpha',0.5);
    if jj==1, hold on; end;
    text(mean(minmaxband(jj,2:3)), 1.01*(max(y)-min(y)+2),...
        [num2str(minmaxband(jj,1))], 'HorizontalAlignment','center'); %,'FontSize',14);
end;

% add the mean values as squares, 95% confidence intervals of the means
% as lines, and standard errors as 'x'
plot(ranking(:,1),y,'ks',...
    ranking(:,2:3)',[y y]','k-',...
    [ranking(:,1) ranking(:,1)]'+[-ranking(:,4)/2 ranking(:,4)/2]',[y y]','kx');

axis tight
set(ax,'ylim',[min(y)-1 max(y)+1],'ytick',sort(y),'yticklabel',flipud(nms)); %'FontSize',14);




