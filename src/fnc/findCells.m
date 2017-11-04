function [CELLS]=findCells(CELLS, minarea)
% find all cells from the mask image CELLS

if(nargin>2)
    ma=minarea;
else
    ma=5;
end;

% do not consider negative values in the cells image!
ind=find(CELLS<0);
CELLS(ind)=zeros(size(ind));

labeled = bwlabeln(CELLS,8);
graindata = regionprops(labeled,'basic');
% select only cells, i.e., objects with areas >ma
CELLS = zeros(size(labeled));
jj=0;
numObjects = max(labeled(:));
for ii=1:numObjects
    if(graindata(ii).Area>ma)
        jj=jj+1;
        ind = find(labeled==ii);
        CELLS(ind) = jj*ones(size(ind));
    end;
end;
