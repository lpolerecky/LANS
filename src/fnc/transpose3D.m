function y=transpose3D(x)
for i=1:size(x,3)
    y(:,:,i)=squeeze(x(:,:,i))';
end;
