function [a xt xtl cmap] = imagesc_conf(IM, mi, ma, HI, colmap, colorbarpos)
% display image with the hue intensity modified by HI correction

if nargin>5
    cbpos = colorbarpos;
else
    cbpos = 0;
end;

cmap = get_colormap(colmap);

% display the image as normal, to find out the colorbar scaling

%if prod(HI(:))==1
    % when no correction for the SI counts is requested
a=imagesc(IM,[mi ma]);
colormap(cmap);

if cbpos ~= 0
    
    if cbpos==2
        cb = colorbar('location','southoutside');
        xylim = 'x';
    else
        cb = colorbar('location','eastoutside');
        xylim = 'y';
    end;
    xt=get(cb,[xylim 'tick']);
    xtl=get(cb,[xylim 'ticklabel']);
    delete(cb);
          
else
    
    xt=[];
    xtl=[];
    
end;

% apply HI correction, if requested
if prod(HI(:))~=1
    % first, cut out the darkest colors from the colormap
    cmap = cmap(6:size(cmap,1),:);
    % apply HI correction to the image displayed in the selected hue
    as=(IM-mi)/(ma - mi);
    a1=ind2rgb(uint8(as*size(cmap,1)),cmap);
    a1(:,:,1)=a1(:,:,1).*HI;
    a1(:,:,2)=a1(:,:,2).*HI;
    a1(:,:,3)=a1(:,:,3).*HI;
    a=image(a1);
end;
