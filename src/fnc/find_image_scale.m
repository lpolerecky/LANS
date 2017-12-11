function imscale = find_image_scale(im, logscale, kind, be_verbose)
% find auto-scale of the image
% autoscale based on quantiles: kind = 0
% autoscale based on min/max: kind = 1

im = im(:);

if nargin>2
    k=kind;
else
    k=0; 
end;

if nargin>1
    ls=logscale;
else
    ls=0;
end;

if nargin>3
    bv=be_verbose;
else
    bv=1;
end;

if k==0 % autoscale based on quantiles    
    global additional_settings;    
    %ind0=find(im~=0);
    imscale = quantile(im,additional_settings.autoscale_quantiles);
    if bv
        fprintf(1,'Auto-scaling based on quantiles [%.3f %.3f] of all values: [%.2e %.2e]\n',...
            additional_settings.autoscale_quantiles,imscale);
    end;
else
    imscale = [min(im(:)) max(im(:))];
    if bv
        fprintf(1,'Auto-scaling calculated as [min max]: [%.2e %.2e]\n',imscale);
    end;
end;

if diff(imscale)==0
    % this can happen if the ion counts are 0
    imscale = [0 1];
    if bv
        fprintf(1,'Image scale had no difference, auto-scaling set to: [%.2e %.2e]\n',imscale);
    end;
end;

if ls
    if imscale(1)==0
        imscale = [ min([1 1e-3 * imscale(2)]) imscale(2) ];
        if bv
            fprintf(1,'Log-transform requested: auto-scaling minimum changed from 0 to %.2e\n',imscale(1));
        end;
    end;
end;

if isnan(imscale(1))
    imscale(1) = 0;
    fprintf(1,'scale(1) was NaN. Changed to 0.\n');
end;
if isnan(imscale(2))
    imscale(2) = imscale(1) + 1;
    fprintf(1,'scale(2) was NaN. Changed to %.2e.\n',imscale(2));
end;
