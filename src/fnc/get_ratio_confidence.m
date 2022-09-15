function conf = get_ratio_confidence(formula,m,imscale)

conf = [];

% calculate the denominator in the ratio
ind_div=findstr('/',formula);
ind_end=findstr(';',formula);
denom=formula(ind_div+1:ind_end-1);
s = ['conf = ', denom, ';'];
if ~isempty(denom) && isempty(findstr(denom,'Np')) && isempty(findstr(denom,'cell_sizes')) && isempty(findstr(denom,'cell'))
    
    %fprintf(1,'Estimating confidence of the ratio ... ');
    eval(s);
    if 0
        %conf = conf/max(conf(:));
        conf = log10(conf);
        ind = find(isinf(conf));
        conf(ind) = zeros(size(ind));
    end
    confim = conf;

    % now the scale
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