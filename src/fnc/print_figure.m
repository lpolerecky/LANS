function print_figure(f,fname,print_factor)

[a, ~, ~]=fileparts(fname);
if ~isfolder(a)
    mkdir(a);
    fprintf(1,'Output folder created: %s\n',a);
end

if length(print_factor)<2
    fpos=get(f,'Position');
    print_factor = print_factor*[fpos(3)/fpos(4) 1];
end

%set(f,'PaperPosition',[0.25 2.5 print_factor*5]);
set(f,'PaperPosition',[0 0 print_factor*5]);

if matversion>=2015
    print(f,fname,'-depsc');
else
    print(f,fname,'-depsc2','-loose');
end

% some new ideas, not working too well
%     set(f, 'paperunits', 'centimeters');
%     set(f, 'PaperPosition', [0 0 12*print_factor]);
%     set(f, 'papersize', 12*print_factor);
%     fname = strrep(fname, [filesep 'eps'], [filesep 'pdf']);
%     fname = strrep(fname, '.eps', '.pdf');
%     print(f, '-dpdf', fname);

%% fprintf(1,'Graphics exported to %s\n',fname);

% print also as PNG
global additional_settings;
if additional_settings.export_png
    [pathstr, name, ~] = fileparts(fname);
    [pathstr] = fileparts(pathstr);
    pathstr = [pathstr delimiter 'png'];
    if ~exist(pathstr,'dir')
        mkdir(pathstr);
    end
    fname = [pathstr delimiter name '.png'];
    print(f,fname,'-dpng');
    fprintf(1,'Graphics exported to %s\n',fname);
end

% fprintf(1,'*** NOTE: ***\n')
% fprintf(1,'You can modify the appearance of the output graphics by changing the magnification\n');
% fprintf(1,'factors through the menu Output -> Additional output options\n');
% fprintf(1,'*** END NOTE: ***\n')
