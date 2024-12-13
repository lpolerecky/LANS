function ext_im=define_external_image(p)
ext_im=[];
if isfield(p,'fdir')
    [FileName,newdir,newext] = uigetfile({'*.mat';'*.bmp';'*.png';'*.tif'}, 'Define external image', p.fdir);
    if newdir==0 % this means cancel was pressed
        fprintf(1,'*** Warning: No external image selected.\n');
    else
        fname = [newdir FileName];              
        if exist(fname)
            %global EXTERNAL_IMAGEFILE;
            %EXTERNAL_IMAGEFILE=fname;
            fprintf(1,'External image loaded: %s\n',fname);
            [a b c]=fileparts(fname);
            if strcmp(c,'.mat')
                ei = load(fname);
                if isfield(ei,'ext')
                    ext_im=ei.ext.im;
                else
                    fprintf(1,'Error: unrecognized format. Check external image alignment.\n');
                end
            else
                ext_im=double(imread(fname));
                ma = max(ext_im(:));
                if ma>0
                    ext_im = ext_im/ma;
                end
            end
            figure;
            if size(ext_im,3)==1
                %ext_im = ext_im(:,:,1);
                %warndlg('External image was not B&W. Only the first channel (red) was selected.','Warning','modal');
                imagesc(ext_im);
                set(gca,'dataaspectratio',[1 1 1]);
                colorbar;
                global additional_settings;
                colormap(get_colormap(additional_settings.colormap));
            else
                image(ext_im);
                set(gca,'dataaspectratio',[1 1 1]);
            end;                            
        end;
    end;
end;