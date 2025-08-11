function im = rgb2gray_lans(im)
%im = rgb2gray(im); % Matlab-based
if size(im,3)>1
    im = sum(im,3);
    im = im/max(im(:));
end