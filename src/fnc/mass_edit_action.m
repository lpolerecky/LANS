function mass_edit_action(hObject,h,f)
% display image when the user pressed enter in the mass scale field

p = load_masses_parameters(h);

global additional_settings;

[opt1,opt3,opt4]=load_options(h,1);

scale=str2num(get(hObject,'string'));
tit1 = my_get(h.edit63,'string');
tit2 = h.p.mass{f};

if isfield(h.p,'im')
    if f<=length(h.p.im) 
        if h.p.planes_aligned
            
            if(~isfield(h.p,'Maskimg')) 
                h.p.Maskimg = zeros(size(h.p.im,1),size(h.p.im,2));
            else
                % always load it from the last saved cells file
                global CELLSFILE MAT_EXT;
                h.p.Maskimg = load_cells_from_disk(h,0,[CELLSFILE MAT_EXT]);                
            end;
            
            a = h.p.accu_im{f};
            
            plot_log=opt1(4);
            include_ROI_outlines = opt1(1);
            
            if plot_log
                if scale(1)==0
                    tmp_scale = find_image_scale(a(:),1,0);
                    scale(1)=tmp_scale(1);
                    %fprintf(1,'*** Warning: minimum scale was 0, but was set to %.3e due to logarithm scaling of the image.\n', scale(1));
                end;
            %    scale=log10(scale);
            %   mi=scale(1);
            %   ma=scale(2);
            %   if(mi==0)
            %        mi=1;
            %    end;
            %    logIM=scale(1)*ones(size(a));
            %    ind=find(a>0);
            %    logIM(ind)=log10(a(ind));
            %    mi=log10(mi);
            %    ma=log10(ma);
            %    scale=[mi ma];
            %    a=logIM;
            %    tit2 = ['log(' tit2 ')'];
            end;
            
            opt1 = zeros(15,1);
            opt1(1)=include_ROI_outlines; 
            opt1(6)=1; 
            opt1(15)=1; 
            opt1(4)=plot_log;
            plotImageCells(f,a,h.p.Maskimg,h.p.fdir,tit2,...
                [my_get(h.edit62,'string'),'-'],scale,...
                opt1,opt3(f), 0, h.p.scale, tit1, [], h.p.images{f},h.p.planes);

        else
            fprintf(1,'Planes do not seem to be accumulated yet. Please accumulate plane images.\n')';
        end;
    end;
end;
