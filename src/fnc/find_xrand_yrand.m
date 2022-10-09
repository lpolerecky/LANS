function [xrand1 yrand1 xrand2 yrand2] = find_xrand_yrand(xe,ye,atratio,rat_str,class,fn)

%% find random variables xrand and yrand such that

% Approach 1
% 1. yrand is a random variable with Poisson distribution with mean equal
% to mean(ye)
% 2. xrand is a random variable with Poisson distribution with mean equal
% to mean(xe)

% Approach 2
% 1. histogram of yrand is similar to that of ye, but yrand is a random
% variable combined from multiple random variables, yi, each having Poisson
% distribution with a different mean
% 2. xrand is a random variable combined from multiple random variables,
% xi, each having Poisson distribution with means that are related to the
% means of yi through mean(xi) = re*mean(yi), where re is the ratio derived
% from the accumulated data, i.e., re = mean(xe)/mean(ye)

mye = mean(ye);
mxe = mean(xe);
re = mxe/mye;
n = max([10000 length(xe)]);

%% approach 1
   
% simple Poisson distributions with the same mean as the experimental data
xrand1=poissrnd(mxe,n,1);
yrand1=poissrnd(mye,n,1);
% ensure that yrand1 is never 0
ind = find(yrand1>0);
yrand1 = yrand1(ind);
xrand1 = xrand1(ind);

%% approach 2

% combination of multiple Poisson distributions, to better mimick the
% experimental data

%% to do this, start with the sqrt-transformed data, because the variance of
% a Poisson-distributed variable increases with the mean (since variance =
% mean), but standard deviation (SD=sqrt(var)) does not!

% find the approximate range of exp values
y1mb = round(quantile(sqrt(ye),[0.005 0.999]));

% define the range of mean values
y1m = [y1mb(1):0.5:y1mb(2)].^2;

% generate a matrix with columns corresponding to a Poisson-distributed
% variable with means in y1m
y1 = [];
for i=1:length(y1m)
    y1 = [y1 poissrnd(y1m(i),n,1)];
end

% create histograms for each column (these should, in effect, look like
% peaks centered around values in y1m)
ybins2 = linspace(min(y1(:)),max(y1(:)),round(3*length(y1m)));
ymat = hist(y1,ybins2);

% create the histogram of the experimental values in the same bins, which
% will make it possible to fit a linear combination of the theoretical
% histograms to the experimental histogram
yexp = hist(ye,ybins2);
yexp = yexp(:);

%% this is a critical step: 
% find coefficients (a) for which the linear combination of the theoretical 
% histograms matches best the experimental histogram
% this was the first approach
%a = (ymat' * ymat)\(ymat'*yexp);
% but this one is better, because it makes sure that the coefficients are
% all positive.
a=lsqnonneg(ymat,yexp);

% calculate the modeled y-data histogram
%ymodel = ymat*a;

%% now we can generate the data for x

% first generate mean values for the Poisson-distributed variables, using
% the ratio re determined from the accumulated (mean) exp. values
x1m = re*y1m;

% generate a matrix with columns corresponding to a Poisson-distributed
% variable with means in x1m
x1 = [];
for i=1:length(x1m)
    x1 = [x1 poissrnd(x1m(i),n,1)];
end

% create the histograms for each column
xbins2 = linspace(min(x1(:)),max(x1(:)),3*length(x1m));
%xbins2 = xbins;
xmat = hist(x1,xbins2);

% create the histogram of the experimental values in the same bins
xexp = hist(xe,xbins2);
xexp = xexp(:);

%% another critical step:
% calculate the modeled x-data histogram, using the calculated coefficients
% "a" 
%xmodel = xmat*a;

%% and finally (for the y-variable), generate random y-data with the same
% histogram as in ymodel 
%yrand = gen_rand_from_hist(ybins2,ymodel,length(ye));
%% and finally (for the x-variable), generate random x-data with the same
% histogram as in xmodel 
%xrand = gen_rand_from_hist(xbins2,xmodel,length(xe));

%% and finally, generate random x and y-data with the same histograms as in the matrix histograms
[xrand2, yrand2] = gen_rand_from_histmatrix(xbins2,ybins2,xmat,ymat,a,5*length(ye));

%% final checks

% calculate histograms from the newly generated xrand and yrand, in the
% same bins
NN=32;
ybins2 = linspace(min(ye(:)),max(ye(:)),NN);
xbins2 = linspace(min(xe(:)),max(xe(:)),NN);
xexp = hist(xe,xbins2);
yexp = hist(ye,ybins2);
xmod1=hist(xrand1,xbins2);
ymod1=hist(yrand1,ybins2);
xmod2=hist(xrand2,xbins2);
ymod2=hist(yrand2,ybins2);
if atratio
    we = xe./(xe+ye);
    wt1 = xrand1./(xrand1+yrand1);
    wt2 = xrand2./(xrand2+yrand2);
else
    we = xe./(ye);
    wt1 = xrand1./(yrand1);
    wt2 = xrand2./(yrand2);
end
[he,ce] = hist(we,linspace(min(we),max(we),NN));
[ht1,ct1] = hist(wt1,linspace(min(wt1),max(wt1),NN));
[ht2,ct2] = hist(wt2,linspace(min(wt2),max(wt2),NN));

%% display the results, to illustrate that the modeled and experimental
% histograms match well

f70=figure(fn);
set(f70,'Name',['class=' class ' ratio=' rat_str])

subplot(2,2,1);
hold off
plot(xbins2,xexp/max(xexp),'b.-'); 
hold on;
plot(xbins2,xmod1/max(xmod1),'g.-');
plot(xbins2,xmod2/max(xmod2),'r.-');
xlabel('x (nominator)')
ylabel('counts / max(counts)')
legend({'exp. data','model1','model2'},'location','northeast','box','off')
xlim([min(xe) max(xe)])
ylim([0 1.1])

subplot(2,2,2);
hold off
plot(ybins2,yexp/max(yexp),'b.-'); 
hold on;
plot(ybins2,ymod1/max(ymod1),'g.-');
plot(ybins2,ymod2/max(ymod2),'r.-');
xlabel('y (denominator)')
ylabel('counts / max(counts)')
xlim([min(ye) max(ye)])
ylim([0 1.1])

subplot(2,2,3);
hold off;
plot(xe,ye,'b.');
hold on
ind1 = randi(length(xrand1),[round(length(xe)/2),1]);
ind2 = randi(length(xrand2),[round(length(xe)/2),1]);
plot(xrand2(ind2),yrand2(ind2),'r.');
plot(xrand1(ind1),yrand1(ind1),'g.');
xlabel('x (nominator)')
ylabel('y (denominator)')
xlim([min(xe) max(xe)])
ylim([min(ye) max(ye)])

subplot(2,2,4);
hold off;
plot(ce,he/max(he),'b.-');
hold on
plot(ct1,ht1/max(ht1),'g.-');
plot(ct2,ht2/max(ht2),'r.-');
xlabel(['x/y = ' rat_str])
ylabel('counts / max(counts)')
legend({sprintf('var = %.2e', var(we)),...
    sprintf('var = %.2e', var(wt1)),...
    sprintf('var = %.2e', var(wt2))},...
    'location','northeast','box','off')
axis tight
ylim([0 1.1])

set(f70,'PaperPosition', [0 0 11 5]);

a=0;