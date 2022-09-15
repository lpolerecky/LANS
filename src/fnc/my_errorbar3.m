function my_errorbar3(x,y,z,dx,dy,dz,col)

%global additional_settings;

%if additional_settings.display_error_bars

    % add error bars to the graph
    hold on;
    my_plotline3([x(:)-dx(:) x(:)+dx(:)]',[y(:) y(:)]',[z(:) z(:)]',[col,'-']);
    my_plotline3([x(:) x(:)]',[y(:)-dy(:) y(:)+dy(:)]',[z(:) z(:)]',[col,'-']);
    my_plotline3([x(:) x(:)]',[y(:) y(:)]',[z(:)-dz(:) z(:)+dz(:)]',[col,'-']);

%else
    
    %fprintf(1,'*** WARNING: Error bars not displayed. This can be modified through Preferences -> additional output options.\n');
    
%end