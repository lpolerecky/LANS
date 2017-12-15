function print_figure(f,fname,print_factor)

[a b c]=fileparts(fname);
if ~exist(a)
    mkdir(a);
    fprintf(1,'Output folder created: %s\n',a);
end;

if length(print_factor)<2
    print_factor = print_factor*[1 1];
end;

set(f,'PaperPosition',[0.25 2.5 print_factor*5]);

if matversion>=2015
	print(f,fname,'-depsc');
else
	print(f,fname,'-depsc2');
end;

fprintf(1,'Graphics exported to %s\n',fname);

% print also as PNG
global additional_settings;
if additional_settings.export_png
    [pathstr, name, ext] = fileparts(fname);
    [pathstr] = fileparts(pathstr);
    pathstr = [pathstr delimiter 'png'];
    if ~exist(pathstr,'dir')
        mkdir(pathstr);
    end;
    fname = [pathstr delimiter name '.png'];
    print(f,fname,'-dpng');
    fprintf(1,'Graphics exported to %s\n',fname);
end;

% fprintf(1,'*** NOTE: ***\n')
% fprintf(1,'You can modify the appearance of the output graphics by changing the magnification\n');
% fprintf(1,'factors through the menu Output -> Additional output options\n');
% fprintf(1,'*** END NOTE: ***\n')
