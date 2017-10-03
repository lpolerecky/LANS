function my_plot3(x,y,z,cs,par,parval)
col=cs(1);
sym=cs(2);

if(ismember(col,'rgbmck'))
    plot3(x,y,z,[col,sym],par,parval);
else
    switch col
        case 'o', c=[1 0.6 0];      % orange
        case 'y', c=[0.5 0.5 0.5];  % gray
        case 'l', c=[0 0.5 0];      % olive (dark green)
        case 'w', c=[0 0 0.6];      % wine (dark blue)
        case 'd', c=[0.8 0 0];      % brown=dark red
        case 'p', c=[0.6 0 0.6];    % purple
        case 'n', c=[0 0.6 0.6];    % dark cyan
    end;
    plot3(x,y,z,sym,'MarkerEdgeColor',c,par,parval);
end;