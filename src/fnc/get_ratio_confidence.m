function conf = get_ratio_confidence(formula, m, imscale, mass_id)

conf = [];

%% new approach (26-06-2025)
% first, transform all selected masses from [min max] to [0 1]
for i=1:length(mass_id)
    k=mass_id(i);
    mk = ( m{k} - imscale{k}(1) ) / diff(imscale{k});
    mk(mk<0) = 0;
    mk(mk>1) = 1;
    m{k} = mk;
end
% next, apply the formula
s1 = ['conf = ', formula];
eval(s1);
% if there is '-' in the formula, the values may be negative, therefore
% shift the values upwards
conf = conf - min(conf(:));
% make sure that the final result is between 0 and 1
conf(conf<0) = 0;
conf(conf>1) = 1;

%% new approach (17-01-2025), now abandoned
if 0
s1 = ['confim = ', formula];
eval(s1);
m = imscale;
s2 = ['confsc = ', formula];
eval(s2);
conf = (confim-confsc(1))/diff(confsc);
conf(conf<0) = 0;
conf(conf>1) = 1;
end

% old approach (before 17-01-2025)
if 0
    % calculate the denominator in the ratio
    ind_div=findstr('/',formula);
    ind_end=findstr(';',formula);
    denom=formula(ind_div+1:ind_end-1);
    s = ['conf = ', denom, ';'];
    if ~isempty(denom) && isempty(findstr(denom,'Np')) && isempty(findstr(denom,'cell_sizes')) && isempty(findstr(denom,'cell'))

        %fprintf(1,'Estimating confidence of the ratio ... ');

        % image
        eval(s);
        if 0
            %conf = conf/max(conf(:));
            conf = log10(conf);
            ind = find(isinf(conf));
            conf(ind) = zeros(size(ind));
        end
        confim = conf;

        % scale
        m=imscale;
        eval(s);
        confsc = conf;

        % rescale confim such that the values will be within the given scale
        conf = (confim-confsc(1))/diff(confsc);
        ind = find(conf<0);
        conf(ind) = zeros(size(ind));
        ind = find(conf>1);
        conf(ind) = ones(size(ind));

        %fprintf(1,'Done.\n');

    end
end
