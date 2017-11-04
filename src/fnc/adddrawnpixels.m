function in=adddrawnpixels(in,x,y)
x=round(x);
y=round(y);
num_segments = length(x) - 1;
x_segments = cell(num_segments,1);
y_segments = cell(num_segments,1);
for k = 1:num_segments
    [x_segments{k},y_segments{k}] = intline(x(k),x(k+1),y(k),y(k+1));
end

% Concatenate segment vertices.
x = cat(1,x_segments{:});
y = cat(1,y_segments{:});

% these are the indices of the pixels drawn by mouse, so add them to the
% mask
ind2=(x-1)*size(in,1)+y;
in(ind2)=ones(size(ind2));