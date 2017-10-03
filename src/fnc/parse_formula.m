function [formula,PoissErr,mass_index] = parse_formula(s,masses)
% parse expression in s and return it in the form
% r=f(m(i1),m(i2),m(i3),...), where i1,i2,... are indices of masses in
% the MASSES structure. Formula can be immediately evaluated using
% eval(formula) to calculate the result, which will be stored in r.
%
% Example: 
% if masses = {'12C','13C','12C14N','12C15N'} and
% s='(12C15N+12C14N)/(12C+13C)', then the returned formula will be 
% r = (m{4}+m{3})./(m{1}+m{2});

all_operators = '/*+-()';
[op, opind] = my_intersect(s,all_operators);
ind=[1 opind length(s)+1];
operands=[];
operators=[];
for ii=1:(length(ind)-1)
    s1=s(ind(ii):(ind(ii+1)-1));    
    operands{ii}  = my_setdiff(s1,all_operators);
    operators{ii} = my_intersect(s1,all_operators);
end;

formula = [];
PoissErr = [];
mass_index=[];

for ii=1:length(operators)
    if ~isempty(my_intersect(operators{ii},'*/'))
        formula = [formula '.'];
    end;
    formula = [formula operators{ii}];
    if ~isempty(operands{ii})
        k=identifyMass(masses,operands{ii});
        if k>0 & k<=length(masses)
            formula = [formula 'm{', num2str(k), '}'];
            PoissErr = [PoissErr '+1./m{', num2str(k), '}'];
            mass_index=[mass_index k];
        elseif ~isempty(intersect(operands{ii},'0123456789.')) & isempty(intersect(lower(operands{ii}),'abcdefghijklmnopqrstuvwxyz'))
            % operand is a valid number
            formula = [formula operands{ii}];
            fprintf(1,'Warning: expression differs from the pure ratio. The calculated Poisson error may not be correct!\n');
        elseif strcmp(upper(operands{ii}),'SIZE')
            formula = [formula 'cell_sizes'];
            fprintf(1,'Warning: expression contains SIZE. The calculated Poisson error may not be correct!\n');
        elseif strcmp(upper(operands{ii}),'PIXEL')
            formula = [formula 'cell_sizes'];
            fprintf(1,'Warning: expression contains PIXEL. The calculated Poisson error may not be correct!\n');    
        elseif strcmp(upper(operands{ii}),'PLANE')
            formula = [formula 'Np'];
            fprintf(1,'Warning: expression contains PLANE. The calculated Poisson error may not be correct!\n');
        elseif strcmp(upper(operands{ii}),'LWRATIO')
            formula = [formula 'LWratio'];
            fprintf(1,'Warning: expression contains LWRATIO. The calculated Poisson error may not be correct!\n');
        elseif strcmp(upper(operands{ii}),'EXT')
            % ALWAYS treat external image as mass length(masses)+1
            formula = [formula 'm{' num2str(length(masses)+1) '}'];
            PoissErr = [PoissErr '+1./m{', num2str(length(masses)+1), '}'];
            mass_index=[mass_index length(masses)+1];
        else
            formula = [];
            PoissErr = [];
            break
        end;
    end;
end;

if isempty(PoissErr) % this happens when the formula contains just 'size' or 'lwratio'
    PoissErr='0';
end;

mass_index = unique(mass_index);

if ~isempty(formula)
    formula = ['r = ', formula ';'];
    if ~strcmp(PoissErr,'0')
        PoissErr = ['per = sqrt(', PoissErr,');'];
    else
        PoissErr = 'per = 0;';
    end;
end;
