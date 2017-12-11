function special_edit_action(hObject,h,f)
% display image when the user pressed enter in the ratio scale field

p = load_masses_parameters(h);

global additional_settings;

[opt1,opt3,opt4]=load_options(h,0);

scale = str2num(get(hObject,'string'));
tit1 = my_get(h.edit63,'string');
if f<=length(p.special)
    
    tit2 = p.special{f};

    sic_mass = str2num(get(h.edit65,'string'));

    if ~p.planes_aligned

        fprintf(1,'*** Warning: Align and accummulate planes first before analyzing ratio images.\n');

    else

        opt4 = zeros(8,1);
        opt4(f) = 1;

        if ~isfield(p,'Maskimg')
            p.Maskimg = zeros(size(p.accu_im{1}));
        else
            % always load it from the last saved cells file
            global CELLSFILE MAT_EXT;
            p.Maskimg = load_cells_from_disk(h,0,[CELLSFILE MAT_EXT]);
        end;

        [a,b,c,d,aconf] = calculate_R_images(p, opt4, 0, opt1(16), 1, sic_mass);

        if iscell(a)
            a=a{f};
        end;
        if iscell(aconf)
            aconf = aconf{f};
        end;

        plot_log=opt1(4);
        include_ROI_outlines = opt1(1);

        if plot_log & ~isempty(scale)
            if scale(1)==0
                tmp_scale = find_image_scale(a(:),1,0);
                scale(1)=tmp_scale(1);
                %fprintf(1,'*** Warning: minimum scale was 0, but was set to %.3e due to logarithm scaling of the image.\n', scale(1));
            end;
        %    mi=scale(1);
        %    ma=scale(2);
        %    if(mi==0)
        %        mi=0.001;
        %        fprintf(1,'*** Warning: minimum scale was 0, but was set to 0.001 due to logarithm scaling of the image.\n');
        %    end;
        %    logIM=log10(mi)*ones(size(a));
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
        plotImageCells(10+f,a,p.Maskimg,p.fdir,tit2,...
            [my_get(h.edit62,'string'),'-'],scale,...
            opt1,opt3(f), 0, p.scale, tit1, [], p.images{1},p.planes,aconf);    

    end;

else
    
    fprintf(1,'No expression detected. Nothing done.\n');
    
end;