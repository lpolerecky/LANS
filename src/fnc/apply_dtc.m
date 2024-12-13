function im=apply_dtc(im, dtc, dwell_time)

if dtc.apply_dtc
    
    fprintf(1,'Applying dead-time correction with dwell time %.1f ms/pixel ... ', dwell_time);
    
    for ii=1:length(im)    
        
        % convert detected counts to count rate cnt/s, dwell time is in ms / pixel
        a = double(im{ii}) / (dwell_time*1e-3); 
        
        % bkg is in cnt/s
        a_bkg = a - dtc.bkg(ii);
        
        % dead-time corrected cnt/s (dt is in ns)
        a     = a_bkg ./ ( 1 - a_bkg * dtc.dt(ii) * 1e-9 ) / dtc.y(ii);
        
        % debug
        if 0
            figure; jj=1; 
            ajj=a(:,:,jj)*dwell_time*1e-3; imjj=double(im{ii}(:,:,jj));
            subplot(2,2,1); imagesc(imjj); colorbar
            subplot(2,2,2); imagesc(ajj); colorbar
            subplot(2,2,3); imagesc(ajj - imjj); colorbar
            subplot(2,2,4); hold off; 
            plot(imjj(:), ajj(:), '.');
            hold on; plot([0 max(ajj(:))], [0 max(ajj(:))], 'r-');
            xlabel('cnt measured'); ylabel('cnt dead-time corrected');
        end
        
        % convert back to counts per dwell time (cnt)
        im{ii} = a * (dwell_time*1e-3);
    end
    
    fprintf(1,'Done.\n');
    
end

if dtc.apply_QSA
    
    fprintf(1,'Applying QSA correction with FCo %.1f pA ... ', dtc.FCo);
    
    for ii=1:length(im)
        
        % convert detected counts to count rate cnt/s, dwell time is in ms / pixel
        a = double(im{ii}) / (dwell_time*1e-3); 
        
        % primary ion count rate at the sample surface, cnt/s
        N_pib = dtc.FCo * 6.24151e6;
        
        % apply qsa correction (Slodzian et al. 2004, doi:10.1016/j.apsusc.2004.03.155)
        
        % number of secondary ions created per primary ion (K)
        K_exp = a / N_pib;
        % corrected value
        K_cor = K_exp ./ (1 - K_exp/2);
        
        % QSA corrected cnt/s
        a     = a .* (1 + dtc.beta(ii) * K_cor);
        
        % debug
        if 0
            figure; jj=1;
            ajj=a(:,:,jj)*dwell_time*1e-3; imjj=double(im{ii}(:,:,jj));
            subplot(2,2,1); imagesc(imjj); colorbar
            subplot(2,2,2); imagesc(K_cor(:,:,jj)); colorbar
            subplot(2,2,3); imagesc(ajj - imjj); colorbar
            subplot(2,2,4); hold off; 
            plot(imjj(:), ajj(:), '.');
            hold on; plot([0 max(ajj(:))], [0 max(ajj(:))], 'r-');
            xlabel('cnt measured'); ylabel('cnt qsa corrected');
        end
        
        % convert back to counts per dwell time (cnt)
        im{ii} = a * (dwell_time*1e-3);
        
    end
    
    fprintf(1,'Done.\n');
    
end

