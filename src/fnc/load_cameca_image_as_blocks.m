function handles = load_cameca_image_as_blocks(handles)

[imfile dname] = choose_im_file(handles, 1);

if isempty(imfile)
    p = [];
else
    
    ask_for_planes = strcmp(get(handles.ask_for_range,'checked'),'on');
    
    %block_size=input('Enter the amount of planes that should be accumulated (without allignment) as single planes: ');
    block_size=inputdlg('Enter block size. Planes in each block will be accumulated without allignment and treated subsequently as single planes:',...
        'Block size',1,{'1'});
    
    if isempty(block_size)
        block_size=1;
    else
        block_size=str2num(block_size{1});
    end;
            
    % determine first the output directory name
    newdir=[];
    for jj=1:length(dname{1})
        l1 = dname{1}(jj);
        l2=[];
        for ii=2:length(dname)
            l2 = dname{ii}(jj);
            if l2~=l1, break; end;
        end;
        if isempty(l2) | (l2==l1 & ii==length(dname))
            newdir(jj)=l1;
        else
            break;
        end;
    end;
    newdir = [char(newdir) 'blocks'];
    
    % create the directory where all the output will be stored
    if ~exist(newdir,'dir')
        mkdir(newdir);
    end;
    
    % load all the im files, accumulate the data in blocks, results will be
    % stored as separate planes
    for ii=1:length(imfile)   
        p=read_cameca_image(imfile{ii},ask_for_planes,0);
        p.im = apply_dtc(p.im,handles.dtc);
        if ii==1
            pout=p;            
        end;
        Nb = ceil(length(p.planes)/block_size);
        block_im = cell(1,length(p.im));
        for kk=1:length(p.im)
            block_im{kk} = zeros(size(p.im{kk},1),size(p.im{kk},2),Nb);
            for jj=1:Nb
                planes = [1:block_size]+(jj-1)*block_size;
                ind=find(planes<=length(p.planes));
                planes = planes(ind);
                fprintf(1,'Accumulating planes [%d:%d] (without alignment) for mass %s ...',min(planes),max(planes),p.mass{kk});
                block_im{kk}(:,:,jj) = sum(p.im{kk}(:,:,planes),3);
                fprintf(1,' Done\n');
            end;
        end;
        if ii==1
            pout.im = block_im;            
        else
            % add currently accumulated block_im at the end of the final
            % image stack
            for kk=1:length(pout.im)
                a=pout.im{kk}(:,:);
                al=size(pout.im{kk},3);                
                b=block_im{kk}(:,:);
                bl=size(block_im{kk},3);
                c=[a b];
                pout.im{kk}=reshape(c,p.width,p.height,al+bl);
            end;
        end;                    
    end;
    p.im = pout.im;    
    p.planes = [1:size(pout.im{1},3)];
    p.filename = newdir;

end;

% set as not aligned
p.planes_aligned = 0;

% if only one plane was read, then set aligned to 1 and fill the p.accu_im
% variable
if ~isempty(p.im)
    if size(p.im{1},3)==1
        p.planes_aligned=1;            
        for ii=1:length(p.im)
            p.accu_im{ii}=p.im{ii};
        end;
    end;
end;

% fill GUI objects based on what was read
fillinfo_detected_masses(handles, p, newdir); 

% fill additional paramters from the GUI, such as scaling
handles.p = p;
p = load_masses_parameters(handles);         

% remember everything
handles.p = p;

