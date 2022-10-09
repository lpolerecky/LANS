function [t1, t2, xyz, varnames] = read_data_from_input_files(s, fname, xyz, ct, tmnt, varnames)

global correction_settings;

for j=1:length(xyz)
    b=[]; c=[]; d=[]; e=[]; f=[]; g=[];
    for k=1:min([ 6 length(xyz{j}) ]) % we assume that k is always at least 1, otherwise exporting data doesn't make sense

        q = lower(xyz{j}{k});
        if strcmp(q,'size')
            if isempty(c)
                fprintf(1,'ERROR: Values of size are empty. size should not be the first variable in the metafile.\n');
            else
                a=c;
            end
        elseif strcmp(q,'pixel') 
            if isempty(d)
                fprintf(1,'ERROR: Values of pixel are empty. pixel should not be the first variable in the metafile.\n');
            else
                a=d;
            end
        elseif strcmp(q,'x') 
            if isempty(e)
                fprintf(1,'ERROR: Values of x are empty. x should not be the first variable in the metafile.\n');
            else
                a=e;
            end
        elseif strcmp(q,'y') 
            if isempty(f)
                fprintf(1,'ERROR: Values of y are empty. y should not be the first variable in the metafile.\n');
            else
                a=f;
            end                    
        elseif strcmp(q,'l2w') || strcmp(q,'lw') || strcmp(q,'lwratio')
            if isempty(g)
                fprintf(1,'ERROR: Values of l2w are empty. l2w should not be the first variable in the metafile.\n');
            else
                a=g;
            end
        else
            
            %% load data
            % here is where the data is loaded from a 'dac' file previously
            % exported by LANS in the 'dat' subfolder for each dataset
            fncells = [s.base_dir, fname{j}, delimiter, s.classificationfile];            
            fn = [s.base_dir, fname{j}, delimiter, 'dat', delimiter, xyz{j}{k}, '.dac'];
            [a,b,c,d,e,f,g,cls] = load_xyz_data(fn, fncells, xyz{j}{k}, ct{j});  
            classes{j} = cls;
            
            %% apply corrections, calculate rate constants
            % (only 6 variables supported, due to GUI limits)
            if k<=length(correction_settings.correction_apply)
                % apply corrections
                if correction_settings.correction_apply(k)
                    % search for class based on which corrections are to be
                    % made, and find the correction factor
                    corr_class = correction_settings.correction_classes(k);
                    corr_value = correction_settings.correction_values(k);
                    % apply correction
                    a_new = make_data_correction(a, cls, corr_class, corr_value, k, xyz{j}{k});
                    a = a_new;
                end
                % Calculate rate constants. k (implemented on 11-02-2019)
                if correction_settings.calculate_rate(k)
                    data_tmnt = tmnt(j);
                    [Lia, Locb] = ismember(data_tmnt,correction_settings.treatments);
                    if Lia
                        bkg = correction_settings.correction_values(k);
                        medium = correction_settings.medium_value{k}(Locb);
                        dt = correction_settings.incubation_times(Locb);
                        % calculate rate for all values in a (note: the
                        % input values of "a" may be modified by the
                        % correction above!)
                        a_new = calculate_rate(a, bkg, medium, dt, data_tmnt, k, xyz{j}{k}, fname{j});
                        a = a_new;
                        % modify also the name of the variable
                        xyz{j}{k}=sprintf('k(%s)', xyz{j}{k});
                        varnames{j}{k}=sprintf('k(%s)', varnames{j}{k});
                    else
                        fprintf(1,'WARNING: Treatment %d not included in the rate calculation settings. Rate not calculated for %s.\n',data_tmnt,fname{j});
                    end
                end
            end
    
            % at this point data for a given dataset and variable have been loaded
        end
        
        %% assign other properties, such as cell size (area), pixels, etc.
        if ~isempty(b)
            cellid{j}=b;
        end
        if ~isempty(c)
            cellarea{j}=c; 
        end
        if ~isempty(d)
            pixels{j}=d;
        end
        if ~isempty(e)
            xpos{j}=e;
        end
        if ~isempty(f)
            ypos{j}=f;
        end
        if ~isempty(g)
            l2w{j}=g;
        end
        
        xyz_data{j,k} = a;        
        
    end     
end

%% reformat data into a table
out_roi_properties=[];
out_data=[];
cnt=0;
out_roi_fname={};
roi_cnt=0;
for j=1:length(xyz)
    
    cellid_j = cellid{j};
    cellarea_j = cellarea{j};
    cellpixels_j = pixels{j};
    cellxpos_j = xpos{j};
    cellypos_j = ypos{j};
    celll2w_j = l2w{j};
    cellclass_j = classes{j};

    for ii=1:length(cellclass_j)
        out_jki = [];
        for k=1:size(xyz_data,2)
            out_jki = [out_jki xyz_data{j,k}{ii}];
        end
        for l=1:size(out_jki,1)
            cnt=cnt+1;
            out_roi_fname{cnt,1}=fname{j};
        end
        if ~isempty(out_jki)
            out_roi_properties = [out_roi_properties; ...
                j*ones(size(cellclass_j{ii},1),1), ...
                tmnt(j)*ones(size(cellclass_j{ii},1),1), ...
                cellclass_j{ii}, ...
                cellid_j{ii}, ...
                cellarea_j{ii}(:,1), ...
                cellpixels_j{ii}(:,1), ...
                celll2w_j{ii}(:,1:2), ...
                cellxpos_j{ii}(:,1), ...
                cellypos_j{ii}(:,1), ...
                [1:size(cellclass_j{ii},1)]'+roi_cnt];
            roi_cnt = size(out_roi_properties,1);
            out_data = [out_data; out_jki];
        end
    end
    
end

%% finally convert into a table
t1=table(out_roi_properties(:,1), ...
    out_roi_fname, ...
    out_roi_properties(:,2), ...
    out_roi_properties(:,3), ...
    out_roi_properties(:,4), ...
    out_roi_properties(:,5), ...
    out_roi_properties(:,6), ...
    out_roi_properties(:,7), ...
    out_roi_properties(:,8), ...
    out_roi_properties(:,9), ...
    out_roi_properties(:,10), ...
    out_roi_properties(:,11), ...
    'VariableNames',{'id';'file';'treatment'; ...
        'roi_class';'roi_id';'size';'pixels';'l2w';'dl2w';'xpos';'ypos';'roi_uid'});
t2=array2table(out_data);




%% extra correction (Meggie's data): subtract slope*x from y
%     slope = 0*4.71e-6;
%     for j=1:length(xyz)
%         xj = xyz_data{j,1};
%         yj = xyz_data{j,2};
%         fprintf(1,'correcting file %d (%s)\n', j, fname{j});
%         for k=1:length(xj)
%             xjk = xj{k}(:,1);
%             yjk = yj{k}(:,1);
%             % here is the correction
%             yjk = yjk - slope * xjk;
%             xyz_data{j,2}{k}(:,1) = yjk;
%         end        
%     end

        