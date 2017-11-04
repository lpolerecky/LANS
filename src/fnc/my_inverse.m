function inv=my_inverse(a)
inv=zeros(size(a));
ind=find(a~=0);
if(~isempty(ind))
    inv(ind)=1./a(ind);
end;
