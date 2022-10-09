function rgb=gwyddion(ncol)
% Function for generating the viridis colormap developed by 
% Bob Rudis, Noam Ross and Simon Garnier
% cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
%
% Implemented by Lubos Polerecky, 29.05.2020, Utrecht Uni

if nargin==1
    nc=ncol;
else
    nc=64;
end
 
rgb = ([  
    1      1       1 % modified by LP to make the low-end blue close to black
    %68      1       84
    72      40      120
    62      74      137
    49      104     142
    38      130     142
    31      158     137
    53      183     121
    109     205     89
    180     222     44
    253     231     37
    255     255     255
    ])/255;

if nc~=size(rgb,1)
    % interpolate above values for nc colors
    x1=[1:size(rgb,1)]';
    x2=linspace(min(x1),max(x1),nc)';
    methodtype='pchip';
    %methodtype='linear';
    re=interp1(x1,rgb(:,1),x2,methodtype);
    ge=interp1(x1,rgb(:,2),x2,methodtype);
    be=interp1(x1,rgb(:,3),x2,methodtype);
    rgb=[re ge be];
    %rgb=flipud(rgb);
end