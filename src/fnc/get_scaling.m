function [mi ma step]=get_scaling(im)
mi=min(im(:));
ma=max(im(:));
d=ma-mi;
dax=d/10;
step=10^round(log10(dax));
t=[mi:step:ma];
while length(t)>10
    step=2*step;
    t=[mi:step:ma];
end;
