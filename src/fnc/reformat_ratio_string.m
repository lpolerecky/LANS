function ratio = reformat_ratio_string(ratio_,fs)
% raise all numbers in the ratio_ string to the superscript level
ratio = [];
math_on = 0;
if nargin>1
    fsstring = ['\fontsize{' num2str(round(fs/2)) '}'];
else
    fsstring = '';
end;

for ii=1:length(ratio_)
    if double(ratio_(ii))>=double('0') & double(ratio_(ii))<=double('9')
        if ~math_on
            ratio = [ratio sprintf('{}^{%s%c',fsstring,ratio_(ii))];
            math_on = 1;
        else
            ratio = [ratio ratio_(ii)];
        end;
    else
        if math_on
            ratio = [ratio '}'];
            math_on = 0;
        end;
        ratio = [ratio ratio_(ii)];
    end;
end; 
