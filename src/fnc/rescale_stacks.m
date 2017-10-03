function x=rescale_stacks(x,q)
for i=1:length(x)
    tmp=x{i};
    % transform values to interval 0->1
    if sum(abs(tmp(:)))>0
        %ind=find(tmp>0);
        %sc=quantile(tmp(ind),q);
        sc = find_image_scale(tmp);
        tmp=(tmp-sc(1))/diff(sc);
        ind=find(tmp<0);
        tmp(ind)=zeros(size(ind));
        ind=find(tmp>1);
        tmp(ind)=ones(size(ind));
    end;
    x{i}=tmp;
end;
if length(x)==3
    xout(:,:,1)=x{1};
    xout(:,:,2)=x{2};
    xout(:,:,3)=x{3};
    x=xout;
end;
