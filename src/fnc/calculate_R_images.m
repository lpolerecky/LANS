function [R,Ra,Raim,oall] = calculate_R_images(p, opt4, export_flag, zero_low_counts, mask_kernel)
% calculate ratio images (R), as well as the accumulated values in the
% cells (Ra), and the corresponding image (Raim)

if nargin>2
    ef = export_flag;
else
    ef = 1;
end;

if nargin>3
    zlc = zero_low_counts;
else
    zlc = 0;
end;

if nargin>4
    mk = mask_kernel;
else
    mk = 1;
end;

% default output is empty
R = []; Ra = []; Raim = []; oall = [];

Nm = length(p.special);
Nim = length(p.accu_im);

% if 'ext' image is in the list of formulas for the ratios, load it and
% add the image as the additional mass (p.accu_im{Nim+1})
% for ii=1:Nm
%     if opt4(ii) & ~isempty(strfind(p.special{ii},'ext')) 
%         
%         global EXTERNAL_IMAGEFILE;
%         if isempty(EXTERNAL_IMAGEFILE)
%             fprintf(1,'Empty file. Please select aligned external image first.\n');
%             define_external_image(p);
%         end;
%         
%         if exist(EXTERNAL_IMAGEFILE)
% 
%             ext_im=double(imread(EXTERNAL_IMAGEFILE)); 
%             fprintf(1,'External image loaded: %s\n',EXTERNAL_IMAGEFILE);
%             if size(ext_im,3)>1
%                 ext_im = ext_im(:,:,1);
%                 warndlg('External image was not B&W. Only the first channel (red) was selected.','Warning','modal');
%             end;
%             p.accu_im{Nim+1}=ext_im;
% 
%         else
%             p.accu_im{Nim+1}=ones(size(p.im{1},1),size(p.im{1},2));
%             disp('*** Error: No external image found. Setting it to ones.');
%         end;
%         
%     end;
% end;


% accummulate masses in cells. this will be used later when
% calculating ratios in each cell
if ef    
    [m2, dm2]=accumulate_masses_in_cells(p.accu_im,p.Maskimg,p.im,p.images);
end;

% calculate cell positions, sizes and shapes. this will be used later when
% calculation oall
if ef
    out=get_Cell_pos_size(p.Maskimg,p.scale);
else 
    out = [];
end;

if ~iscell(p.images)
    pim{1}=p.images;
    p.images=pim;
end;

if isempty(p.images{1})
    for i=1:Nim
        all_images{i} = p.planes;
    end;
else
    if iscell(p.images)
        if length(p.images)==1
            for i=1:Nim
                all_images{i} = p.images{1};
            end;
        else
            all_images=p.images;
        end;
    end;
end;
Np=length(all_images{1});

% smooth images with a gaussian filter just before calculating the ratio
% images, if the smoothing kernel>1

if mk>1
    fprintf(1,'Smoothing mass images before calculating ratios ... ');
    for ii=1:length(p.accu_im)
        p.accu_im{ii} = gaussfilt_external(p.accu_im{ii},5,mk);
    end;
    fprintf(1,'done.\n');
end;

for ii=1:Nm
    if opt4(ii) & ~isempty(p.special{ii})
        
        % find the formula in p.special{ii}
        [formula PoissErr mass_index] = parse_formula(p.special{ii},p.mass);               
        
        % fill variable m with accummulated mass images and calculate the
        % ratio IMAGE given by FORMULA
        if ~isempty(formula)
            m=p.accu_im;
            warning('off');
            % set the 'cell_sizes' to ones, just in case it is present in the formula
            cell_sizes = ones(size(m{1}));
            % set the 'LWratio' to ones, just in case it is present in the formula
            LWratio = ones(size(m{1}));
            eval(formula);
            warning('on');            

            if zlc
                % set values to zero in pixels where the ion counts are outside of 
                % the range specified in the 'scale' field for the corresponding mass
                ind0 = [];
                for jj=1:length(mass_index)
                    ind0 = [ind0; find(m{mass_index(jj)}<p.imscale{mass_index(jj)}(1))];
                    ind0 = [ind0; find(m{mass_index(jj)}>p.imscale{mass_index(jj)}(2))];
                end;
                ind0 = unique(ind0);
                r(ind0) = zeros(size(ind0));
            end;
            
            % substitute inf and nan values by 0's in r, which exist if the
            % pixels in the denominator image contain 0's
            ind1=isinf(r(:));
            ind2=isnan(r(:));
            ind12=find(ind1+ind2==1);
            r(ind12)=zeros(size(ind12));
            
            R{ii} = r;
            
            % fill variable m with accummulated mass in ROIs and calculate the
            % ratio mean and Poisson error for each ROI given by expressions
            % in FORMULA and POISSERR
            if ef & ~isempty(m2)

                if isempty(out) & (~isempty(strfind(formula,'cell_sizes')) | ~isempty(strfind(formula,'LWratio')))
                    out=get_Cell_pos_size(p.Maskimg,p.scale);                                               
                end;
                                
                cell_sizes = out(:,5);
                LWratios = out(:,6);
                    
                [o, r]=calculate_ratios(m2, p.Maskimg, all_images, formula, PoissErr, 3, cell_sizes,LWratios);
                Ra{ii} = o(:,1);
                dRa{ii} = o(:,2);

                % construct image Raim from Ra and p.Maskimg
                Raim{ii} = cells2image(Ra{ii},p.Maskimg);

                % construct the ASCII output 
                oall{ii} = [out(:,1:3) o out(:,4:6)];

            end;
            
        else
            
            fprintf(1,'*** WARNING: EXPRESSION %s CANNOT BE CALCULATED!\nPOSSIBLY ONE OF THE MASSES IS MISSING.\n',p.special{ii});
            R{ii} = [];
            Ra{ii} = [];
            Raim{ii} = [];
            oall{ii} = [];
        end;
        
    end;
end;
