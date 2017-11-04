function r=my_round(x)
% I had to rewrite the rounding function because in ImageJ the numbers are
% rounded somehow wrongly!
y=x-floor(x);
if(y>0.5)
    r=ceil(x);
else
    r=floor(x);
end;
%r=floor(x);