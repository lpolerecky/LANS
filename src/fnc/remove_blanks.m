function m=remove_blanks(s)
ind=find(double(s)~=0 & double(s)~=double(' '));
m=s(ind);
