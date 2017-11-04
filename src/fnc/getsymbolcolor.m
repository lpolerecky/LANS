function [p1,p2,s]=getsymbolcolor(legend_scheme,cc,tmnt,k)

% define color and symbols for the different cells/treatments

if(legend_scheme==1)
    switch cc(k)
        case 'h', p1='r';
        case 'p', p1='b';
        case 'v', p1='g';
        case 'b', p1='k';
        otherwise, p1='k';
    end;
    p2='oxv+.^<>oxv+.^<>';
    s=['GREEN = Vegetative cell\n',...
       'RED   = Heterocyst\n',...
       'BLUE  = Polar body\n',...
       'BLACK = Background'];    
    for ii=sort(unique(cell2mat(tmnt)))
        s = [s,'\nT',num2str(ii),' = ', p2(ii)];
    end;
end;

if(legend_scheme==2)
    switch cc(k)
        case 'h', p1='o';
        case 'p', p1='.';
        case 'v', p1='x';
        case 'b', p1='v';
        otherwise, p1='o';
    end;
    % define the symbols (correspond to different treatments)
    p2='rgbkcmyrgbkcmy';
    s=['v = Vegetative cell\n',...
       'o = Heterocyst\n',...
       'x = Polar body\n',...
       '. = Background'];    
    for ii=sort(unique(cell2mat(tmnt)))
        s = [s,'\nT',num2str(ii),' = ', p2(ii)];
    end;
end;        

if(legend_scheme==3)
    switch cc(k)
        case 'a', p1='r';
        case 's', p1='g';
        case 'm', p1='b';
        otherwise, p1='k';
    end;
    p2='oxv+.^<>oxv+.^<>';
    s=['GREEN = Sulfate reducer\n',...
       'RED   = ANME\n',...
       'BLUE  = Unidentified\n',...
       'BLACK = Background'];    
    for ii=sort(unique(cell2mat(tmnt)))
        s = [s,'\nT',num2str(ii),' = ', p2(ii)];
    end;
end;

if(legend_scheme==2)
    switch cc(k)
        case 'a', p1='o';
        case 's', p1='.';
        case 'm', p1='v';
		case 'b', p1='x';
        otherwise, p1='v';
    end;
    % define the symbols (correspond to different treatments)
    p2='rgbkcmyrgbkcmy';
    s=['o = ANME\n',...
       '. = SR\n',...
       'v = Unclas\n',...
       'x = Background'];    
    for ii=sort(unique(cell2mat(tmnt)))
        s = [s,'\nT',num2str(ii),' = ', p2(ii)];
    end;
end;        