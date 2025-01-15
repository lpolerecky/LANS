function [rgb7, rgb8, xl, yl, zl, xs, ys, zs, rgb_true] = ...
    construct_RGB_image(handles, p_name, p_scale, R, Raim, opt1, Rconf, Maskimg)
% Construct RGB image from R and Raim images. Return also names and scales of the
% masses that are in the R, G and B channels.

rgb7=[];
rgb8=[];

% find the indices of the images that will be combined into RGB
if iscell(handles)
    i1 = handles{1};
    i2 = handles{2};
    i3 = handles{3};
else    
    i1=str2num(my_get(handles.edit59,'string'));
    i2=str2num(my_get(handles.edit60,'string'));
    i3=str2num(my_get(handles.edit61,'string'));
end
xl=[]; yl=[]; zl=[]; xs=[]; ys=[]; zs=[];

% check whether the settings for the RGB display/calculation match with
% the selected masses/ratios
psl=length(p_name);
isum=sum([ i1>0 i2>0 i3>0 ]);
c1 = (isum <= psl);
if length(R)>=isum
    if(i1>0), c1 = (c1 & ~isempty(R{i1})); end
    if(i2>0), c1 = (c1 & ~isempty(R{i2})); end
    if(i3>0), c1 = (c1 & ~isempty(R{i3})); end
else 
    c1=0;
end

% continue if everything is fine
if c1
    
    if(i1>0), xl=p_name{i1}; xs=p_scale{i1}; end
    if(i2>0), yl=p_name{i2}; ys=p_scale{i2}; end
    if(i3>0), zl=p_name{i3}; zs=p_scale{i3}; end
      
    Nx = 0;
    Ny = 0;
    for i=1:length(R)
        Nx = max([Nx, size(R{i},2)]);
        Ny = max([Ny, size(R{i},1)]);
    end    
    
    % fill the rgb matrix
    if opt1(5)        
        fprintf(1,'Filling RGB channels ...\n')  
        if nargin>6
            i123=[i1 i2 i3];
            Rc = Rconf{i123(1)};
        else
            Rc = [];
        end
        if nargin>7 % Maskimg takes precedence over Rconf            
            if sum(Maskimg(:))>0 && opt1(2) % zero values outside ROIs
                Rc = ones(Ny,Nx);
                Rc(Maskimg==0) = 0;
            end
        end
        [r7, r8, r, xl] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i1,p_scale,xl,opt1);
        i=1; rgb7(:,:,i) = r7; rgb8(:,:,i) = r8; rgb_true(:,:,i) = r;
        [g7, g8, g, yl] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i2,p_scale,yl,opt1);
        i=2; rgb7(:,:,i) = g7; rgb8(:,:,i) = g8; rgb_true(:,:,i) = g;
        [b7, b8, b, zl] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i3,p_scale,zl,opt1);
        i=3; rgb7(:,:,i) = b7; rgb8(:,:,i) = b8; rgb_true(:,:,i) = b;
        fprintf(1,'RGB channels filled.\n');
        
        % apply a hack to remove blue from pixels where r+g are sufficiently
        % high, and modify yellow to orange 
        % (implemented for the Mycobacterium paper, LP 24-08-2022)
        if 0
            factor = 0.85;
            i=3; rgb7(:,:,i) = b7*factor; rgb8(:,:,i) = b8*factor; rgb_true(:,:,i) = b*factor;
        end
        
        if 0
            thresh = 0.5;
            factors = [1 2 1];
            [r7, r8, r] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i1,p_scale,xl,opt1);
            i=1; rgb7(:,:,i) = r7/factors(1); rgb8(:,:,i) = r8; rgb_true(:,:,i) = r;
            [g7, g8, g] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i2,p_scale,yl,opt1);
            i=2; rgb7(:,:,i) = g7/factors(2); rgb8(:,:,i) = g8; rgb_true(:,:,i) = g;
            [b7, b8, b] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i3,p_scale,zl,opt1);
            %ind = find(r7>thresh & g7>thresh);
            %b7(ind) = 0;
            i=3; rgb7(:,:,i) = 1-b7; rgb8(:,:,i) = b8; rgb_true(:,:,i) = b;
        end
        
        if 0
            [r7, r8, r] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i1,p_scale,xl,opt1);
            i=1; rgb7(:,:,i) = r7; rgb8(:,:,i) = r8; rgb_true(:,:,i) = r;
            [g7, g8, g] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i2,p_scale,yl,opt1);
            i=2; rgb7(:,:,i) = g7; rgb8(:,:,i) = g8; rgb_true(:,:,i) = g;
            [b7, b8, b] = fill_channel_rgb(R,Raim,Rc,Nx,Ny,i3,p_scale,zl,opt1);
            i=3; rgb7(:,:,i) = b7; rgb8(:,:,i) = b8; rgb_true(:,:,i) = b;
            mag = 0.5*b7; %0.7 - 0.1*b7;
            cya = 0.1 + 0.55*b7;
            blk = zeros(size(b7));
            yel = 1*g7;
            cmyk = zeros(size(r7,1), size(r7,2), 4);
            cmyk(:,:,1) = cya*1;
            cmyk(:,:,2) = mag*0;
            cmyk(:,:,3) = yel;
            cmyk(:,:,4) = blk;
            inprof = iccread('USSheetfedCoated.icc'); 
            outprof = iccread('sRGB.icm');
            C = makecform('icc',inprof,outprof);            
            rgb7 = applycform(cmyk, C);
            rgb8 = rgb7;
            rgb_true = rgb7*255;
        end
        
    end
    
else
    fprintf(1,'%s\n',upper('Settings for the RGB image calculation are incorrect. Please revise.\n'));
end




function [rgb7, rgb8, rgb_true, lab2] = fill_channel_rgb(R,Raim,Rconf,Nx,Ny,ii,p_scale,lab,opt1)
global additional_settings;
% default output
rgb7 = zeros(Ny,Nx);
rgb8 = rgb7; 
rgb_true = rgb7;
lab2 = lab;
% proper output
if ii>0
    ch_scale = p_scale{ii};
    RR = R{ii};
    ch_scale_auto = find_image_scale(RR, 0, additional_settings.autoscale_quantiles, opt1(4), 0, lab);
    if ischar(ch_scale) % this happens when user gives [auto]
       ch_scale = ch_scale_auto; 
    end
    if opt1(4) % log-transform requested
        if ch_scale(1)==0
            ch_scale(1) = ch_scale_auto(1);
        end
    end
    % now the scale of the channel should be correctly set, thus RR
    % can be log-transformed & hue-corrected (if requested) and rescaled
    if opt1(7) 
        if opt1(4)
            [RR, ch_scale7, lab2] = log10transform_image(RR,ch_scale,lab);
        else
            ch_scale7 = ch_scale;
        end
        rgb7=(RR-ch_scale7(1))/diff(ch_scale7);
        % ensure that after rescaling all values are between 0 and 1
        rgb7(rgb7<0) = 0;
        rgb7(rgb7>1) = 1;
        rgb8(rgb8<0) = 0;
        rgb8(rgb8>1) = 1; 
        if ~isempty(Rconf) 
            % apply the hue correction. it does not make analytical sense,
            % but it does help the RGB image to look better by removing all
            % the potentially noisy pixels 
            rgb7 = rgb7 .* Rconf;
        end        
    end
    if opt1(8)
        RR=Raim{ii}; 
        if opt1(4)
            [RR, ch_scale8, lab2] = log10transform_image(RR,ch_scale,lab);
        else
            ch_scale8 = ch_scale;
        end
        rgb8=(RR-ch_scale8(1))/diff(ch_scale8);
    end
    rgb_true = RR;    
end
