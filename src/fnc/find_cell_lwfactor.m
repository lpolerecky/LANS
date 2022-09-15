function [LWfactor, dLWfactor] = find_cell_lwfactor(cell, jj)
% calculate the ratio between the MajorAxisLength and MinorAxisLength of
% the ellipse that has the same normalized second central moments as the
% cell 
% LP: modified from earlier versions on 29-03-2022

s = regionprops(cell,{'MajorAxisLength','MinorAxisLength'});
% other possibly useful properties calculated by regionprops:
% 'Eccentricity','Circularity', 'MaxFeretProperties','MinFeretProperties'
LWfactor = s.MajorAxisLength / s.MinorAxisLength;

% Estimate the uncertainty of the LWfactor as follows:
% 1. remove 1 pixel at the ROI perimeter, calculate the LWfactor as above,
% repeat this for all pixels at the ROI perimeter, and remember the values. 
% 2. add 1 pixel at the ROI perimeter, calculate the LWfactor as above,
% repeat this for all pixels at the ROI perimeter, and remember the values.
% 3. calculate 0.975 and 0.025 quantiles of the values calculated in steps 1 & 2.
% 4. calculate uncertainty as (q0.975 - q0.025)/2. Thus, the range
% encompases 95% of all values

global additional_settings;

% calculation of uncertainty of the LWfactor can be switched off because it
% takes too long.
if additional_settings.calculate_LWfactor

    fprintf(1,'Calculating uncertainty of the LWfactor for ROIs. If this operation takes too long, use\n');
    fprintf(1,'Preferences -> Additional output options to de-activate dLWfactor calculation.\n');

    t1=clock;
    fprintf(1,'Uncertainty in the Length-Width factor for ROI %d: ',jj);
    
    cell(cell>0) = 1;
    i_add = add_points_cell_perimeter(cell, 1, 1);
    LWfactor_add = zeros(size(i_add(:)));
    for i=1:length(i_add)
        cell_modif = cell;
        cell_modif(i_add(i)) = 1;
        bw4 = bwlabel(cell_modif,4);
        if length(unique(bw4(:)))==2 % only if the added point is 4-connected
            s = regionprops(cell_modif,{'MajorAxisLength','MinorAxisLength'});
            LWfactor_add(i) = s.MajorAxisLength / s.MinorAxisLength;
        end
    end
    i_rem = add_points_cell_perimeter(cell, 1, -1);
    LWfactor_rem = zeros(size(i_rem(:)));
    for i=1:length(i_rem)
        cell_modif = cell;
        cell_modif(i_rem(i)) = 0;
        bw4 = bwlabel(cell_modif,4);
        if length(unique(bw4(:)))==2 % only if the removed point did not leave any 4-unconnected pixels
            s = regionprops(cell_modif,{'MajorAxisLength','MinorAxisLength'});
            LWfactor_rem(i) = s.MajorAxisLength / s.MinorAxisLength;
        end
    end
    LWfactor_modif = [LWfactor_add(LWfactor_add>0); LWfactor_rem(LWfactor_rem>0)];
    dLWfactor = (quantile(LWfactor_modif,0.975) - quantile(LWfactor_modif,0.025))/2;

    t2=clock;
    fprintf(1,'%.2f (found in %.2f sec).\n', dLWfactor, etime(t2,t1));
        
else
    
    dLWfactor = 0;
    
end

if 0
    % different approach implemented 18-05-2018
    [x, y]=meshgrid([1:size(cell,2)], [1:size(cell,1)]);
    ind = find(cell>0);
    if length(ind)==1
        LWfactor=1; % ROI with only 1-pixel
    else
        % points inside the original cell
        x = x(ind);
        y = y(ind);
        % perform pca to figure out the angle by which the cell needs to be rotated
        % to make it as "horizontal" as possible
        [coeff] = pca([x y]);
        ang=acosd(coeff(1,1));
        %cr = imrotate(cell,ang,'bilinear');
        cr = imrotate(cell,ang,'nearest');
        % convert to x's and y's again to find the min and max values of the cell
        % boundary
        [x, y]=meshgrid([1:size(cr,2)], [1:size(cr,1)]);
        ind = find(cr>0);
        x = x(ind);
        y = y(ind);
        xb = [min(x):max(x)];
        yb = [min(y):max(y)];

        % go through all cell columns and calculate their heights (how many pixels
        % in each column are non-zero)
        h = zeros(size(xb));
        for i=1:length(xb)
            col = cr(yb,xb(i));
            h(i) = length(find(col>0));
        end
        % take the 95-quantile of h as the approximation of the maximal width
        W = quantile(h,0.95);

        % go through all cell rows and calculate their widths (how many pixels
        % in each row are non-zero)
        w = zeros(size(yb));
        for i=1:length(yb)
            row = cr(yb(i),xb);
            w(i) = length(find(row>0));
        end
        % take the 95-quantile of w as the approximation of the maximal length
        L = quantile(w, 0.95);
        % define length-to-width as H/W ratio
        LWfactor = L/W;
    end
    
end

if 0 % original idea
    
    rs = length(find(cell>0));
    [B,L]=bwboundaries(cell,'noholes');
    boundary = B{1};
    if length(B)>1
        fprintf(1,'Warning: ROI %d (size %d) contained more than one boundary. Non-contiguous ROI?\n',jj,rs);
        for i=2:length(B)
            boundary = [boundary; B{i}];
        end
    end
    if(size(boundary,1)>3 ...
            && min(boundary(:,1))~=max(boundary(:,1)) ...
            && min(boundary(:,2))~=max(boundary(:,2)) ...
            && ~isline(boundary) )
        % find ellipse circumscribing the cell boundary
        [A, cnt] = MinVolEllipse(boundary', .01);
        % find svd of the ellipse matrix, which contains the 1/a^2 and
        % 1/b^2 on the diagonal, where a and b are the shorter and
        % longer axes of the ellipse, and use them to calculate the
        % LWfactor (length-to-width ratio)
        ind = find(isnan(A)==1 | isinf(A)==1);
        if length(ind)>0
            % debug
            a=0;
        end
        [U,B,V] = svd(A);
        LWfactor = sqrt(B(1,1))/sqrt(B(2,2));
    else
        % if all points lie on a line (either in x or y direction), or if
        % the cell boundary is too short, set LWfactor to 0 by default, and
        % issue warning

        if isline(boundary)
            fprintf(1,'Pixels of ROI %d form a line. LWfactor set to %d. Please verify.\n', jj,rs); 
            LWfactor = rs;
        else
            fprintf(1,'ROI %d is somewhat odd (size=%d). LWfactor set to 0. Please verify.\n', jj,rs);
            LWfactor = 0;
        end
        if rs>3
            % debug
            a=0;
        end
    end
end

function il = isline(b)
x=b(:,2);
y=b(:,1);
if length(x)<=3
    il=1;
else
    if length(unique(x))==1
        % swap x and y
        z=y;
        y=x;
        x=z;
    end
    p=polyfit(x,y,1);
    y1=polyval(p,x);
    il = (sum(abs(y-y1))/1e4 < eps);
end