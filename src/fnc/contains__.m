function out=contains(str1, str2)
out = ~isempty(strfind(str1,str2));

