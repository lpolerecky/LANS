function mass_edit_action(hObject,h,f)
% display image when the user pressed enter in the mass scale field

p = load_masses_parameters(h);

global additional_settings;

[opt1,opt3,opt4]=load_options(h,1);

scale=str2num(get(hObject,'string'));
% find out the title of the graph
if(isempty(my_get(h.edit63,'string')))
    tit1=fixdir(p.fdir);
else
    tit1 = my_get(h.edit63,'string');
end;
if tit1(end)==filesep
    tit1=tit1(1:(end-1));
end;
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
                if isempty(scale)
                    scale = find_image_scale(a, 0, additional_settings.autoscale_quantiles, plot_log, 0, tit2);
                else
                    if scale(1)==0
                        tmp_scale = find_image_scale(a, 0, additional_settings.autoscale_quantiles, plot_log, 0, tit2);
                        scale(1) = tmp_scale(1);                    
                    end
                end
            end
            
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

figure(h.figure1)