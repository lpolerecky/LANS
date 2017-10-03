function p = signif_fit(xin, yin, ratio, alpha, warn_flag)
% Determine minimum polynomial order P for which the polynomial fit of [xin
% yin] is significant. P=0 if the polynomial fit does not significantly
% decrease variability of fit residuals compared to variability of yin.
% Fitting is done with up to polynomial order 5. 
% Basically the variability of residuals of the polynomial fit of [xin yin]
% is calculated for increasing polorder, and P is determined such that the
% variability at polorder=P+1 is not significantly lower (determined by the
% Levene's test) than at polorder=P.
% If xin and yin are matrices, polorder is determined for every column.
%
% Lubos Polerecky, 15.5.2011, MPI Bremen

if nargin>3
    AL = alpha;
else
    AL = 0.05;
end;

if nargin>4
    wf = warn_flag;
else
    wf = 1;
end;

for nin = 1:size(xin,2)
    
    xi=xin(:,nin);
    yi=yin(:,nin);
    
    yi=yi-mean(yi); 
    xi=xi-mean(xi);
    N=length(xi);
    pp=0;
    y0=yi;
    for polorder=1:5
        warning('off');
        yfit = polyval(polyfit(xi,yi,polorder), xi);
        warning('on');
        x=[y0; yi-yfit];
        grp=[ones(size(yi)); zeros(size(yi))];
        plavene = vartestn(x,grp,'off','robust');
        if plavene<AL
            y0=yi-yfit;
            pp=polorder;
        end;
    end;
    p(nin,1) = pp;
    
end;

% warn if at least one p is >0, and plot the ratio vs. depth for those ROIs
% where a significant trend (p>0) was found
if wf
    ind=find(p>0);
    if ~isempty(ind)
        f161=figure(161);
        subplot(1,1,1); hold off;
        plot(xin(:,ind),yin(:,ind),'o')
        hold on;
        for ii=1:length(ind)
            plot(xin(:,ind(ii)),polyval(polyfit(xin(:,ind(ii)),yin(:,ind(ii)),p(ind(ii))),xin(:,ind(ii))),'k--');
        end;
        xlabel('plane');
        ylabel(ratio);
        legend(num2str(ind(:)));
        title(['ROIs with significant trends of ',ratio,' with depth']);
        fprintf(1,'\n*** WARNING: %s seems to have significant trends with depth.', ratio);
        fprintf(1,'*** Check ROIs %s\n',num2str(ind(:)'));
        input('Press enter to continue (do NOT close the graph window!!)');
        f161=figure(161);
        close(f161);
    end;
end;    

if 0
%%% This is a code for initial trials using F-test and a hard-coded
%%% implementation of the Levene's test. Then I realized that Levene's test
%%% is already implemented in Matlab! Dough!!

% determine order of a polynomial that fits significantly the trend of yin
% vs. xin. If xin and yin are matrices, the polynomial is determined for
% every column.

% set this to 1 if you want to have interactive display of the fits
display=0;

for nin = 1:size(xin,2)
    
    xi=xin(:,nin);
    yi=yin(:,nin);

    if nargin>2
        alpha = CONF_FACTOR;
    else
        alpha = 0.05;
    end;

    % fit [xi,yi] with polynomials of up to 5th order and return the result which is
    % significantly better than the one fitted with the lower order polynomial
    N=length(xi);
    s2=zeros(5,1);
    fcrit=zeros(5,1);

    yi=yi-mean(yi); 
    xi=xi-mean(xi);

    aa=1;

    if aa==1
        RSS1 = sum(yi.^2);
        p1 = 1;
        pp=0;

        for polorder=1:5
            % fit by the polynom
            yfit = polyval( polyfit(xi,yi,polorder), xi);
            RSS2 = sum((yi-yfit).^2);
            p2 = polorder+1;

            if display
            figure(161);
            subplot(2,2,1);
            plot(xi,yi,'bx', xi,yfit,'r-')
            subplot(2,2,2);
            plot(xi,yi,'bx', xi,yi-yfit,'ro');
            end;

            if 0
                f = (RSS1-RSS2)/(p2-p1) / (RSS2/(N-p2));    
                fcrit = finv(alpha,p2-p1,N-p2);
            end;

            if 1
                f = RSS1/(N-p1) / (RSS2/(N-p2));    
                fcrit = finv(1-alpha,N-p1,N-p2);
            end;               

            r = f/fcrit;

            if display
                fprintf(1,'RSS1=%f\tRSS2=%f\tf=%f\tfcrit=%f\tf/fcrit = %f\n',RSS1,RSS2,f,fcrit,r);
            end;

            if(r>1)
                RSS1 = RSS2;
                p1 = p2;
                pp = polorder;
            end;

            if display
                input('press enter');
            end

        end;
    end;
    p(nin,aa) = pp;

    aa=2;

    if aa==2

        y1 = yi;
        pp = 0;

        for polorder=0:5

            yfit1 = polyval( polyfit(xi,yi,polorder), xi);        
            y1 = yi - yfit1;
            yfit2 = polyval( polyfit(xi,yi,polorder+1), xi);
            y2 = yi - yfit2;

            z1 = abs(y1 - mean(y1));
            z2 = abs(y2 - mean(y2));

            zpp = mean([z1(:); z2(:)]);
            z1p = mean(z1);
            z2p = mean(z2);

            f = (2*N-2)/(2-1) * (N*(z1p-zpp)^2 + N*(z2p-zpp)^2) / ...
                (sum((z1-z1p).^2) + sum((z2-z2p).^2));

            fcrit = finv(1-alpha,1,2*N-2);

            r = f/fcrit;

            if display
                fprintf(1,'f=%f\tfcrit=%f\tf/fcrit = %f\n',f,fcrit,r);

                figure(161);
                subplot(2,2,3);
                plot(xi,yi,'bx', xi,yfit1,'r-', xi,yfit2,'g-')
                subplot(2,2,4);
                plot(xi,y1,'bx', xi,y2,'ro');
            end;

            if(r>1)
                pp = polorder+1;
            end;

            if display
                input('press enter');
            end;

        end;
    end;

    p(nin,aa) = pp;

    if display
    fprintf(1,'* Significant polynomial order %d\n',pp);
    end;

    % warn if at least one p is >0, and plot the ratio vs. depth for those ROIs
    % where a significant trend (p>0) was found
    psum=sum(p,2);
    ind=find(psum>0);
    if ~isempty(ind)
        f161=figure(161);
        subplot(1,1,1);
        plot(xin(:,ind),yin(:,ind),'x');
        xlabel('plane');
        ylabel(ratio);
        legend(num2str(ind(:)));
        title(['ROIs with significant trends of ',ratio,' with depth']);
        disp(['*** WARNING: ',ratio, ' seems to have significant trends with depth.']);
        fprintf(1,'*** Check ROIs %s\n',num2str(ind(:)'));
        input('Press enter to continue (do NOT close the graph window!!)');
        close(f161);
    end;

end;
end;