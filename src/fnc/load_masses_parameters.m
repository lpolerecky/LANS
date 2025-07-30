function p=load_masses_parameters(handles,update_special_scale)

if(nargin>1)
    uss=update_special_scale;
else
    uss=1;
end

p_defined = isfield(handles,'p');

if p_defined
    p = handles.p;
end

%% define directory with the nanosims image structure
p.fdir = my_get(handles.edit2,'string');
p.fdir = fixdir(p.fdir);

%% define threshold used to calculate the mask image
p.mask_thr = str2num(my_get(handles.edit31,'string'));

%% define kernel size used to calculate the mask image
p.mask_kernel = str2num(my_get(handles.edit32,'string'));

%% mass based on which mask will be defined
p.Mask = my_get(handles.edit30,'string');

%% fill p.mass, p.images and p.imscale
jj=0;
for ii=1:8
    
    % fill mass name;
    % edit fields with the masses are edit3:edit9 and edit74
    if ii<8, k=ii+2; else, k=74; end
    s=['s=my_get(handles.edit',num2str(k),',''string'');'];
    eval(s);
    
    if(~isempty(s))
        
        jj=jj+1;
        p.mass{jj} = s;
        
        % fill range of images:
        % edit fields with the image range are edit12:edit18 and edit75
        if ii<8, k=ii+11; else, k=75; end
        % from 13-10-2017 only the first edit field (edit12) will be used
        % to check for the range of planes
        k=12;
        s=['s=my_get(handles.edit',num2str(k),',''string'');'];
        eval(s);
        p.images{jj}=str2num(s);
        
        % fill image scale:
        % edit fields with the image scale are edit33:edit39 and edit76
        if ii<8, k=ii+32; else, k=76; end
        s=['s=my_get(handles.edit',num2str(k),',''string'');'];
        eval(s);
        p.imscale{jj}=str2num(s);
        
    end
    
end

if length(p.images)<length(p.mass)
    for ii=(length(p.images)+1):length(p.mass)
        p.images{ii} = p.images{1};
    end
end

%% fill p.special, p.special_scale
if uss
    
    p.special = [];
    p.special_scale = [];
    
    jj=0;
    for ii=1:8
        
        if ii<=4, k1=ii+19; k2=ii+24;
        else, k1=ii+48; k2=ii+65;
        end
        
        % fill expression string:
        s=['s=my_get(handles.edit',num2str(k1),',''string'');'];
        eval(s);
        
        %if ~isempty(s)
            
            jj=jj+1;
            p.special{jj} = s;
            
            % fill expression scale string:
            s=['s=my_get(handles.edit',num2str(k2),',''string'');'];
            eval(s);
            if ~isempty(str2num(s))
                p.special_scale{jj}=str2num(s);
            else
                p.special_scale{jj}=s;
            end
            
        %end
        
    end
    
end

%% fill other parameters
p.ext = 'eps';
p.alignment_mass = my_get(handles.edit43,'string'); 
p.alignment_mass_images = [];
p.alignment_image = str2num(my_get(handles.edit42,'string'));
p.find_alignments = my_get(handles.checkbox7,'value');
p.alignmentregion_x = str2num(my_get(handles.edit44,'string'));
p.alignmentregion_y = str2num(my_get(handles.edit45,'string'));
if(isfield(handles,'edit46'))
    p.maxalignment = str2num(my_get(handles.edit46,'string'));
else
    p.maxalignment = 1;
end

if 0 % 2024-02-17 shifting of columns/rows handled differently
p.shift_columns_rows = [0 0 0 0];
if strcmp(get(handles.shift_first_column_end,'checked'),'on')
    p.shift_columns_rows(1) = 1;
end
if strcmp(get(handles.shift_last_column_beginning,'checked'),'on')
    p.shift_columns_rows(2) = 1;
end
if strcmp(get(handles.shift_first_row_end,'checked'),'on')
    p.shift_columns_rows(3) = 1;
end
if strcmp(get(handles.shift_last_row_beginning,'checked'),'on')
    p.shift_columns_rows(4) = 1;
end
end

if isfield(handles, 'shift_columns_rows')
    p.shift_columns_rows = handles.shift_columns_rows;
else
    p.shift_columns_rows = [0 0 0 0];
end

%% add ext to the list of masses, if the relevant image file exists, but only if it has not been done before
global EXTERNAL_IMAGEFILE;
if ~isempty(EXTERNAL_IMAGEFILE)
    if exist(EXTERNAL_IMAGEFILE)
        Nim=length(p.mass);       
        if isempty(strfind(p.mass{Nim},'ext'))
            p.mass{Nim+1}='ext';
            p.images{Nim+1}=p.images{Nim};
            p.imscale{Nim+1}='[0 255]';       
            fprintf(1,'Loading parameters for the external image.\n');
        end
    end
end


