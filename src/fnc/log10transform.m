function y = log10transform(x, lt)
y=x;
if lt
    if(~isempty(x))
        x1 = x(:,1);
        x2 = x(:,2); % x2 = dx = standard error of x
        ind = find(x1>0);
        x1 = x1(ind);
        x2 = x2(ind);
        y1 = log10(x1);
        y2 = x2./x1/log(10); % if y=log10(x), then dy = dx * (1/x/ln(10))
        y = [y1(:) y2(:)];
    end;
end;
