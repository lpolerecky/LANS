function [pos, accuval, v] = get_lateral_profile(x, y, im, lw, s)
% extract data in image IM along a lateral profile defined by points [x,y]
% lw = line-width = "thickness" of the lateral profile
% s = size of the image in um
%
% LP, 2020-03-28: Totally new implementation, based on matlab function
% improfile. Thus, this will only work in Matlab >= 2018b.

debug_flag = 0;

% ensure that the profile goes from left to right
if x(1)>x(end)
    x = flipud(x(:));
    y = flipud(y(:));
end

[h,w]=size(im);
[cx, cy, c] = improfile(im, x, y, 'bicubic');
Nx = length(cx);

% calculate vector of positions along the profile
dx = diff(cx(:)); dy = diff(cy(:));
pos = [0; cumsum(sqrt(dx.^2 + dy.^2))];
pos=pos(:)/w*s; % position in um

% calculate unity translation vector, which will be used for calculating 
% lateral profiles along a profile that is "parallel" to the original
% profile (to account for the "thickness" of the lateral profile)
if length(x)==2
    tvec = [ -diff(y) diff(x) ];
else
    tvec = [ mean(cx) - mean(cx([1 end])), mean(cy) - mean(cy([1 end])) ];
end
tvec = tvec/norm(tvec);

% Take the original polygon, and shift it in the direction of tvec in steps
% of 1 pixel (all together lw pixels) to get "parallel" lateral profiles.
% Along each of this profile extract the values from the image.
lwvec = [1:lw];
lwvec = lwvec-mean(lwvec);
v = zeros(Nx, length(lwvec));
for ii=1:length(lwvec)
    xi = x + lwvec(ii)*tvec(1);
    yi = y + lwvec(ii)*tvec(2);
    [cx, cy, c] = improfile(im, xi, yi, 'bicubic');
    v(:,ii) = c;
    if debug_flag
        figure(111); 
        subplot(2,1,1);
        if ii==1, hold off; else, hold on; end
        plot3(cx, cy, c);
        xlabel('x'); %xlim([1 w]); ylim([1 h]);
        subplot(2,1,2);
        if ii==1, hold off; else, hold on; end
        plot(pos, c, 'o-');        
    end
end

% Accumulate the values along the profile (do not use the NaN values).
accuval = sum(v,2);

if debug_flag
    figure(111); 
    subplot(2,1,2);
    plot(pos, accuval, 'ko-', 'LineWidth',2);
    xlabel('pos (um)');
end

a=0;






%% earlier implementation (used before 2020-03-28)
% now obsolete

if 0
dx = x(Nx)-x(1);
dy = y(Nx)-y(1);
[N, M] = size(im);
    
if abs(dx)>abs(dy) 
    % the profile is more in the horizontal direction
    v = NaN(Nx,lw);
    for ii = 1:lw
        if ii==1
            dj=0;
        else
            if mod(ii,2)==0
                dj=floor(ii/2);
            else
                dj=-floor(ii/2);
            end
        end             
        % move the profile up and down, depending on the profile thickness
        new_y = y + dj;
        % move the profile also left and right, to account for the
        % fact that it is not completely horizontal
        di = -dy*dj/dx;
        new_x = x + round(di);
        ind = (new_x-1)*N + new_y;               
        inside = find(new_y>=1 & new_y<=N & new_x>=1 & new_x<=M);
        v(inside,ii) = im(ind(inside));
        % check whether the pixels along the (thick) profile are
        % correctly calculated
        if 1
            figure(70);
            subplot(2,1,1);
            if ii==1, hold off; else, hold on; end
            plot(new_x,new_y,'bo-',new_x(inside),new_y(inside),'r.-');
            xlabel('x (pix)'); ylabel('y (pix)');
            subplot(2,1,2);
            if ii==1, hold off; else, hold on; end
            colors='rgbcmkrgbcmkrgbcmkrgbcmkrgbcmk';
            plot(pos, v(:,ii), [colors(ii),'.-'], ...
                pos(inside), v(inside,ii), [colors(ii) 'o']);
            xlabel('pos (um)'); ylabel('value');
        end
    end           
else
    % the profile is more in the vertical direction
    v = NaN(Nx,lw);
    for ii = 1:lw
        if ii==1
            di=0;
        else
            if mod(ii,2)==0
                di=floor(ii/2);
            else
                di=-floor(ii/2);
            end
        end
        % move the profile left and right, depending on the profile thickness
        new_x = x + di;
        % move the profile also up and down, to account for the
        % fact that it is not completely vertical
        dj = -dx*di/dy;
        new_y = y + round(dj);
        ind = (new_x-1)*N + new_y;
        inside = find(new_y>=1 & new_y<=N & new_x>=1 & new_x<=M);
        v(inside,ii) = im(round(ind(inside)));
        % check whether the pixels along the (thick) profile are
        % correctly calculated
        if 0
            figure(70); if ii==1, hold off; else, hold on; end
            plot(new_x,new_y,'bo-',new_x(inside),new_y(inside),'r.-');
        end
    end
end

% calculate the mean and std of the values along the profile; do not use
% the NaN values 
meanv=zeros(Nx,1); stdv=zeros(Nx,1);
for ii=1:Nx
    val = v(ii,:);
    indnan = find(~isnan(val)==1);
    if ~isempty(indnan)
        meanv(ii)=mean(val(indnan));
        stdv(ii)=std(val(indnan));
    end
end

end