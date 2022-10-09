function v1edge = get_v_edge(v1, im)
%[v1s, ind]=sort(v1(2,:));
%v1 = v1(:,ind);
V1 = diff(v1,1,2)';
P1 = v1(:,1)';
[N1 M1]=size(im);
if prod(V1)<0
    t1min = min(abs(([1 N1]-P1)./V1));
else
    t1min = min(abs(([1 1]-P1)./V1));
end
if prod(V1)<0
    t1max = min(abs(([M1 1]-P1)./V1));
else
    t1max = min(abs(([M1 N1]-P1)./V1));
end
v1edge = [P1 - V1*t1min; P1 + V1*t1max];
%v1edge = v1edge(:,ind);