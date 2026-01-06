function getstats_in_2D_plot(source,event)
fprintf(1,'\nExecuting getstats_in_2D_plot\n-----------------------------\n');
ax=gca;
fignum=get(get(ax,'Parent'),'Number');

% data to be fitted are stored in a global variable, depending on the
% figure where they are plotted
global XY_DATA_SCATTER_PLOT1 XY_DATA_SCATTER_PLOT2 XY_DATA_SCATTER_PLOT3
switch fignum
    case 61, XY_DATA_SCATTER_PLOT = XY_DATA_SCATTER_PLOT1;
    case 62, XY_DATA_SCATTER_PLOT = XY_DATA_SCATTER_PLOT2;
    case 63, XY_DATA_SCATTER_PLOT = XY_DATA_SCATTER_PLOT3;
    case 39, XY_DATA_SCATTER_PLOT = XY_DATA_SCATTER_PLOT1;
end

%xpred = 0.0106; ypred = 0.00375;
xl=get(ax,'xlim');
yl=get(ax,'ylim');

fprintf(1,'Use mouse to draw a polygon inside the graph. ');
fprintf(1,'Double-click to finish drawing.\n');

hR = impoly(ax);
pp=getPosition(hR);
%chil = ax.Children;

% find all points inside the polygon
%ind = [];
%xsel = [];
%ysel = [];
%xall = [];
%yall = [];
% this global variable is updated just before the 'fit button' is defined
%global XY_DATA_SCATTER_PLOT;                    

%for i=1:length(chil)
    
%    if strcmp(get(chil(i),'type'),'line')
%        xi = get(chil(i),'xdata');
%        yi = get(chil(i),'ydata');
%        xi=xi(:);
%        yi=yi(:);
%        inpolyg = inpolygon(xi,yi,pp(:,1),pp(:,2));
%        ind = find(inpolyg==1);
%        if ~isempty(ind)
%            xsel = [xsel; xi(ind)];
%            ysel = [ysel; yi(ind)];
%        end
%        xall = [xall; xi];
%        yall = [yall; yi];
%    end
    
%end

xall = XY_DATA_SCATTER_PLOT(:,1);
dxall = XY_DATA_SCATTER_PLOT(:,2);
yall = XY_DATA_SCATTER_PLOT(:,3);
dyall = XY_DATA_SCATTER_PLOT(:,4);
inpolyg = inpolygon(xall,yall,pp(:,1),pp(:,2));
xsel = xall(inpolyg);
ysel = yall(inpolyg);
dxsel = dxall(inpolyg);
dysel = dyall(inpolyg);

fprintf(1,'========================================================================\n');
fprintf(1,'Number of all data points: %d\n',length(xall));
fprintf(1,'Number of data points inside the polygon: %d\n',length(xsel));
        
% center the data
mx = mean(xsel); vx=1; %vx = std(xsel);
my = mean(ysel); vy=1; %vy = std(ysel);
xsel2 = (xsel - mx)/vx;
ysel2 = (ysel - my)/vy;
xall2 = (xall - mx)/vx;
yall2 = (yall - my)/vy;
xl2 = (xl - mx)/vx;
yl2 = (yl - my)/vy;
dysel2 = dysel/vy;
dxsel2 = dxsel/vx;

% calculate and plot a fit by a linear model, original data, y predicted by x
mdl1=fitlm(xsel,ysel, 'Weights', 1./dysel2);
p1=mdl1.Coefficients.Estimate;
xi1 = linspace(min(xl),max(xl),20);
yi1 = p1(1) + p1(2)*xi1;
%xpred1=xpred; [ypred1,yci1] = predict(mdl1,xpred1);

% calculate and plot a fit by a linear model, original data, x predicted by y
mdl2=fitlm(ysel,xsel, 'Weights', 1./dxsel2);
p2=mdl2.Coefficients.Estimate;
yi2 = linspace(min(yl),max(yl),20);
xi2 = p2(1) + p2(2)*yi2;
% ypred2=ypred; [xpred2,xci2] = predict(mdl2,ypred2);

% correlation coefficient, centered data
[R1, P1, R1L, R1U]=corrcoef(xsel2(:),ysel2(:));

% orthogonal fit, original data
po = linortfit2(xsel,ysel);
xio = linspace(min(xl),max(xl),20);
yio = po(1)*xio + po(2);
%ypredo=po(1)*xpred+po(2);

% PCA on the original data
%[coeff, score, latent]=pca([xsel(:) ysel(:)]);

% PCA on the centered data
[coeff, score, latent]=pca([xsel2(:) ysel2(:)]);

% display results in graphs
f200=figure(200+fignum);
f200p=f200.Position;
f200p(3)=900;
f200p(4)=500;
%f200p=[20 50 900 600];
f200.Position = f200p;

% fit of the selected data-points by linear models
ax1=subplot(2,3,1);
hold off
p1=plot(xall,yall,'k.','DisplayName','all points');
hold on
p3=plot(xsel,ysel,'ro','DisplayName','selected points');
p2x=plot(xi1,yi1,'b-','LineWidth',2,'DisplayName','Linear model (y ~ x)');
p2y=plot(xi2,yi2,'m--','LineWidth',2,'DisplayName','Linear model (x ~ y)');
p4=plot(xio,yio,'g:','LineWidth',2,'DisplayName','Orthogonal model');
%legend('show','Location','northwest')
xlim(xl)
ylim(yl)
title('original data');
ax1.YLabel.String = ax.YLabel.String;
ax1.XLabel.String = ax.XLabel.String;

Nbin = 16;

ax2=subplot(2,3,2);
histogram(xsel,'NumBins',Nbin)
xlim(xl)
ax2.XLabel.String = ax.XLabel.String;
ax2.YLabel.String = 'counts';

ax3=subplot(2,3,3);
histogram(ysel,'NumBins',Nbin,'Orientation','horizontal')
ylim(yl)
ax3.YLabel.String = ax.YLabel.String;
ax3.XLabel.String = 'counts';

ax4=subplot(2,3,4);
hold off;
p5=plot(xsel2,ysel2,'ro');
hold on;
xl2=xlim;
yl2=ylim;
fac1 = diff(yl2)/2 / coeff(2,1);
fac2 = diff(xl2)/2 / coeff(1,2);
quiver(0,0,fac1*coeff(1,1),fac1*coeff(2,1),'LineWidth',2,'Color','b','MaxHeadSize',0)
quiver(0,0,fac2*coeff(1,2),fac2*coeff(2,2),'LineWidth',2,'Color','g','MaxHeadSize',0)
text(fac1*coeff(1,1),fac1*coeff(2,1),'PC1')
text(fac2*coeff(1,2),fac2*coeff(2,2),'PC2')
%set(ax4,'DataAspectRatio',[1 1 1])
ax4.XLabel.String = 'X';
ax4.YLabel.String = 'Y';
title('centered data')

ax5=subplot(2,3,5);
histogram(score(:,1),'NumBins',Nbin)
%xlim(xl)
ax5.XLabel.String = 'PC1';
ax5.YLabel.String = 'counts';
title(sprintf('SD = %.2e',std(score(:,1))))

ax6=subplot(2,3,6);
histogram(score(:,2),'NumBins',Nbin,'Orientation','horizontal')
%xlim(xl)
ax6.YLabel.String = 'PC2';
ax6.XLabel.String = 'counts';
title(sprintf('SD = %.2e',std(score(:,2))))

% display statistics in the console
fprintf(1,'========================================================================\nBasic statistics:\t');
fprintf(1,'x = %s\ty = %s\n', ax.XLabel.String, ax.YLabel.String);
fprintf(1,'var\tAverage \tStd.Dev.\tVariance\n');
fprintf(1,'x\t%.4e\t%.4e\t%.2e\n', mean(xsel), std(xsel), var(xsel) );
fprintf(1,'y\t%.4e\t%.4e\t%.2e\n', mean(ysel), std(ysel), var(ysel) );

fprintf(1,'========================================================================\nLinear model y = Ax + B, weights=1/dy (blue line):\n');
%mdl1
fprintf(1,'var\tEstimate\tStd.Error\tp-Value \t(note)\n');
fprintf(1,'A\t%.4e\t%.4e\t%.2e\t(Slope)\n', mdl1.Coefficients.Estimate(2), ...
    mdl1.Coefficients.SE(2), mdl1.Coefficients.pValue(2));
fprintf(1,'B\t%.4e\t%.4e\t%.2e\t(Intercept)\n', mdl1.Coefficients.Estimate(1), ...
    mdl1.Coefficients.SE(1), mdl1.Coefficients.pValue(1));
fprintf(1,'R^2\t%.6f\t%s\t%s\t(Coefficient of determination)\n', mdl1.Rsquared.Ordinary, ...
    '........', '........');
fprintf(1,'Ra^2\t%.6f\t%s\t%s\t(Coefficient of determination adjusted)\n', mdl1.Rsquared.Adjusted, ...
    '........', '........');
%fprintf(1,'Prediction at x=%.6f:\ty=%.6f\t[ci=%.6f\t%.6f]\n',xpred1,ypred1,yci1)

fprintf(1,'========================================================================\nLinear model x = Ay + B, weights=1/dx (magenta line):\n');
%mdl2
fprintf(1,'var\tEstimate\tStd.Error\tp-Value \t(note)\n');
fprintf(1,'A\t%.4e\t%.4e\t%.2e\t(Slope)\n', mdl2.Coefficients.Estimate(2), ...
    mdl2.Coefficients.SE(2), mdl2.Coefficients.pValue(2));
fprintf(1,'B\t%.4e\t%.4e\t%.2e\t(Intercept)\n', mdl2.Coefficients.Estimate(1), ...
    mdl2.Coefficients.SE(1), mdl2.Coefficients.pValue(1));
fprintf(1,'R^2\t%.6f\t%s\t%s\t(Coefficient of determination)\n', mdl2.Rsquared.Ordinary, ...
    '........', '........');
fprintf(1,'Ra^2\t%.6f\t%s\t%s\t(Coefficient of determination adjusted)\n', mdl2.Rsquared.Adjusted, ...
    '........', '........');
%fprintf(1,'Prediction at y=%.6f:\tx=%.6f\t[ci=%.6f\t%.6f]\n',ypred2,xpred2,xci2)

fprintf(1,'========================================================================\nLinear orthogonal fit y = Ax + B (green line):\n')
fprintf(1,'var\tEstimate\t(note)\n');
fprintf(1,'A\t%.4e\t(Slope)\n', po(1));
fprintf(1,'B\t%.4e\t(Intercept)\n', po(2));

fprintf(1,'========================================================================\nCorrelation x vs. y (centered data):\n');
fprintf(1,'var\tEstimate\tStd.Error\tp-Value \t(note)\n');
fprintf(1,'R\t%.6f\t%.6f\t%.2e\t(Pearson correlation coefficient)\n',R1(1,2),(R1U(1,2)-R1L(1,2))/2, P1(1,2));

fprintf(1,'========================================================================\nPCA analysis on the centered data:\n')
fprintf(1,'PC1.ex\t%.3f\t(Fraction of variance explained by PC1)\n', latent(1)/sum(latent));
fprintf(1,'PC2.ex\t%.3f\t(Fraction of variance explained by PC2)\n', latent(2)/sum(latent));
fprintf(1,'PC1 = %.3f*X + %.3f*Y\n', coeff(:,1));
fprintf(1,'PC2 = %.3f*X + %.3f*Y\n', coeff(:,2));
%fprintf(1,'Prediction at x=%.6f:\ty=%.6f\n',xpred,ypredo)

delete(hR)
fprintf(1,'========================================================================\n')
fprintf(1,'\nPolygon deleted. Exiting getstats_in_2D_plot.m\n');


% functions from https://nl.mathworks.com/matlabcentral/fileexchange/16800-orthogonal-linear-regression
% Orthogonal Linear Regression
% version 1.0.0.0 (2.03 KB) by F. Carr

function [p] = linortfit2(xdata, ydata)
% LINORTFIT2  Fit a line to data by ORTHOGONAL least-squares.
%    P = LINORTFIT2(X,Y) finds the coefficients of a 1st-order polynomial
%    that best fits the data (X,Y) in an ORTHOGONAL least-squares sense.
%    Consider the line P(1)*t + P(2), and the minimum (Euclidean) distance
%    between this line and each datapoint [X(i) Y(i)] -- LINORTFIT2 finds
%    P(1) and P(2) such that the sum of squared distances is minimized.
if ~isequal(size(xdata), size(ydata))
    error('linortfit2:XYSizeMismatch',...
          'X and Y vectors must be the same size.');
end
[N,C] = linortfitn([xdata(:) ydata(:)]);
% The hyperplane given by N * [x; y] + C == 0 is optimal.
% Convert to the form  y = p(1)*x + p(2), just like polyfit(xdata,ydata,1).
p = - [N(1)  C] / N(2);

function [hyperplane_normal, hyperplane_offset] = linortfitn(data)
% LINORTFITN  Fit a line to data by ORTHOGONAL least-squares.
%    [N,C] = LINORTFITN(DATA) finds the coefficients of a hyperplane (in
%    Hessian normal form) that best fits the data in an ORTHOGONAL
%    least-squares sense.  Consider the hyperplane
%       H = {x | dot(N,x) + C == 0},
%    and the minimum (Euclidean) distance between this hyperplane and each
%    datapoint DATA(i,:) -- LINORTFITN finds N and C such that the sum of
%    squared distances is minimized.
[M,N] = size(data);
if M <= N,
    error('linortfitn:DegenerateProblem',...
        'There are fewer datapoints than dimensions: the data is perfectly fit by a hyperplane.');
end
[U,S,V] = svd(data - repmat(mean(data),M,1), 0);
hyperplane_normal = V(:,end);
hyperplane_offset = - mean(data * hyperplane_normal);
