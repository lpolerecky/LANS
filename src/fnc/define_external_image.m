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
                subplot(1,2,1);
                image(ext_im);
                title('Original EXT image')
                set(gca,'dataaspectratio',[1 1 1]);
                % external image has more than 1 color channel. But right
                % now, only one channel is accepted. Thus, ask user which
                % channel he/she wants to select

                % find which channels are non-zeros
                nonzero_channels = zeros(1,size(ext_im,3));
                selected_channel = 0;
                max_sumchan = 0;
                for ii=1:size(ext_im,3)
                    chan = ext_im(:,:,ii);
                    sumchan = sum(chan(:));
                    if sumchan>0
                        nonzero_channels(ii) = 1;
                        if sumchan>max_sumchan
                            selected_channel = ii;
                            max_sumchan = sumchan;
                        end
                    end
                end
                rgb = 'rgb';
                answer = inputdlg(sprintf('External image has MULTIPLE non-zero channels.\nSelect ONE that you want to use. Options: %s', rgb(nonzero_channels>0)), ...
                    'Select EXT chanel',1,{rgb(selected_channel)});
                if ~isempty(answer)
                    selected_channel = find(rgb==answer{1});
                end
                fprintf(1,'Channel %d (%s) selected.\n', selected_channel, rgb(selected_channel));
                ext_im = ext_im(:,:,selected_channel);
                subplot(1,2,2)
                imagesc(ext_im)
                set(gca,'dataaspectratio',[1 1 1]);
                title(sprintf('Selected EXT channel: %s', rgb(selected_channel)));
                %colorbar;
                global additional_settings;
                colormap(get_colormap(additional_settings.colormap));
            end
        end
    end
end