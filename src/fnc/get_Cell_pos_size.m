function out=get_Cell_pos_size(CELLS,raster)
% Find co-ordinates of the ROI centers, size and shape of the ROIs

fprintf(1,'Calculating ROI positions, size and shape ... ');

sizefactor=2/sqrt(pi)*raster/size(CELLS,1);

vc=setdiff(unique(CELLS),0);
numObjects=length(vc);
out=zeros(numObjects, 6);

for jj=1:numObjects
        
    % find cell vc(jj)
    tmpc=zeros(size(CELLS));
    pp = find(CELLS==vc(jj));
    tmpc(pp) = ones(size(pp));
    
    % find center of the cell
    cc = find_cell_center(tmpc);
    
    % find cell length-to-width factor
    LWfactor = find_cell_lwfactor(tmpc, jj);
     
    % pix represents the cell size, measured as the number of pixels
    % that belong to the cell
    pix=length(pp);   
    
    % aa represents the cell size, measured as a diameter of a circle
    % with the same amount of pixels as in the cell
    aa=sizefactor*sqrt(pix);
        
    % calculate mean, median and std for all pixels in the cells
    out(jj,:) = [jj, cc, aa, pix, LWfactor];        
    
end;

fprintf(1,'Done.\n');