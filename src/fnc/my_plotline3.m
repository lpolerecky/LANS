function my_plotline3(x,y,z,cl)
col=cl(1);
lin=cl(2);

if(ismember(col,'rgbmck'))
    plot3(x,y,z,[col,lin]);
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
    plot3(x,y,z,lin,'Color',c);
end;
