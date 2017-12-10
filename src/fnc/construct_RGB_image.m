function [rgb7, rgb8, xl, yl, zl, xs, ys, zs, rgb_true] = construct_RGB_image(handles, p_name, p_scale, Maskimg, R, Raim, opt1)
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
end;
xl=[]; yl=[]; zl=[]; xs=[]; ys=[]; zs=[];

% check whether the settings for the RGB display/calculation match with
% the selected masses/ratios
psl=length(p_name);
isum=sum([ i1>0 i2>0 i3>0 ]);
c1=(isum <= psl);
if length(R)>=isum
    if(i1>0), c1 = (c1 & ~isempty(R{i1})); end;
    if(i2>0), c1 = (c1 & ~isempty(R{i2})); end;
    if(i3>0), c1 = (c1 & ~isempty(R{i3})); end;
else 
    c1=0;
end;

% continue if everything is fine
if c1
    
    if(i1>0), xl=p_name{i1}; xs=p_scale{i1}; end;
    if(i2>0), yl=p_name{i2}; ys=p_scale{i2}; end;
    if(i3>0), zl=p_name{i3}; zs=p_scale{i3}; end;
    
    % zero values outside cells
    if opt1(2)
        ind=find(Maskimg==0);
        if(i1>0), R{i1}(ind)=zeros(size(ind)); end;
        if(i2>0), R{i2}(ind)=zeros(size(ind)); end;
        if(i3>0), R{i3}(ind)=zeros(size(ind)); end;
    end;
    
    % fill the rgb matrix
    if opt1(5)
        
        fprintf(1,'Filling RGB channels ... ')
        
        % fill R channel
        if i1>0
            ch_scale = p_scale{i1};
            if opt1(7) 
                RR=R{i1};                 
                if ischar(ch_scale) % this happens when user gives [auto]
                    ch_scale = find_image_scale(RR, 0, 0);
                end;
                rgb7(:,:,1)=(RR-ch_scale(1))/diff(ch_scale);                                
            end;
            if opt1(8)
                RR=Raim{i1}; 
                if ischar(ch_scale) % this happens when user gives [auto]
                    ch_scale = find_image_scale(RR, 0, 0);
                end;
                rgb8(:,:,1)=(RR-ch_scale(1))/diff(ch_scale);
            end;                   
            rgb_true(:,:,1) = RR;
        else
            rgb7(:,:,1)=zeros(size(Maskimg));
            rgb8(:,:,1)=zeros(size(Maskimg));
            rgb_true(:,:,1) = zeros(size(Maskimg));
        end;
        
        % fill G channel
        if i2>0
            ch_scale = p_scale{i2};
            if opt1(7)
                RR=R{i2};
                if ischar(ch_scale) % this happens when user gives [auto]
                    ch_scale = find_image_scale(RR, 0, 0);
                end;
                rgb7(:,:,2)=(RR-ch_scale(1))/diff(ch_scale);
            end;
            if opt1(8) 
                RR=Raim{i2}; 
                if ischar(ch_scale) % this happens when user gives [auto]
                    ch_scale = find_image_scale(RR, 0, 0);
                end;
                rgb8(:,:,2)=(RR-ch_scale(1))/diff(ch_scale);
            end;
            rgb_true(:,:,2) = RR;                
        else
            rgb7(:,:,2)=zeros(size(Maskimg));
            rgb8(:,:,2)=zeros(size(Maskimg));
            rgb_true(:,:,2) = zeros(size(Maskimg));
        end;
        
        % fill B channel
        if i3>0
            ch_scale = p_scale{i3};
            if opt1(7)
                RR=R{i3}; 
                if ischar(ch_scale) % this happens when user gives [auto]
                    ch_scale = find_image_scale(RR, 0, 0);
                end;
                rgb7(:,:,3)=(RR-ch_scale(1))/diff(ch_scale);
            end;
            if opt1(8)
                RR=Raim{i3}; 
                if ischar(ch_scale) % this happens when user gives [auto]
                    ch_scale = find_image_scale(RR, 0, 0);
                end;
                rgb8(:,:,3)=(RR-p_scale{i3}(1))/(p_scale{i3}(2)-p_scale{i3}(1));
            end;
            rgb_true(:,:,3) = RR;
        else
            rgb7(:,:,3)=zeros(size(Maskimg));
            rgb8(:,:,3)=zeros(size(Maskimg));
            rgb_true(:,:,3) = zeros(size(Maskimg));
        end;
        
        % set out of range values to 0 and 1
        if opt1(7)
            ind=find(rgb7>1);
            rgb7(ind)=ones(size(ind));
            ind=find(rgb7<0);
            rgb7(ind)=zeros(size(ind));
        else
            rgb7=zeros(size(Maskimg,1),size(Maskimg,2),3);
        end;
        
        % set out of range values to 0 and 1
        if opt1(8)
            ind=find(rgb8>1);
            rgb8(ind)=ones(size(ind));
            ind=find(rgb8<0);
            rgb8(ind)=zeros(size(ind));
        else
            rgb8=zeros(size(Maskimg,1),size(Maskimg,2),3);
        end;               
        
        % make some tricky corrections to the g-channel, if necessary
        if 0
            g(:,:)=rgb7(:,:,2);
            maxg=1;
            ind=find(g>maxg);
            g(ind)=maxg*ones(size(ind));
            rgb7(:,:,2)=g(:,:);
        end;

        % log-transform, if requested
        for ii=1:2
            if ii==1
                rgb=rgb7;
            else
                rgb=rgb8;
            end;
            if opt1(4)
                if ii==1
                    fprintf(1,'Calculating log10(RGB) ... ');
                    rgb_true = log10(rgb_true);
                end;
                minlog=-log10(255);
                ind0=find(rgb<10^minlog);
                rgb(ind0)=(10^minlog)*ones(size(ind0));
                rgb = log10(rgb);
                % rescale from [-N 0] to [0 1]
                rgb=(rgb-minlog)/(0-minlog);
            end;
            if ii==1
                rgb7=rgb;
            else
                rgb8=rgb;
            end;
        end;
        
        % set all Inf to NaN
        ind = find(isinf(rgb_true));
        rgb_true(ind) = NaN*ones(size(ind));
        
        fprintf(1,'Done.\n');
    end;
    
else
    fprintf(1,'%s\n',upper('Settings for the RGB image calculation are incorrect. Please revise.\n'));
end;
