function cc=find_cell_center(cell)

%graindata = regionprops(cell,'basic');
%cc1(1:2)=graindata(1).Centroid;

Ny = size(cell,1);
Nx = size(cell,2);
[X,Y]=meshgrid([1:Nx],[1:Ny]);
ind=find(cell>0);
if length(ind)>0
    cc = [mean(X(ind)) mean(Y(ind))];
else
    cc = [0 0];
end;
