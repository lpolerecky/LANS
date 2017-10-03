function maskimg = add_cell(maskimg, added_cell)

N = max(maskimg(:));
ind = find(added_cell==1);
maskimg(ind) = (N+1)*ones(size(ind));