function [Maskimg, cellname, mf] = load_cells_from_disk(handles,interactive,cname)

if(nargin>1)
    inter=interactive;
else
    inter=0;
end;

Maskimg = [];
cellname = [];
mf = [];

if isfield(handles,'p')

    p=handles.p;
    p.fdir = fixdir(p.fdir);

    % default mask image file:
    global CELLSFILE MAT_EXT
    cellname = [CELLSFILE MAT_EXT];

    % user specified mask image file
    if(~inter & nargin>2)
        cellname = cname;
    end

    if(inter)
        % choose the mask image file interactively
        
        def_file = [p.fdir CELLSFILE MAT_EXT];
        fprintf(1,'\n*** Select ROIs file (default %s)\n',def_file);
        fprintf(1,'If the file does not exit, or if you do not want to select it, click ''Cancel'' or press ''Esc''.\n');
        
        [FileName,newdir,newext] = uigetfile(['*' MAT_EXT], ['Select ROIs file (e.g. ' CELLSFILE MAT_EXT ')'], def_file);
        if(FileName~=0)
            mf = [newdir, FileName];
            cellname = FileName;
            jind=strfind(FileName,MAT_EXT);
            if jind>1
                CELLSFILE=cellname(1:(jind-1));
            else
                CELLSFILE=cellname;
            end;
        else
            %cellname = [];
            mf=[];
        end;
    else
        mf=[p.fdir,cellname];
    end;

    if(exist(mf)==2)
        disp(['ROIs loaded from ',mf]);
        eval(['load ',mf]);
    else
        disp(['ROIs image ',mf,' not found. Returning empty ROIs.']);
        global EXTERNAL_IMAGEFILE
        if exist(EXTERNAL_IMAGEFILE)
            tmp=imread(EXTERNAL_IMAGEFILE);
            Maskimg = zeros(size(tmp,1),size(tmp,2));
        else
            Maskimg = zeros(size(handles.p.accu_im{1},1),size(handles.p.accu_im{1},2));
        end;
    end;
    
    % display loaded cells
    global additional_settings;
    if additional_settings.always_display_rois && interactive
        my_figure(10);
        imagesc(Maskimg); colormap(clut(max(Maskimg(:))+1));
        addCellNumbers(10,Maskimg);
        set(gca,'DataAspectRatio',[1 1 1]);%,'xtick',[],'ytick',[]);
    end
    
else
    
    fprintf(1,'*** Error: Nothing loaded, nothing done.\n');
    
end;