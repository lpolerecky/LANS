function [im, shift_columns_rows] = shift_columns_rows_images(im, shift_columns_rows)

% LP: for some unknown reason in some files the first or last columns or rows in the
% images are shifted as last or first one. Use this function to make sure that the
% columns are sorted properly immediately after the import of the data
% added 05-Sep-2017

if nargin==1
    % if shift_columns_rows is not specified, ask for it
    shift_columns_rows = get_shift_columns_rows([0 0 0 0]);
end


if sum(shift_columns_rows)>0
    
    for ii=1:length(im)
        for jj=1:size(im{ii},3)
            a = im{ii}(:,:,jj);
            [height, width] = size(a,[1 2]);
            if shift_columns_rows(1) > 0
                % Shift left-most columns to the right-most position
                a = [a(:, (1+shift_columns_rows(1)):width), ...
                     a(:, 1:shift_columns_rows(1))];                
            end
            if shift_columns_rows(2) > 0
                % Shift right-most columns to the left-most position
                a = [a(:, (width-shift_columns_rows(2)+1):width), ...
                     a(:, 1:(width-shift_columns_rows(2)))];                
            end
            if shift_columns_rows(3) > 0
                % Shift top-most rows to the lower-most position
                a = [a((1+shift_columns_rows(3)):height, :); ...
                     a(1:shift_columns_rows(3), :)];                
            end
            if shift_columns_rows(4) > 0
                % Shift lower-most rows to the top-most position
                a = [a((height-shift_columns_rows(4)+1):height, :); ...
                     a(1:(height-shift_columns_rows(4)), :)];
            end
            im{ii}(:,:,jj) = a;
        end
    end

    if shift_columns_rows(1) > 0
        fprintf(1,'WARNING: In all images, left-most %d column(s) were shifted to the right-most position.\n', ...
            shift_columns_rows(1));
    end

    if shift_columns_rows(2) > 0
        fprintf(1,'WARNING: In all images, right-most %d column(s) were shifted to the left-most position.\n', ...
            shift_columns_rows(2));
    end

    if shift_columns_rows(3) > 0
        fprintf(1,'WARNING: In all images, top-most %d row(s) were shifted to the lower-most position.\n', ...
            shift_columns_rows(3));
    end

    if shift_columns_rows(4) > 0
        fprintf(1,'WARNING: In all images, lower-most %d row(s) were shifted to the top-most position.\n', ...
            shift_columns_rows(4));
    end

end