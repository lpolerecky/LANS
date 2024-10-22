function ratio = reformat_ratio_string(ratio_,fs)
% raise all numbers in the ratio_ string to the superscript level
ratio = [];
math_on = 0;
if nargin>1
    fsstring = ['\fontsize{' num2str(round(fs/2)) '}'];
else
    fsstring = '';
end

% replace the most common functions and isotopes with LaTeX-compatible strings
ratio = strrep(ratio_, '*','\times');
ratio = strrep(ratio_, '/','\,/');
if contains(ratio,'log10')
    ratio = strrep(ratio, 'log10','log');
elseif contains(ratio,'log2')
    ratio = strrep(ratio, 'log2','log_2');
else
    ratio = strrep(ratio, 'log','ln');
end
%ratio = strrep(ratio, '2H','D');
ratio = strrep(ratio, '2H','\,{}^{2}H');
%ratio = strrep(ratio, '1H','H');
ratio = strrep(ratio, '1H','\,{}^{1}H');
ratio = strrep(ratio, '12C','\,{}^{12}C');
ratio = strrep(ratio, '13C','\,{}^{13}C');
ratio = strrep(ratio, '14N','\,{}^{14}N');
ratio = strrep(ratio, '15N','\,{}^{15}N');
ratio = strrep(ratio, '16O','\,{}^{16}O');
ratio = strrep(ratio, '18O','\,{}^{18}O');
ratio = strrep(ratio, '32S','\,{}^{32}S');
ratio = strrep(ratio, '31P','\,{}^{31}P');
ratio = strrep(ratio, 'C2','\,C_{2}');
ratio = strrep(ratio, 'Esi','SE');


% LP: obsolete from 07-June-2021
if 0
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

if math_on
    ratio = [ratio '}'];
    math_on = 0;
end;
end