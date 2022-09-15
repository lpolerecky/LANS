function [o, r]=calculate_ratios(m, CELLS, images, formula, PoissErr, avg, SIZES, LWRATIOS)

if nargin>6
    cell_sizes = SIZES;
else
    cell_sizes = ones(size(m{1}));
end;

if nargin>7
    LWratio = LWRATIOS;
else
    LWratio = ones(size(m{1}));
end;

% number of cells
Nc=length(setdiff(unique(CELLS),0));
% default output
o = zeros(Nc,3);
r = 0;

if avg==1
    
    % calculate ratio given by FORMULA in every pixel and every plane, then
    % calcualate mean and Poisson error estimates from these values for every cell
    
    % in this case, input parameter M is the complete dataset: all masses    
    % in all pixels and planes. therefore, convert it to double first,
    % because originally it is of type uint16
    for ii=1:length(m)
        m{ii}=double(m{ii});
    end;
       
    % find which masses are used to calculate r in the formula
    k = identify_masses(formula);
    
    % find which planes will be used to calculate the mean etc.
    planes = images{k(1)};
    for ii=1:length(k)
        if ~isempty(images{k(ii)})
            planes = intersect(planes, images{k(ii)});
        end;
    end;
    
    % number of planes
    Np = length(planes);

    fprintf(1,'Calculating %s and averaging for all cells... ',formula);
    warning('off'); % to avoid error messages if dividing by 0
    eval(formula); % now r contains the ratio image as an MxNxL matrix
    warning('on');    
    
    % gather r values in all pixels and all selected planes for each cell, and
    % calculate mean, width of the 95% confidence interval of the mean, and
    % standard error of the mean (SEM)
    for ii=1:Nc        
        
        % gather values in a ROI from all pixels and from all planes
        ind = find(CELLS==ii);        
        for jj=1:Np
            rplane = [];
            rplane(:,:) = r(:,:,planes(jj));
%             m1p=[]; m1p(:,:) = m{1}(:,:,planes(jj));
%             m2p=[]; m2p(:,:) = m{2}(:,:,planes(jj));
            if jj==1
                a = rplane(ind);
%                 m1 = m1p(ind);
%                 m2 = m2p(ind);
            else
                a = [a; rplane(ind)];
%                 m1 = [m1; m1p(ind)];
%                 m2 = [m2; m2p(ind)];
            end;
        end;
        indN = find(isfinite(a));
        indall = [1:length(a)];
        diffind = setdiff(indall,indN);
        if 0 & ~isempty(diffind)
            fprintf(1,'\nCell %d: Indices of pixels that are not included in the mean:\n',ii);
            fprintf(1,'%d ',diffind);
            fprintf(1,'\n');
        end;
        a = a(indN);
        
        % calculate the actual mean value, width of the 95% confidence
        % interval of the mean, and standard error for the cell ii
        [mv m95 sem]=grpstats(a,ones(size(a)),{'mean','meanci','sem'});
        m95 = m95(2)-m95(1);
        o(ii,:) = [ mv m95 sem ];
%         m1a=sum(m1);
%         m2a=sum(m2);
%         fprintf(1,'mean=%e\taccu_rat=%e\tsem=%e\tPE=%e\n',...
%             mv, m2a/m1a, sem, m2a/m1a*sqrt(1/m2a+1/m1a));
        
        if 1
            f1=figure(160+ii-1);
            global additional_settings;
            s=quantile(a(:),additional_settings.autoscale_quantiles);
            edges=linspace(s(1),s(2),30);
            n=histc(a(:),edges);
            bar(edges,n);
            title(sprintf('mean=%.3e w(95%c)=%.3e SEM=%.3e',mv,'%',m95,sem));
            input('calculate_ratios.m (line 89): press enter to continue');
        end;
        
    end;
    
    fprintf(1,'Done.\n');
    
end;

if avg==2
    
    % calculate the ratio for each plane based on the masses accumulated
    % over a cell, then calcualate mean and Poisson error estimates from these values
    % for every cell 
    
    % in this case, the input parameter M contains accumulated masses in
    % all cells for all planes (Np=number of planes)
    
    % find which masses are used to calculate r in the formula
    k = identify_masses(formula);
    
    % find which planes will be used to calculate the mean etc.
    planes = images{k(1)};
    for ii=1:length(k)
        if ~isempty(images{k(ii)})
            planes = intersect(planes, images{k(ii)});
        end;
    end;
   
    % number of planes
    Np = length(planes);
 
    fprintf(1,'Calculating %s based on per plane averaging... ',formula);
    warning('off'); % to avoid error messages if divided by 0
    eval(formula); 
    r = r'; % now r contains the ratio values as a Np(number of planes) x Nc(number of cells) matrix
    eval(PoissErr); 
    per = per'; % now per contains the Poisson error as a Np x Nc matrix
    ind1 = find(isinf(per)==1 | isnan(per)==1);
    per(ind1)=ones(size(ind1));
    warning('on');

    % select only r and per values for selected planes
    r = r(planes,:);
    per = per(planes,:);
   
    % calculate the actual mean value, width of the 95% confidence
    % interval of the mean, and standard error for each cell
    grps = ones(size(r,1),1)*[1:size(r,2)];
    [mv m95 sem] = grpstats(r,grps,{'mean','meanci','sem'});
    m95 = reshape(m95,Nc,2);
    m95 = m95(:,2)-m95(:,1);
    o = [ mv(:) m95 sem(:) ];

    fprintf(1,'Done.\n');
    
end;

if avg==3
    
    % calculate the ratio for each cell based on the masses accumulated
    % over all selected planes and all pixels in the cell, then calcualate mean and
    % Poisson error estimates from these values for every cell 
    
    % in this case, the input parameter M contains accumulated masses in
    % all cells over all selected planes and all pixels
    
    % find which masses are used to calculate r in the formula
    k = identify_masses(formula);
    
    % find which planes are included in the calculation
    if ~isempty(k)
        planes = images{k(1)};
        for ii=2:length(k)
            if ~isempty(images{k(ii)})
                planes = intersect(planes, images{k(ii)});
            end;
        end;

        % number of planes
        Np = length(planes);
    end;
    
    fprintf(1,'Calculating %s from total accumulated signal... ',formula);
    warning('off'); % to avoid error messages if divided by 0
    eval(formula); % now r contains the ratio values as vector of length Nc
    eval(PoissErr); % now per contains the Poisson error
    warning('on');
    
    % set values that do not make sense, such as due to operations like
    % division by zero, to zero.
    ind1 = find((isnan(r)|isinf(r))==1);
    if length(ind1)>0
        fprintf(1,'WARNING: Ratio values in ROIs equal to NaN or Inf:\n');
        fprintf(1,' %d', ind1);
        fprintf(1,'\nTheir ratio values were set to zero.\n');
        r(ind1) = 0;
    end;
    ind1 = find((isnan(per)|isinf(per))==1);
    if length(ind1)>0
        fprintf(1,'\nWARNING: Poisson error values in ROIs equal to NaN or Inf:\n');
        fprintf(1,' %d', ind1);
        fprintf(1,'\nTheir Poission error values were set to zero.\n');
        per(ind1) = 0;
    end;    

    if length(per)==1 & per==0
        % this happens when the formula contains only size, so per=0
        o = [r(:) zeros(size(r(:))) zeros(size(r(:)))];
    else
        o = [r(:) r(:).*per(:) 100*per(:)];
    end;
    
    fprintf(1,'Done.\n');
    
end;
