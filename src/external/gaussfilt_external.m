function [ Iout ] = gaussfilt_external( I, Nin, sigmain )

if nargin>1
    N=Nin;
else
    N = 5; 
end; %// Define size of Gaussian mask

if nargin>2
    sigma=sigmain;
else
    sigma = 2; 
end; %// Define sigma here

%// Generate Gaussian mask
ind = -floor(N/2) : floor(N/2);
[X Y] = meshgrid(ind, ind);
h = exp(-(X.^2 + Y.^2) / (2*sigma*sigma));
h = h / sum(h(:));

%// Convert filter into a column vector
h = h(:);

%// Filter our image
I = im2double(I);
I_pad = padarray(I, [floor(N/2) floor(N/2)]);
C = im2col(I_pad, [N N], 'sliding');
C_filter = sum(bsxfun(@times, C, h), 1);
Iout = col2im(C_filter, [N N], size(I_pad), 'sliding');

end

