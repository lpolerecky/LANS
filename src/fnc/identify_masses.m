function k = identify_masses(formula)
% identify ID's of masses that are used in the formula

ind = strfind(formula,'{');
k=[];
for ii=1:length(ind)
    k(ii)=str2num(formula(ind(ii)+1));
end;
k=sort(k);
