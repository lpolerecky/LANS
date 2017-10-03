function r=isnumber(s)
sd=double(s);
ind=find((s>=double('0') & s<=double('9')) | s==double('.') | s==double('-'));
r = length(ind)==length(s);