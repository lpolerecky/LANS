function im = shift_columns_rows_images(im, shift_columns_rows)

if sum(shift_columns_rows)>0
    
    for ii=1:length(im)
        for jj=1:size(im{ii},3)
            a = im{ii}(:,:,jj);
            width = size(a,2);
            height = size(a,1);
            if shift_columns_rows(4)
                a=[a(:,2:width) a(:,1)];                
            end
            if shift_columns_rows(3)
                a=[a(:,width),a(:,1:width-1)];                
            end
            if shift_columns_rows(2)
                a=[a(2:height,:); a(1,:)];                
            end
            if shift_columns_rows(1)
                a=[a(height,:); a(1:height-1,:)];                
            end
            im{ii}(:,:,jj) = a;
        end
    end

    if shift_columns_rows(4)
        fprintf(1,'WARNING: In all images the 1st data column was shifted as the right-most one.\n');
    end

    if shift_columns_rows(3)
        fprintf(1,'WARNING: In all images the last data column was shifted as the 1st one.\n');
    end

    if shift_columns_rows(2)
        fprintf(1,'WARNING: In all images the 1st data row was shifted as the lower-most one.\n');
    end

    if shift_columns_rows(1)
        fprintf(1,'WARNING: In all images the last data row was shifted as the 1st one.\n');
    end

end