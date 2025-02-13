function handles = load_cameca_image_as_blocks(handles)

[imfile, dname] = choose_im_file(handles, 1);

if isempty(imfile)
    p = [];
else
    
    ask_for_planes = strcmp(get(handles.ask_for_range,'checked'),'on');
    
    new_block_size_input = inputdlg({'Enter block size. Planes in each block will be aligned and accumulated, and treated subsequently as single planes:',...
        'Use the same block size for all subsequent files (1=yes, 0=no)'},...
        'Block size', [1;1], {'1', '0'});
    
    if isempty(new_block_size_input)
        block_size = 1;
        use_same = 0;
    else
        block_size = str2num(new_block_size_input{1});
        use_same   = str2num(new_block_size_input{2});
    end
    
    % determine first the output directory name
    newdir=[];
    for jj=1:length(dname{1})
        l1 = dname{1}(jj);
        l2=[];
        for ii=2:length(dname)
            l2 = dname{ii}(jj);
            if l2~=l1, break; end
        end
        if isempty(l2) || (l2==l1 && ii==length(dname))
            newdir(jj)=l1;
        else
            break;
        end
    end
    newdir = [char(newdir) 'b' num2str(block_size)];
    
    % create the directory where all the output will be stored
    if ~exist(newdir,'dir')
        mkdir(newdir);
    end    
    
    % load all the im files, accumulate the data in blocks, results will be
    % stored as separate planes
    for ii=1:length(imfile)   
        
        p = read_cameca_image(imfile{ii},ask_for_planes,0);
        p.im = apply_dtc(p.im, handles.dtc, p.dwell_time);
        if ii==1
            pout=p;            
        end
        
        % fill GUI objects based on what was read
        fillinfo_detected_masses(handles, p, dname);
        
        % shift columns and rows just before accumulation
        [p.im, p.shift_columns_rows] = shift_columns_rows_images(p.im, handles.shift_columns_rows);
        
        if ii>1 && ~use_same
            % ask for the block-size every time a new im file is to be
            % loaded
            new_block_size_input = inputdlg({'Enter block size. Planes in each block will be aligned and accumulated, and treated subsequently as single planes:',...
                'Use the same block size for all subsequent files (1=yes, 0=no)'},...
                'Block size',[1;1],{num2str(block_size), num2str(use_same)});
            if ~isempty(new_block_size_input)
                block_size = str2num(new_block_size_input{1});
                use_same   = str2num(new_block_size_input{2});
            end
        end
    
        Nb = ceil(length(p.planes)/block_size);
        block_im = cell(1,length(p.im));
        
        % changed 03-07-2018: planes from the same block will be aligned
        % based on the "new" alignment algorithm and accumulated

        % fill m, which will be used later when r in the formula
        m=cell(size(p.im));
        for mi=1:length(m)
            m{mi} = double(p.im{mi});
        end

        % find the alignment tforms first        
        if block_size>1
            pp = load_masses_parameters(handles);
            [formula, ~, kalign] = parse_formula_lans(pp.alignment_mass,pp.mass);
            %kalign = identifyMass(pp.mass,pp.alignment_mass);
            if ~isfield(handles,'p')
                handles.p = p;
            end
            [~, ~, opt4]=load_options(handles, 1);                        
            
            % find details needed for accumulation of images in blocks
            for jj=1:Nb
                planes = [1:block_size]+(jj-1)*block_size;
                ind=find(planes<=length(p.planes));
                planes = planes(ind);
                
                if pp.find_alignments
                    alignmentregion_x = [10:(size(p.im{1},2)-10)];
                    alignmentregion_y = [10:(size(p.im{1},1)-10)];
                    if jj==1
                        fprintf(1,'Finding alignment of planes based on %s (%s).\n',pp.alignment_mass, formula);
                    end
                    % the ESI image can sometimes have signal spikes in some
                    % pixels, which makes the accumulated ESI image look ugly.
                    % here we remove these spikes.
                    global additional_settings;
                    if prod(additional_settings.smooth_esi_kernelsize)>1 && sum(ismember(lower({p.mass{kalign}}),'esi'))==1
                        esi_ind = find(ismember(lower({p.mass{kalign}}),'esi'));
                        esi_ind = kalign(esi_ind);
                        for kk=planes
                            if kk==1
                                fprintf(1,'WARNING: Signal spikes removed from %s data.\n',p.mass{esi_ind});
                            end                    
                            moving1 = double(squeeze(m{esi_ind}(:,:,kk)));
                            moving2 = medfilt2(moving1, additional_settings.smooth_esi_kernelsize);
                            m{esi_ind}(:,:,kk) = moving2;
                        end
                    end
                    % calculate the base image for alignment
                    eval(formula);
                    [tforms, images] = findimagealignments2(r,planes,alignmentregion_x, alignmentregion_y,0);
                    tforms_blocks{jj} = tforms(planes);
                    images_blocks{jj} = images;
                else
                    tforms_blocks{jj} = [];
                    images_blocks{jj} = planes;
                end                
                
            end
        
            % accumulate images in blocks for all masses
            fprintf(1,'Accumulating planes in blocks.\n');

            for kk=1:length(p.im)
                block_im{kk} = zeros(size(p.im{kk},1),size(p.im{kk},2),Nb);
            end
            for jj=1:Nb
                for kk=1:length(p.im)
                    all_images{kk} = [1:length(images_blocks{jj})];
                    all_im{kk} = m{kk}(:,:,images_blocks{jj});
                end          
                fprintf(1,'Images %d:%d in block %d.\n',min(images_blocks{jj}),max(images_blocks{jj}),jj);
                [accu_im]=accumulate_images2(all_im, tforms_blocks{jj}, p.mass, all_images, opt4);
                for kk=1:length(p.im)
                    block_im{kk}(:,:,jj) = accu_im{kk};
                end                
            end
            all_im=[];
            fprintf(1,' Done\n');
            
        else
            for kk=1:length(m)
                block_im{kk} = m{kk};
            end                
        end
        
        if ii==1
            pout.im = block_im;            
        else
            % add currently accumulated block_im at the end of the final
            % image stack
            for kk=1:length(pout.im)
%                 a=pout.im{kk}(:,:);
%                 al=size(pout.im{kk},3);                
%                 b=block_im{kk}(:,:);
%                 bl=size(block_im{kk},3);
%                 c=[a b];
%                 %pout.im{kk}=reshape(c,p.width,p.height,al+bl);
%                 pout.im{kk}=reshape(c,p.height,p.width,al+bl);
                 pout.im{kk} = add_block_end(pout.im{kk}, block_im{kk});
            end            
        end    
        
    end
    
    p.im = pout.im;    
    p.planes = [1:size(pout.im{1},3)];
    p.filename = newdir;

end

% set as not aligned
p.planes_aligned = 0;

% if only one plane was read, then set aligned to 1 and fill the p.accu_im
% variable
if ~isempty(p.im)
    if size(p.im{1},3)==1
        p.planes_aligned=1;            
        for ii=1:length(p.im)
            p.accu_im{ii}=p.im{ii};
        end
    end
end

% fill GUI objects based on what was read
fillinfo_detected_masses(handles, p, newdir); 

% fill additional paramters from the GUI, such as scaling
handles.p = p;
p = load_masses_parameters(handles);         

% remember everything
handles.p = p;
end

function c = add_block_end(im, block_im)
[ha, wa, da]=size(im);
[hb, wb, db]=size(block_im);
a=im(:,:);
b=zeros(ha,wa,db);
% this is necessary in case the images are not of the same size (height or
% width)
hab = floor((ha-hb)/2);
wab = floor((wa-wb)/2);
b(hab+[1:hb], wab+[1:wb], 1:db) = block_im;
b = b(:,:);
c = [a b];
c = reshape(c,ha,wa,da+db);
end