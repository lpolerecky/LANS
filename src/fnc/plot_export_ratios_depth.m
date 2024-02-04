function plot_export_ratios_depth(m, dm, cell_sizes, images, planes, opt1, opt4, ratios, mass, fdir, print_factor)
% Display depth profiles of ratios for all cells.
% Export as EPS and ASCII, if requested.
% Because there can be many cells, the plotting is done in a specially
% designeg GUI.
% (c) Lubos Polerecky, 03-07-2011

if ~isempty(m) && ~isempty(dm)
    
    Nc=size(m{1},1);
    M=length(ratios);

    x=images{1};
    if isempty(x)
        x=planes;
    end
    
    k=0; % count of truly displayed ratios
    
    for ii=1:M

        if opt4(ii) & ~isempty(ratios{ii})
            
            k = k+1;

            warning_printed = 0;

            Np = length(x);
            out = zeros(Np,Nc*2);
            pol = zeros(1,Nc);
            
            [formula PoissErr] = parse_formula_lans(ratios{ii},mass);

            % calculate ratio and its PE based on the formulas
            % set Np to 1 temporarily when calculating per plane signals
            Np=1;
            eval(formula);
            eval(PoissErr);
            Np=length(x);
            
            % make sure that there are no NaN's or Inf in the output; if
            % there are, set them to 0
            ind=unique([find(~isfinite(per)) find(isnan(per))]);
            per(ind) = zeros(size(ind));
            
            % fix indexing:
            % if the original data were loaded with selected planes and saved
            % as "full processed", then when the data is loaded again as "full processed",
            % the planes in the GUI are set as [], but planes in the input of
            % this function is still correctly set as those selected
            % planes. This causes error in indexing.
            
            x_ind = x;
            if length(x_ind)==size(r,2)
                x_ind = x_ind - min(x_ind) + 1;
            end
            
            % calculate ratios and Poisson errors for all ROIs
            for jj=1:Nc               

                y=r(jj,x_ind);
                dy=r(jj,x_ind).*per(jj,x_ind);

                % remember output in out for export as ascii and EPS
                out(:,(jj-1)*2+[1:2]) = [y(:) dy(:)];

                % announce if there is a significant trend
                p = signif_fit(x(:),y(:),'mass',0.05, 0);
                pol(jj) = p;
                if p>0
                    if ~warning_printed
                        fprintf(1,'*** Warning: ratio %s has a significant trend with depth for ROI(s):\n',ratios{ii});
                        warning_printed = 1;
                    end
                    fprintf(1,'%d ', jj);
                end

            end
            
            if warning_printed, fprintf(1,'\n'); end
            
            % remember results for later plotting
            all_x{k} = x(:);
            all_ratios{k} = ratios{ii};
            all_out{k} = out;
            all_pol{k} = pol;

            % always export data as ASCII!
            if 1 %opt1(10)            
                a=convert_string_for_texoutput(ratios{ii});
                fname = [fdir, 'dat', delimiter, a, '-z.dat'];
                outdir = [fdir, 'dat', delimiter];
                if ~isdir(outdir)
                    mkdir(outdir);
                    fprintf(1,'Directory %s did not exist, so it was created.\n',outdir);
                end
                fid = fopen(fname,'w');
                fprintf(fid,'# %s: %s\n',fdir,ratios{ii});
                fprintf(fid,'# cell');
                for kk=1:Nc
                    fprintf(fid,'\tMEAN%d\tPoiss_E%d',kk,kk);
                end
                fprintf(fid,'\n# plane');
                for kk=1:Nc
                    fprintf(fid,'\tPOL=%d\t',pol(kk));
                end
                fprintf(fid,'\n');
                for jj=1:Np
                    fprintf(fid,'%d', x(jj));
                    fprintf(fid,'\t%.3e\t%.3e',out(jj,1:2*Nc));
                    fprintf(fid,'\n');
                end
                fclose(fid);
                fprintf(1,'Depth profiles of %s in defined ROIs saved as %s\n',ratios{ii},fname);
            end

        end

    end
    
    % plot depth profiles
    if k>0
        % fill the necessary input variables and call the gui for plotting
        % depth profiles
        data.x=all_x; 
        for ii=1:length(all_out)
            data.y{ii}=all_out{ii}(:,[1:2:2*Nc]); 
            data.dy{ii}=all_out{ii}(:,1+[1:2:2*Nc]);
        end
        data.pol=all_pol; 
        data.plot_flag=opt1(11);
        data.ratio = all_ratios;
        data.fdir = fdir;
        data.print_factor = print_factor;
        % here is the call to the actual GUI
        depth_profiles_ratios_gui(data);
    end
    
else
    fprintf(1,'*** Warning: Empty mass values. Nothing done.\n');
end