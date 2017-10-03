function cc=find_cell_center(cell)
graindata = regionprops(cell,'basic');
cc(1:2)=graindata(1).Centroid;
