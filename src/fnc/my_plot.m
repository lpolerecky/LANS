function my_plot(x,y,cs,par1,parval1,par2,parval2)
col=cs(1);
sym=cs(2);

colors = [0.9 0 0;
        0 0.8 0;
        0 0 0.8;
        0 0.8 0.8;
        0.9 0 0.8;
        0.9 0.9 0;
        0 0 0;
        0.9 0.9 0.9;
        1 0.5 0;
        0 0.5 1;
        1 0.65 0.8;
        0.76 0.60 0.42;
        0.13 0.55 0.13];
all_cols = 'rgbcmykwozpdf';
ii = find(all_cols==col);
if ~isempty(ii)
    c = colors(ii,:);
else
    c = 0.25*[1 1 1];
end

% change all "_" to "-" in tag, otherwise it's interpreted as LaTeX
% superscript
if strcmp(par2,'tag')
    parval2=regexprep(parval2,'_','-');
end

plot(x,y,sym,'MarkerEdgeColor',c,par1,parval1,par2,parval2);

