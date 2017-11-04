function autoupdate_cell_classification(CELLS, ind, cellfile, auto_class_update, vc)
if(~isempty(cellfile))
    % determine ID of the added cell
    if(~isempty(ind))
        new_cell_id = median(CELLS(ind));
    else
        new_cell_id = 0;
    end;

    if(new_cell_id>0)
        % this means that a cell was added
        fprintf(1,'Added ROI number %d\n',new_cell_id);
        % update cell classification by inserting 'i' at the position of the newly
        % added cell
        [cidu,cc,cid,cnum,ss]=load_cell_classes(cellfile);
        if(new_cell_id>1)
            cid2=cid(1:new_cell_id-1,1);
        else
            cid2=[];
        end;
        cid2(new_cell_id,1)='i';
        if(length(cid)>=new_cell_id)
            cid2=[cid2; cid(new_cell_id:length(cid),1)];
        end;    
    else
        % this means that a cell was removed
        %fprintf(1,'Removed cell ID: %d\n',vc);
        % update cell classification by removing the letter at the position of
        % the removed cell
        [cidu,cc,cid,cnum,ss]=load_cell_classes(cellfile);
        if(vc>1)
            cid2=cid(1:vc-1,1);
        else
            cid2=[];
        end;
        if(length(cid)>vc)
            cid2=[cid2; cid((vc+1):length(cid),1)];
        end;
    end;

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
            [pathstr, name, ext] = fileparts(cellfile);
            new_cellfile = [pathstr,delimiter,name,'.new'];
        end;
    end; 

    % update classification file
    fid=fopen(new_cellfile,'w');
    out=[[1:length(cid2)]' double(cid2)];
    fprintf(fid,'%d\t%c\n',out');
    fclose(fid);    
    fprintf(1,'Classification in %s updated.\n',new_cellfile);
    
end;