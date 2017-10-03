if 1
fdir='D:\expdata\nanosims\swat\';
[i12, i12a] = getimages([fdir,'m0']);
p=i12;
end;
[l2,nc]=findCells(i12,0.5,1,30);
