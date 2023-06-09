function autoupdate_cell_classification(CELLS, ind, old2new, cellfile, auto_class_update, vc, changed_rois)

t1=clock;

if nargin<6
    vc=[];
end
if nargin>6
    chr = changed_rois;
else
    chr = vc;
end

if(~isempty(cellfile))
    % determine ID of the added/removed cell
    if(~isempty(ind))
        new_cell_id = median(CELLS(ind));
    else
        new_cell_id = 0;
    end

    if(new_cell_id>0)
        % this means that a cell was added
        fprintf(1,'Added ROI number %d\n',new_cell_id);
        % update cell classification by inserting 'i' at the position of the newly
        % added cell
        [~,~,cid,~,~]=load_cell_classes(cellfile);
        % old approach (prior to 10-Dec-2022)
        if 0
            if(new_cell_id>1)
                cid2=cid(1:new_cell_id-1,1);
            else
                cid2=[];
            end
            cid2(new_cell_id,1)='i';
            if(length(cid)>=new_cell_id)
                cid2=[cid2; cid(new_cell_id:length(cid),1)];
            end
        end
        % new approach (10-Dec-2022)
        cid2 = char('i'*ones(length(old2new),1));
        ind2=find(old2new<=length(cid));
        cid2(ind2) = cid;
        %a=0;

    else
        % this means that a cell was removed
        %fprintf(1,'Removed cell ID: %d\n',vc);
        % update cell classification by removing the letter at the position of
        % the removed cell
        [~,~,cid,~,~]=load_cell_classes(cellfile);
        if length(ind)>1
            % old approach (prior to 10-Dec-2022)
            if 0
                if(vc>1)
                    cid2=cid(1:vc-1,1);
                else
                    cid2=[];
                end
                if(length(cid)>vc)
                    cid2=[cid2; cid((vc+1):length(cid),1)];
                end
            end
            % new approach (10-Dec-2022)
            cid2 = cid(old2new);
        else
            % a pixel removal caused a ROI to be split, so now we need to
            % assign the classes to the new ROIs 
            % first, remove the roi that was changed
            cid2 = cid(setdiff(1:length(cid),vc));
            % now insert at the positions of changed rois the class of the
            % changed roi
            for i=1:length(chr)
                cid2 = [cid2(1:(chr(i)-1)); cid(vc); cid2(chr(i):end)];
            end
        end
    end

    % store the updated classification
    % determine the name of the new classification file
    if(strcmp(get(auto_class_update,'checked'),'on'))
        new_cellfile = cellfile;        
    else
        a=yes_no_dialog('title','Auto-update classification?',...
            'stringa','Yes',...
            'stringb','No, I will update it manually.',...
            'stringc','Cancel.');
        if(a==1)
            new_cellfile = cellfile;
        else
            [pathstr, name, ~] = fileparts(cellfile);
            new_cellfile = [pathstr,delimiter,name,'.new'];
        end
    end

    % update classification file
    out=[1:length(cid2); double(cid2')];
    fid=fopen(new_cellfile,'w');
    fprintf(fid,'%d\t%c\n',out);
    fclose(fid);    
    fprintf(1,'Classification in %s updated.\n',new_cellfile);
    
end

t2=clock;
global verbose
if verbose
    fprintf(1,'autoupdate_cell_classification.m: %.3fs\n',etime(t2,t1));    
end
