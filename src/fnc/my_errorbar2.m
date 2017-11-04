function my_errorbar2(x,y,dx,dy,col)

global additional_settings;

if additional_settings.display_error_bars
    
    % add error bars to the graph
    hold on
    my_plotline([x(:)-dx(:) x(:)+dx(:)]',[y(:) y(:)]',[col,'-']);
    my_plotline([x(:) x(:)]',[y(:)-dy(:) y(:)+dy(:)]',[col,'-']);

else
    
    fprintf(1,'*** WARNING: Error bars not displayed. This can be modified through Preferences -> additional output options.\n');
    
end;