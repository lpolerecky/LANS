function im=apply_dtc(im, dtc, dwelling_time)

if dtc.apply_QSA
    fprintf(1,'Applying QSA correction ... ');
    for ii=1:length(im)
        im{ii} = double(im{ii})*(1+dtc.K(ii)/2);
    end
    fprintf(1,'Done.\n');
end

if dtc.apply_dtc
    fprintf(1,'Applying dead-time correction with dwell-time %.1f ms ... ', dwelling_time);
    for ii=1:length(im)
        % dwelling time is in ms, bkg is in counts per second
        % convert im to counts per second        
        a = double(im{ii})/(dwelling_time*1e-3); 
        % dt is in ns; calculate the corrected counts per second
        a = (a-dtc.bkg(ii)) ./ (1- (a-dtc.bkg(ii)) * dtc.dt(ii)*1e-9 )/dtc.y(ii);
        % for debugging:
        if 0
            figure; imagesc(im{ii}(:,:,1)); colorbar
            figure; imagesc(a(:,:,1)*1e-3); colorbar
            figure; imagesc(a(:,:,1)*1e-3 - double(im{ii}(:,:,1))); colorbar
        end
        % convert back to counts per dwelling time
        im{ii} = a*(dwelling_time*1e-3);
    end
    fprintf(1,'Done.\n');
end