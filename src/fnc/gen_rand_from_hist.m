function xrand = gen_rand_from_hist(bins,h,Nx)
% generate random data with the same histogram as in centers=bins and counts=h

xrand = [];

if Nx>0
    % first make the histogram denser
    oldx = bins;
    newx = linspace(min(bins),max(bins),10*length(h)+1);
    h2 = interp1(bins,h,newx);
    % generate probability distribution function (PDF) from the denser input histogram
    xcdf = cumsum(h2);
    % generate randomly distributed int numbers from 1 to max(xcdf)
    drawx = randi(round(max(xcdf)),[Nx,1]);
    % generate random numbers with the PDF equal to xcdf
    xrand = zeros(Nx,1);
    for i=1:Nx
        dx = abs(xcdf-drawx(i));
        [mi ind]=min(dx);
        xrand(i) = newx(ind);
    end
end