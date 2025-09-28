function special_edit_action(hObject,h,f)
% display image when the user pressed enter in the ratio scale field

p = load_masses_parameters(h);

global additional_settings;

[opt1,opt3,~]=load_options(h,0);

scale = str2num(get(hObject,'string'));

% find out the title of the graph
if(isempty(my_get(h.edit63,'string')))
    tit1=fixdir(p.fdir);
else
    tit1 = my_get(h.edit63,'string');
end
if tit1(end)==filesep
    tit1=tit1(1:(end-1));
end

if f<=length(p.special)
    
    tit2 = p.special{f};

    %sic_mass = str2num(get(h.edit65,'string'));
    sic_mass = get(h.edit65,'string');

    if ~p.planes_aligned

        fprintf(1,'*** Warning: Align and accumulate planes first before analyzing ratio images.\n');

    else

        opt4 = zeros(8,1);
        opt4(f) = 1;

        if ~isfield(p,'Maskimg')
            p.Maskimg = zeros(size(p.accu_im{1}));
        else
            % always load it from the last saved cells file
            global CELLSFILE MAT_EXT;
            p.Maskimg = load_cells_from_disk(h,0,[CELLSFILE MAT_EXT]);
        end

        [a,~,~,~,aconf] = calculate_R_images(p, opt4, 0, opt1(16), sic_mass);

        if iscell(a)
            a=a{f};
        end
        if iscell(aconf)
            aconf = aconf{f};
        end

        plot_log=opt1(4);
        include_ROI_outlines = opt1(1);

        if plot_log & ~isempty(scale)
            
            if scale(1)==0
                tmp_scale = find_image_scale(a, 0, additional_settings.autoscale_quantiles, plot_log, 0, tit2);
                scale(1) = tmp_scale(1);                
            end
        end

        opt1 = zeros(15,1);
        opt1(1)=include_ROI_outlines; 
        opt1(6)=1; 
        opt1(15)=1; 
        opt1(4)=plot_log;
        if ~isempty(a)
            plotImageCells(10+f,a,p.Maskimg,p.fdir,tit2,...
                [my_get(h.edit62,'string'),'-'],scale,...
                opt1,opt3(f), 0, p.scale, tit1, [], p.images{1},p.planes,aconf);    
        end

    end

else
    
    fprintf(1,'No expression detected. Nothing done.\n');
    
end

figure(h.figure1);
