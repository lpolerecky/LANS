function [ind_all, ind_inside, ind_perim]=find_points_cell_perimeter_inside(CELLS,id,nop)
% find all pixels in the cell, on the perimeter of the cell (band thickness
% = nop), and inside the cell = all pixels minus those at the perimeter

be_verbous = 0;

vc=setdiff(unique(CELLS),0);
ind_all=[]; ind_inside=[]; ind_perim=[];

if ~isempty(vc)
    t1=clock;
    
    % all pixels in the cell
    ind_all = find(CELLS==vc(id));
    
    p4 = zeros(size(CELLS));
    p4(ind_all) = 1;
    
    % translate image around by nop pixels and remember the non-overlapping
    % pixels. those will be the one belonging to the perimeter
    dx=[1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1];
    ind_perim=[];
    for i=1:size(dx,1)
        p4t = imtranslate(p4,dx(i,:)*nop);
        p1 = p4.*p4t;
        ind = find(p4==1 & p1~=1);
        ind_perim = [ind_perim; ind(:)];        
    end
    ind_perim = unique(ind_perim);
    ind_inside = setdiff(ind_all,ind_perim);
    
    if 0
        % display results
        figure(102)
        subplot(1,2,1);
        imagesc(p4)
        p5 = zeros(size(CELLS));
        p5(ind_perim)=1;
        p5(ind_inside)=2;
        subplot(1,2,2);
        imagesc(p5);
    end
    
    t2=clock;
    if be_verbous
        fprintf(1,'Perimeter pixels found in %.2f sec.\n',etime(t2,t1));
    end

end 
