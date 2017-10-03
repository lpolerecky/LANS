function sf=convert_string_for_texoutput(sf)
sf=regexprep(sf,'/','-');
sf=regexprep(sf,'*','-');
sf=regexprep(sf,'\.','d');
%sf=regexprep(sf,'(','');
%sf=regexprep(sf,')','');