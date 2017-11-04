function b=shiftimg(a,vx,vy)
% shift image by vx and vy pixels in the x and y directions
% original from Matlab
se = translate(strel(1), [vy vx]);
b = imdilate(a,se);
[M,N]=size(b);
if(vx<0)    
    b(:,[(vx+1):0]+N)=zeros(M,abs(vx));
end;
if(vx>0)
    b(:,[1:vx])=zeros(M,vx);
end;
if(vy<0)    
    b([(vy+1):0]+M,:)=zeros(abs(vy),N);
end;
if(vy>0)
    b([1:vy],:)=zeros(vy,N);
end;
