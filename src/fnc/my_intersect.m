function [op,opind]=my_intersect(s1,s2)
% find where characters from s2 occur in s1, sort them as they occur in the order from
% left to right 

opind=[];
for ii=1:length(s2)
    opind=[opind find(s1==s2(ii))];
end;

opind=sort(opind);
op=s1(opind);

    