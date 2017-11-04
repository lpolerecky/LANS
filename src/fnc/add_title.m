function add_title(str, title_length, defFontSize)
titlestr=str;
if ~isempty(title_length) & length(titlestr)>title_length
    titlestr=['...',titlestr([(length(titlestr)-title_length):length(titlestr)])];
end;
title(titlestr,'interpreter','none','FontSize',defFontSize,...
    'HorizontalAlignment','center','fontweight','normal');