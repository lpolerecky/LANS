function CoV_out=get_variability_in_roi(xc,yc,rat_str,class,symb,fn)
% Calculate true variability of the ratio x/y based on the values of x and
% y given in pixels of a ROI. True variability is calculated from the
% variability derived from r=xc/yc minus the variability due to
% Poisson-distributed analytical error.
% (c) Lubos Polerecky, Utrecht University, 20-05-2018

% number of bins in histograms
N=40;

if isempty(xc) | isempty(yc)
    [xc, yc] = generate_test_data;
end    

if nargin<3
    rat_str = 'x/y';
end
if nargin<4
    class = 'c';
end
if nargin<5
    symb = 'r.';
end
if nargin<6
    fn=10;
end;

% experimental data
xe=xc; ye=yc;

% atratio: 0 for x/y; 1 for x/(x+y)
atratio = 0; 

fprintf(1,'=====================================================================\n');
fprintf(1,'Calculating within-ROI variability for %s in ROI(s) from class %s:\n',rat_str,class);

% find theoretical random variables with matching histograms
[xrand1, yrand1, xrand2, yrand2] = find_xrand_yrand(xe,ye,atratio,rat_str,class,fn);

% calculate ratio
if atratio
    we = xe./ye;
    w1 = xrand1./(xrand1+yrand1);
    w2 = xrand2./(xrand2+yrand2);
else
    we = xe./(ye);
    w1 = xrand1./(yrand1);
    w2 = xrand2./(yrand2);
end

% final result:
% coefficient of variance
% 1: in the experimental data, CV=sqrt(VARexp)/MEAN
% 2: in the theoretical data, model 1, CV=sqrt(VARmodel1)/MEAN
% 3: in the theoretical data, model 2, CV=sqrt(VARmodel1)/MEAN
% 4: unexplained variability by model 1, CV=sqrt(VARexp-VARmodel1)/MEAN
% 5: unexplained variability by model 2, CV=sqrt(VARexp-VARmodel2)/MEAN
CoV_out = [sqrt(var(we))/mean(we), sqrt(var(w1))/mean(w1), ...
    sqrt(var(w2))/mean(w2), sqrt(var(we)-var(w1))/mean(we), ...
    sqrt(var(we)-var(w2))/mean(we)];

if atratio
    rs = 'X/(X+Y)';
else
    rs = 'X/Y';
end

% display result                                
fprintf(1,'variable\texp\tmodel1\tmodel2\n')
fprintf(1,'== MEAN ion counts per pixel ==\n');
fprintf(1,'X\t%.2f\t%.2f\t%.2f\n',mean(xe), mean(xrand1), mean(xrand2));
fprintf(1,'Y\t%.2f\t%.2f\t%.2f\n',mean(ye), mean(yrand1), mean(yrand2));
fprintf(1,'== MEAN ratio based on accumulated ion counts ==\n');
fprintf(1,'%s\t%.3e\t%.3e\t%.3e\n',rs,mean(xe)/mean(ye), ...
    mean(xrand1)/mean(yrand1), mean(xrand2)/mean(yrand2) );
fprintf(1,'== %s (MEAN, VAR) based on values in pixels ==\n',rs);
fprintf(1,'MEAN\t%.3e\t%.3e\t%.3e\n',mean(we),mean(w1),mean(w2));
fprintf(1,'VAR\t%.3e\t%.3e\t%.3e\n',var(we),var(w1),var(w2));
fprintf(1,'== Coefficient of variability (CV=sqrt(VAR)/MEAN) ==\n');
fprintf(1,'exp\tmodel1\tmodel2\tPoisson (theor.)\n');
fprintf(1,'%.4f\t%.4f\t%.4f\t%.4f\n',CoV_out(1:3),sqrt(1/mean(xe)+1/mean(ye)));
fprintf(1,'== Unexplained CV: CV=sqrt(VARexp-VARmodel)/MEAN\n');
fprintf(1,'Model1\tModel2\n');
fprintf(1,'%.4f\t%.4f\n',CoV_out(4:5));


function [xc, yc] = generate_test_data
    
% define Poisson-distributed random variables with 3 mean ratios    
a1 = 0.2e-02;
a2 = 0.2e-02*3;
a3 = 0.2e-02;
r1 = a1/(1-a1);
r2 = a2/(1-a2);
r3 = a3/(1-a3);    
n1 = 2000*1;
n2 = 2000;
n3 = 2000*4.5;
my1 = 80000;
my2 = 80800;
my3 = 80400;
mx1 = r1*my1;
mx2 = r2*my2;
mx3 = r3*my3;
x1=poissrnd(mx1,n1,1);
y1=poissrnd(my1,n1,1);
x2=poissrnd(mx2,n2,1);
y2=poissrnd(my2,n2,1);
x3=poissrnd(mx3,n3,1);
y3=poissrnd(my3,n3,1);
xc = [x1; x2; x3];
yc = [y1; y2; y3];
% if there was no Poisson noise, this would be the mean, var and CoV of
% the pixels' 13C/(12C+13C) ratio
r = (n1*r1+n2*r2+n3*r3)/(n1+n2+n3);
A = r/(r+1);
% variance
v = ( n1*(r1/(r1+1)-A)^2 + n2*(r2/(r2+1)-A)^2 + n3*(r3/(r3+1)-A)^2 ) / (n1+n2+n3);
fprintf(1,'Expected mean, var and CoV for 13C/(12C+13C): %.3e\t%.3e\t%.4f\n',A,v,sqrt(v)/A);

% check data
if 0
    x=xc;
    y=yc;
    meanx = mean(x);
    meany = mean(y);
    varx = var(x);
    vary = var(y);
    w=x./y;
    z=sum(x)/sum(y);
    stdz = z*sqrt(1/sum(x) + 1/sum(y));
    figure(50+fn);
    subplot(2,3,1);
    hist([x1 x2],N);
    title('region 1, 2');
    xlabel('x');
    subplot(2,3,2);
    hist([y1 y2],N);
    title('region 1, 2');
    xlabel('y');    
    subplot(2,3,3);
    hist([x1./y1 x2./y2],N);
    title('region 1, 2');
    xlabel('x/y');    
    subplot(2,3,4);
    hist(x,N);
    title('region 1+2');
    xlabel('x');
    subplot(2,3,5);
    hist(y,N);
    title('region 1+2');
    xlabel('y');    
    subplot(2,3,6);
    hist(w,N);
    title('region 1+2');
    xlabel('x/y');    
end
