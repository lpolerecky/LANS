function R=getratiomask(i13,i12,Mask)
% calculate i13/i12 ratio and apply Mask

s=sprintf('*** This is getratiomask ***');
%disp(s);

R=zeros(size(i13));
%ind=find(Mask>0 & i12>0);
ind=find(i12>0);
R(ind)=i13(ind)./i12(ind);
