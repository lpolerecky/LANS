function print_figure(f, fname, print_factor, image_flag)

if nargin>3
    iflag = image_flag;
else
    iflag = 0;
end

global additional_settings;

%set(f, 'Color', 'none');  % Removes the full-canvas background rectangle
%set(f, 'InvertHardcopy', 'off');

matlab_release_year = str2double(regexp(version('-release'), '\d+', 'match', 'once'));

old_approach = 0;

if old_approach

    % this approach does not work if the function exportgraphics is used for 
    % printing the vector graphics 

    if length(print_factor)<2
        fpos=get(f,'Position');
        print_factor = print_factor*[fpos(3)/fpos(4) 1];
    end
    
    %set(f,'PaperPosition',[0.25 2.5 print_factor*5]);
    set(f,'PaperPosition',[0 0 print_factor*5]);

else

    % Find every object in the figure that has a 'FontSize' property
    all_text_objects = findobj(f, '-property', 'FontSize');
    oldFontSize = zeros(1,length(all_text_objects));
    
    % Loop through them and multiply their current font size
    for i = 1:length(all_text_objects)
        oldFontSize(i) = all_text_objects(i).FontSize;
        if all_text_objects(i).Visible == 'on'        
            all_text_objects(i).FontSize = additional_settings.defFontSize * print_factor(1);
        end
    end

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

    %% Export figure as a vector graphics pdf, including the correct bounding box
    
    % The compress_pdf flag was originally introduced for a different
    % purpose. However, from 21-11-2026, it is used to fix the issues with
    % the exported PDF, which is related to a bug in libreoffice, as
    % explained below.

    if ~additional_settings.compress_pdf

        % This is the original idea that works well except for
        % situations handled by the lines below.
        exportgraphics(figure(f), fname, 'ContentType', 'vector');

    else

        % The PDF exported using exportgraphics will cause issues if one
        % wants to include it in a presentation made by libreoffice.
        % Namely, the pdf file will be showed correctly in the presentation
        % itself, but if the presentation is exported into pdf, the
        % image/graph will not be included. This is, apparently, a bug in
        % libreoffice. To overcome this issue, gemini recommended to export
        % the file using 'print' and then use 'pdfcrop' to do the final
        % cropping. 'pdfcrop' can be installed in linux-mint using: 
        % sudo apt install texlive-extra-util 
        % On a MacOS, 'pdfcrop' is probably installed when latex is
        % installed. It probably also needs to have ghostscript installed.

        % create a temporary file name
        [a,~,c]=fileparts(fname);
        tmpfile = [a filesep 'temp' c];

        % here is the printing line
        print(figure(f), tmpfile, '-dpdf', '-vector');

        % prepare for pdf cropping
        if ismac
            global LATEXDIR;
            global GSDIR;
            cmd = sprintf('export PATH=$PATH:%s:%s; %s', LATEXDIR, GSDIR, 'pdfcrop');
        elseif isunix
            cmd = 'LD_LIBRARY_PATH=""; pdfcrop';
        elseif ispc
            cmd = 'pdfcrop';
        end

        % construct the final system call and execute it
        cmd = [cmd, ' ', tmpfile, ' ', fname];
        system(cmd);

        % delete the tmp file
        delete(tmpfile);
        
    end
    
end

fprintf(1,'Graphics exported to %s\n',fname);

% print also as PNG
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

if ~old_approach
    % bring the original fontsize back
    for i = length(all_text_objects):-1:1
        if all_text_objects(i).Visible == 'on'        
            all_text_objects(i).FontSize = oldFontSize(i);
        end
    end
end

% fprintf(1,'*** NOTE: ***\n')
% fprintf(1,'You can modify the appearance of the output graphics by changing the magnification\n');
% fprintf(1,'factors through the menu Output -> Additional output options\n');
% fprintf(1,'*** END NOTE: ***\n')
