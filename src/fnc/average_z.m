function ys=average_z(ys,wz)
l=size(ys,2);
b=[1:wz:l];
if b(end)<l
    b = [b l];
end;
for i=1:(length(b)-1)
    dz=[b(i):b(i+1)-1];
    if i==(length(b)-1)
        dz=[b(i):b(i+1)];
    end;
    ys(:,dz)=sum(ys(:,dz),2)/length(dz)*ones(1,length(dz));
end;
