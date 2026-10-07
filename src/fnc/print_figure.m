function print_figure(f,fname,print_factor)

%[a, ~, ~]=fileparts(fname);
%if ~isfolder(a)
%    mkdir(a);
%    fprintf(1,'Output folder created: %s\n',a);
%end

if ismac

    % the approach that works for linux and windows (see below) does not
    % work under macos and Matlab2024b. this is a workaround.

    % Find every object in the figure that has a 'FontSize' property
    all_text_objects = findobj(f, '-property', 'FontSize');
    oldFontSize = zeros(1,length(all_text_objects));
    
    global additional_settings;

    % Loop through them and multiply their current font size
    for i = 1:length(all_text_objects)
        oldFontSize(i) = all_text_objects(i).FontSize;
        if all_text_objects(i).Visible == 'on'        
            all_text_objects(i).FontSize = additional_settings.defFontSize * print_factor(1);
        end
    end

else

    % under linux and win, adjustment of font size works by adjusting the
    % figure position by a factor

    if length(print_factor)<2
        fpos=get(f,'Position');
        print_factor = print_factor*[fpos(3)/fpos(4) 1];
    end

    %set(f,'PaperPosition',[0.25 2.5 print_factor*5]);
    set(f,'PaperPosition',[0 0 print_factor*5]);

end

% changed on 02-Sep-2026 to avoid issues with epstopdf and library version
% conflicts
%if matversion>=2015
%    print(f,fname,'-depsc');
%else
%    print(f,fname,'-depsc2','-loose');
%end

% If the filename contains eps, as may be the case if the older
% approach of exporting figures is used (via eps -> epstopdf -> pdf),
% replace eps by pdf. Do this in two steps, just in case the folder or
% file name contains 'eps'.
fname = strrep(fname, [delimiter 'eps' delimiter], [delimiter 'pdf' delimiter]);
fname = strrep(fname, '.eps', '.pdf');

% create output folder, if it does not exist yet
fdir = fileparts(fname);
if ~isfolder(fdir)
    mkdir(fdir)
    fprintf(1,'Directory %s did not exist, so it was created.\n', fdir);
end
% export figure as pdf, including the correct bounding box
exportgraphics(figure(f), fname, 'ContentType', 'vector');

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

if ismac
    % bring the original fontsize back
    for i = 1:length(all_text_objects)
        if all_text_objects(i).Visible == 'on'        
            all_text_objects(i).FontSize = oldFontSize(i);
        end
    end
end

% fprintf(1,'*** NOTE: ***\n')
% fprintf(1,'You can modify the appearance of the output graphics by changing the magnification\n');
% fprintf(1,'factors through the menu Output -> Additional output options\n');
% fprintf(1,'*** END NOTE: ***\n')
