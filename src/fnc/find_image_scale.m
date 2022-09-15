function imscale = find_image_scale(im, kind, minmax_q, log_flag, be_verbose, extra_text)
% find auto-scale of the image based on ...
% - quantiles qq of ALL values (kind == 0, default)
% - min/max of ALL values (kind == 1)
% - quantiles qq of ALL POSITIVE values (kind == 2)
% - min/max of ALL POSITIVE values (kind == 3)

im = im(:);
imscale = [];

if nargin>1
    k=kind;
else
    k=0; 
end

if nargin>2
    qq=minmax_q;
else
    global additional_settings;
    qq=additional_settings.autoscale_quantiles;
end

if nargin>3
    lf=log_flag;
else
    lf=0;
end

if nargin>4
    bv=be_verbose;
else
    bv=1;
end

if nargin>5
    tt=[' of ' extra_text];
else
    tt=[];
end

if k==0 % autoscale based on quantiles        
    imscale = quantile(im,qq);
    if bv
        fprintf(1,'Auto-scaling%s based on quantiles [%.3f %.3f] of all values: [%.2e %.2e]\n',tt,qq,imscale);
    end
elseif k==1 % min/max
    imscale = [min(im(:)) max(im(:))];
    if bv
        fprintf(1,'Auto-scaling%s based on [min max] of all values: [%.2e %.2e]\n',tt,imscale);
    end
elseif k==2 % quantiles of all positive values
    imscale = quantile(im(im>0),qq);
    if bv
        fprintf(1,'Auto-scaling%s based on quantiles [%.3f %.3f] of all positive values: [%.2e %.2e]\n',tt,qq,imscale);
    end    
elseif k==3 % min/max of all positive values
    imscale = [min(im(im>0)) max(im(im>0))];
    if bv
        fprintf(1,'Auto-scaling%s based on [min max] of all positive values: [%.2e %.2e]\n',tt,imscale);
    end
end

if diff(imscale)==0
    % this can happen if the ion counts are all 0
    imscale = imscale(1) + [0 1];
    if bv
        fprintf(1,'Image scale had no difference, auto-scaling set to: [%.2e %.2e]\n',imscale);
    end
end

if lf
    % if the log flag is 1, ensure that the minimimum is not <=0
    if imscale(1)<=0        
        imscale(1) = min([ quantile(im(im>0),qq(1)) imscale(2)*1e-3 ]);
        %imscale = [ minscale imscale(2) ];
        if 1 || bv
            fprintf(1,'NOTE: Because log-transform was requested, minimum%s was reset from 0 to %.2e\n',tt,imscale(1));
        end
    end
end

% final corrections, probably should never be needed
if isnan(imscale(1))
    imscale(1) = 0;
    fprintf(1,'scale(1) was NaN. Changed to 0.\n');
end
if isnan(imscale(2))
    imscale(2) = imscale(1) + 1;
    fprintf(1,'scale(2) was NaN. Changed to %.2e.\n',imscale(2));
end
