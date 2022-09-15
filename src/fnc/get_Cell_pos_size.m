function out=get_Cell_pos_size(CELLS,raster)
% Find co-ordinates of the ROI centers, size and shape of the ROIs

be_verbous = 1;

if be_verbous
    fprintf(1,'This is function: %s\n','get_Cell_pos_size');
end

fprintf(1,'Calculating ROI positions, size and shape ... \n');

sizefactor=2/sqrt(pi)*raster/size(CELLS,2);

vc=setdiff(unique(CELLS),0);
numObjects=length(vc);
out=zeros(numObjects, 7);
zz=zeros(size(CELLS));

t1=clock;
for jj=1:numObjects
        
    % find cell vc(jj)
    tmpc=zz;
    pp = find(CELLS==vc(jj));
    tmpc(pp) = ones(size(pp));
    
    % find center of the cell
    cc = find_cell_center(tmpc);
    
    % pix represents the cell size, measured as the number of pixels
    % that belong to the cell
    pix=length(pp);   
    
    % aa represents the cell size, measured as a diameter of a circle
    % with the same amount of pixels as in the cell
    aa=sizefactor*sqrt(pix);
        
    % calculate mean, median and std for all pixels in the cells
    out(jj,1:5) = [jj, cc, aa, pix];        
    
end

t2=clock;
if be_verbous
    fprintf(1,'Positions of ROIs found in %.2f sec.\n',etime(t2,t1));
end

% calculate LWfactor and its uncertainty for each ROI
for jj=1:numObjects    

    % find cell vc(jj)
    tmpc=zz;
    pp = find(CELLS==vc(jj));
    tmpc(pp) = 1;

    % find cell length-to-width factor
    [LWfactor, dLWfactor] = find_cell_lwfactor(tmpc, jj);

    % add LWfactor and its uncertainty
    out(jj,6:7) = [LWfactor, dLWfactor];    

end
   
% calculation of dLWfactor can be switched off because it may take too long.
global additional_settings;
if ~additional_settings.calculate_LWfactor
    fprintf(1,'WARNING: Uncertainty of the LWfactor was set to 0 for each ROI. Use Preferences -> Additional output options to activate the calculation.\n');
end