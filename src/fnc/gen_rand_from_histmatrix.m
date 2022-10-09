function [xrand, yrand] = gen_rand_from_histmatrix(xbins,ybins,hmx,hmy,a,N)
% generate random data as a combination of random data with histograms
% given by the columns of matrix hm, where the combination is weighted by
% the vector "a" such that the total number of random data is N. Do this
% separately for x and y.

% weights of each distribution
%a(a<0)=0;
Na = round(a/sum(a)*N);

N = sum(Na);

xrand = zeros(N,1);
yrand = zeros(N,1);

idone = 0 ;
for j=1:length(a)
    x = gen_rand_from_hist(xbins,hmx(:,j),Na(j));
    y = gen_rand_from_hist(ybins,hmy(:,j),Na(j));
    if Na(j)>0
        xrand(idone + [1:Na(j)]) = x;
        yrand(idone + [1:Na(j)]) = y;
        idone = idone + Na(j);
    end
end

% ensure that yrand is never 0
ind = find(yrand>0);
yrand = yrand(ind);
xrand = xrand(ind);
