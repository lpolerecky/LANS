function N=getmask(im,t,k)
% calculate the mask image from the input image, threshold and kernel size

s=sprintf('*** This is getmask ***');
disp(s);

if(sum(k)>2)
    ims=wiener2(im,k);
else
    ims=im;
end;
N=zeros(size(ims));
ind=find(ims>t);
N(ind)=ones(size(ind));
