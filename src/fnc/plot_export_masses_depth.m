function plot_export_masses_depth(m, dm, images,planes, opt1, opt4, mass, fdir, print_factor)
% Display depth profiles of masses for all cells.
% Also export as EPS and ASCII, if requested.
% Because there can be many cells, the plotting is done in a specially
% designeg GUI.
% (c) Lubos Polerecky, 03-07-2011

if ~isempty(m) & ~isempty(dm)
    
    Nc=size(m{1},1);
    M=length(m);
    
    k=0; % count of truly displayed ratios

    for ii=1:M

        if opt4(ii)
            
            k = k+1;
            
            warning_printed = 0;

            x=images{ii};
            if isempty(x)
                x=planes;
            end;
            
            Np = length(x);
            out = zeros(Np,Nc*2);
            pol = zeros(1,Nc);
            
            for jj=1:Nc           

                y=m{ii}(jj,x);
                dy=dm{ii}(jj,x);

                % remember output in out for export as ascii and EPS
                out(:,(jj-1)*2+[1:2]) = [y(:) dy(:)];

                % announce if there is a significant trend
                p = signif_fit(x(:),y(:),'mass',0.05, 0);
                pol(jj) = p;
                if p>0
                    if ~warning_printed
                        fprintf(1,'*** Warning: mass %s has a significant trend with depth for ROI(s):\n',mass{ii});
                        warning_printed = 1;
                    end;
                    fprintf(1,'%d ', jj);
                end;           

            end;

            if warning_printed, fprintf(1,'\n'); end;
            
            % remember results for later plotting
            all_x{k} = x(:);
            all_masses{k} = mass{ii};
            all_out{k} = out;
            all_pol{k} = pol;
            
            % export data as ASCII, if requested
            if opt1(10)
                fname = [fdir, 'dat', delimiter, mass{ii}, '-z.dat'];
                outdir = [fdir, 'dat', delimiter];
                if ~isdir(outdir)
                    mkdir(outdir);
                    fprintf(1,'Directory %s did not exist, so it was created.\n',outdir);
                end;
                fid = fopen(fname,'w');
                fprintf(fid,'# %s: %s\n',fdir,mass{ii});
                fprintf(fid,'# cell');
                for kk=1:Nc
                    fprintf(fid,'\tMEAN%d\tPoiss_E%d',kk,kk);
                end;
                fprintf(fid,'\n# plane');
                for kk=1:Nc
                    fprintf(fid,'\tPOL=%d\t',pol(kk));
                end;
                fprintf(fid,'\n');
                for jj=1:Np
                    fprintf(fid,'%d', x(jj));
                    fprintf(fid,'\t%.3e\t%.3e',out(jj,1:2*Nc));
                    fprintf(fid,'\n');
                end;
                fclose(fid);
                fprintf(1,'Depth profiles of %s for defined ROIs saved as %s\n',mass{ii},fname);
            end;

        end;

    end;
    
    % plot depth profiles
    if k>0
        % fill the necessary input variables and call the gui for plotting
        % depth profiles
        data.x=all_x; 
        for ii=1:length(all_out)
            data.y{ii}=all_out{ii}(:,[1:2:2*Nc]); 
            data.dy{ii}=all_out{ii}(:,1+[1:2:2*Nc]);
        end;
        data.pol=all_pol; 
        data.plot_flag=opt1(11);
        data.ratio = all_masses;
        data.fdir = fdir;
        data.print_factor = print_factor;
        % here is the call to the actual GUI
        depth_profiles_masses_gui(data);
    end;
  
else
    fprintf(1,'*** Warning: Empty mass values. Nothing done.\n');
end;            