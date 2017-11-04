function display_ratios_each_plane(handles)

p = load_masses_parameters(handles);

global additional_settings;

[opt1,opt3,opt4]=load_options(handles,0);

if(isempty(my_get(handles.edit63,'string')))
    tit=fixdir(p.fdir);
else
    tit = my_get(handles.edit63,'string');
end;

if opt1(6)    
          
        % calculate the ratio images for each plane
        % this is done by setting the accumulated image equal to the plane image
        % and is using the calculate_R_images function
        for ii=1:length(p.planes)
            for jj=1:length(p.accu_im)
                p.accu_im{jj} = double(p.im{jj}(:,:,ii));
            end;
            R = calculate_R_images(p, opt4, 0, opt1(16));
            for jj=1:length(R)
                if ~isempty(R{jj})
                    r.im{jj}(:,:,ii) = R{jj};
                end;
            end;
        end;
        
        % remove empty stuff from r
        k=0;
        for ii=1:length(r.im)
            if ~isempty(r.im{ii})
                k=k+1;
                im{k} = r.im{ii};
                special_scale{k} = p.special_scale{ii};
                special{k} = p.special{ii};
            end;
        end;
        
        % display the ratio images
        show_stack_win6(im,special_scale,special,p.fdir,'r');
        
end;
a=0;
