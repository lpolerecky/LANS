function [ydata, yscale, tyt] = image2scale(xdata, kind, logt, q, be_verbous, txt)
ydata=xdata;
tyt = txt;

% kind of auto-scaling
if nargin>1
    k=kind;
else
    k=0;
end

% flag for log10-transform the image, scale and txt
if nargin>2
    lt=logt;
else
    lt=1;
end

% quantiles, applicable if kind==0
if nargin>3
    qq = q;
else
    global additional_settings;
    qq = additional_settings.autoscale_quantiles;
end

if nargin>4
    bv = be_verbous;
else
    bv = 1;
end

if nargin>5
    tt = txt;
else
    tt = [];
end

% find auto-scale of the original data
yscale = find_image_scale(ydata, k, lt, qq, bv, tt);

if lt
    % make sure that all data are >=min(yscale) and <=max(yscale)
    ydata(ydata < yscale(1)) = yscale(1);
    ydata(ydata > yscale(2)) = yscale(2);
    % log-transform data, scale and txt
    yscale = log10(yscale);
    ydata = log10(ydata);
    tyt = sprintf('log(%s)',txt);
end
