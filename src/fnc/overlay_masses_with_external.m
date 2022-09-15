function overlay_masses_with_external(handles,hObject)

p = load_masses_parameters(handles);

% it's better to flip the image so that it looks more
% natural in the 3D overlays
flipud_flag=1;

if isfield(p,'planes_aligned')
    if ~p.planes_aligned
        fprintf(1,'*** Warning: Accumulate planes first before displaying mass images!\n');    
    else
        
        [formula PoissErr mass_index] = parse_formula_lans('ext',p.mass);
        if isempty(mass_index)
            fprintf(1,'Empty file. Please select aligned external image first.\n');
        else
            
            % assemble the input for the GUI from masses
            if hObject == handles.overlay_mass_external
                [opt1,opt3,opt4]=load_options(handles,1);
                R_image=[];
                R_scale=[];
                R_name=[];       
                k=0;
                for i=1:length(opt4)
                    if opt4(i)==1
                        k=k+1;
                        R_image{k}=p.accu_im{i};
                        R_scale{k}=p.imscale{i};
                        R_name{k}=p.mass{i};
                        if flipud_flag
                            R_image{k} = flipud(R_image{k});
                        end;
                    end;
                end;
            end;
                
            % assemble the input for the GUI from the calculates ratio images
            if hObject == handles.overlay_ratio_external
                [opt1,opt3,opt4]=load_options(handles,0);
                [R,Ra,Raim,o] = calculate_R_images(p, opt4, 0, opt1(16));
                R_image=[];
                R_scale=[];
                R_name=[];       
                k=0;
                for i=1:length(opt4)
                    if opt4(i)==1
                        k=k+1;
                        R_image{k}=R{i};
                        R_scale{k}=p.special_scale{i};
                        R_name{k}=p.special{i};
                        if flipud_flag
                            R_image{k} = flipud(R_image{k});
                        end;
                    end;
                end;
            end;  
            
            % add also the actual external image to the list of images
            R_image{k+1} = p.accu_im{mass_index};
            if flipud_flag
                R_image{k+1} = flipud(R_image{k+1});
            end;
            R_scale{k+1} = p.imscale{mass_index};
            R_name{k+1} = p.mass{mass_index};

            % open the GUI
            if ~isempty(R_image)
                overlay_external_nanosims_gui(R_image, R_scale, R_name, p.fdir, R_image{k+1});
            else
                fprintf(1,'Nothing selected, nothing displayed. Please select at least one mass/ratio.\n')'
            end;
            
        end;
    end;        
else
    fprintf(1,'*** Error: No data. Please load a Cameca image dataset first.\n');
end;
