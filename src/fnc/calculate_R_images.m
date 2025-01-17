function [R,Ra,Raim,oall,Rconf, Rnom, Rdenom] = calculate_R_images(p, opt4, export_flag, zero_low_counts, sm, mask_kernel)
% calculate ratio images (R), as well as the accumulated values in the
% cells (Ra), and the corresponding image (Raim)

if nargin>2
    ef = export_flag;
else
    ef = 1;
end

if nargin>3
    zlc = zero_low_counts;
else
    zlc = 0;
end

if nargin>4
    sic_mass = sm;
else
    sic_mass = [];
end

if nargin>5
    if ~isempty(mask_kernel)
        mk = mask_kernel;
    else
        global additional_settings;
        mk = additional_settings.smooth_masses_kernelsize;
    end
else
    global additional_settings;
    mk = additional_settings.smooth_masses_kernelsize;
end

% default output is empty
R = []; Ra = []; Raim = []; oall = []; Rconf=[]; Rnom = []; Rdenom = [];

Nm = length(p.special);
Nim = length(p.accu_im);

% accummulate masses in cells. this will be used later when
% calculating ratios in each cell
if ef    
    [m2, dm2]=accumulate_masses_in_cells(p.accu_im,p.Maskimg,p.im,p.images,p.mass);
    out=get_Cell_pos_size(p.Maskimg,p.scale);
else 
    m2 = [];
    dm2 = [];
    out = [];
end

if ~iscell(p.images)
    pim{1}=p.images;
    p.images=pim;
end

if isempty(p.images{1})
    for i=1:Nim
        all_images{i} = p.planes;
    end
else
    if iscell(p.images)
        if length(p.images)==1
            for i=1:Nim
                all_images{i} = p.images{1};
            end
        else
            all_images=p.images;
        end
    end
end
Np=length(all_images{1});

if length(mk)<2
    mk(2)=1; % in older LANS version, this was a scalar. if this is saved in preferences, add this to avoid errors
end

% smooth images with a gaussian filter just before calculating the ratio
% images, if the smoothing kernel>1
% note that the accumulated values were already calculated above
if mk(2)>1 && mk(1)>1
    fprintf(1,'Smoothing mass images before calculating ratios ... ');
    for ii=1:length(p.accu_im)
        %p.accu_im{ii} = gaussfilt_external(p.accu_im{ii},mk(1),mk(2));
        p.accu_im{ii} = smooth_2D_image(p.accu_im{ii},mk(1),mk(2));
    end
    fprintf(1,'done.\n');
end

for ii=1:Nm
    if opt4(ii) && ~isempty(p.special{ii})
        
        % find the formula in p.special{ii}
        [formula, PoissErr, mass_index] = parse_formula_lans(p.special{ii},p.mass);               
        
        % fill variable m with accummulated mass IMAGES and calculate the
        % ratio IMAGE given by FORMULA
        if ~isempty(formula)
            m=p.accu_im;
            warning('off');
            % set the 'cell_sizes' to ones, just in case it is present in the formula
            cell_sizes = ones(size(m{1}));
            % set the 'LWratio' to ones, just in case it is present in the formula
            LWratio = ones(size(m{1}));
            eval(formula); 
            % in case a log function was used and produced complex numbers,
            % ensure that only the real values are displayed
            r(imag(r) ~= 0) = NaN;
            warning('on');            

            if zlc && 0
                % set values to zero in pixels where the ion counts are outside of 
                % the range specified in the 'scale' field for the corresponding mass
                ind0 = [];
                for jj=1:length(mass_index)
                    ind0 = [ind0; find(m{mass_index(jj)}<p.imscale{mass_index(jj)}(1))];
                    ind0 = [ind0; find(m{mass_index(jj)}>p.imscale{mass_index(jj)}(2))];
                end
                ind0 = unique(ind0);
                r(ind0) = zeros(size(ind0));
            end
            
            if zlc
                if isempty(sic_mass)
                    Rconf{ii} = get_ratio_confidence(formula, m, p.imscale);
                else
                    % before 2020-04-07, only one mass (or empty) in
                    % sic_mass was supported.
                    %Rconf{ii} = get_ratio_confidence(sprintf('1./m{%d};',sic_mass),m,p.imscale);
                    
                    % 2020-04-07: one mass, or sum of several masses is supported
                    %[fla2, negative_flag] = get_sic_mass_formula(sic_mass, p.mass);
                    [fla2, mass_id] = get_sic_mass_formula(sic_mass);
                    Rconf{ii} = get_ratio_confidence(fla2, m, p.imscale, mass_id);
                    %if negative_flag
                    %    Rconf{ii} = 1-Rconf{ii};
                    %end
                end
            else
                Rconf{ii} = ones(size(r));
            end
            
            % substitute inf and nan values by 0's in r, which exist if the
            % pixels in the denominator image contain 0's
            if 0
            ind1=isinf(r(:));
            ind2=isnan(r(:));
            ind12=find(ind1+ind2==1);
            r(ind12)=zeros(size(ind12));
            end
            
            % substitute inf with NaN
            r(isinf(r)) = NaN;
            
            R{ii} = r;
            
            % the following code will only work for simple ratios
            % (e.g., 13C/12C)
            
            % find nominator
            ind1 = strfind(formula,'=');
            ind2 = strfind(formula,'./');
            ind3 = strfind(formula,'m');
            if length(ind2)==1 %&& length(ind3)==2
                %if isempty(ind2)
                %    ind2 = length(formula);
                %end
                nomstr = sprintf('Rnom{ii} =%s;',formula((ind1+1):(ind2-1)));
                % find denominator
                ind1 = strfind(formula,'/');
                if ~isempty(ind1)
                    ind2 = strfind(formula,';');
                    denomstr = sprintf('Rdenom{ii}=%s;',formula((ind1+1):(ind2-1)));
                else
                    denomstr = 'Rdenom{ii}=1;'; % there is no denominator
                end
                eval(nomstr);
                eval(denomstr);
            else
                fprintf(1,'WARNING: formula contains more than one ''/''. Unable to determine numerator and denominator.\n')
                Rnom{ii} = [];
                Rdenom{ii} = [];
            end
                
            % fill variable m with accummulated COUNTS in ROIs and calculate the
            % ratio mean and Poisson error for each ROI given by expressions
            % in FORMULA and POISSERR
            if ef && ~isempty(m2)

                if isempty(out) && (contains(formula,'cell_sizes') || contains(formula,'LWratio'))
                    out=get_Cell_pos_size(p.Maskimg,p.scale);
                end
                                
                cell_sizes = out(:,5);
                LWratios = out(:,6);
                    
                [o, r]=calculate_ratios(m2, p.Maskimg, all_images, formula, PoissErr, 3, cell_sizes,LWratios);
                Ra{ii} = o(:,1);
                dRa{ii} = o(:,2);

                % construct image Raim from Ra and p.Maskimg
                Raim{ii} = cells2image(Ra{ii},p.Maskimg);

                % construct the ASCII output 
                oall{ii} = [out(:,1:3) o out(:,4:7)];

            end
            
        else
            
            fprintf(1,'*** WARNING: EXPRESSION %s CANNOT BE CALCULATED!\nPOSSIBLY ONE OF THE MASSES IS MISSING.\n',p.special{ii});
            R{ii} = [];
            Rconf{ii} = [];
            Ra{ii} = [];
            Raim{ii} = [];
            oall{ii} = [];
            Rnom{ii} = [];
            Rdenom{ii} = [];
            
        end
        
    end
end

oo=0;