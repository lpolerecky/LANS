function [ydata, yscale, tyt] = log10transform_image(xdata, xscale, txt)
ydata=xdata;
if nargin<3
    txt = 'c';
end;

% make sure that all data are >=min(yscale) and <=max(yscale)
ydata(xdata < xscale(1)) = xscale(1);
ydata(xdata > xscale(2)) = xscale(2);
% log-transform both data and the scale
yscale = log10(xscale);
ydata = log10(ydata);
tyt = sprintf('log(%s)',txt);
