function [C,p4,ind_all]=add_points_cell_perimeter(CELLS,id,nop)
% get all possible indices of NOP pixels at the perimeter of cell CELLS(id)
% that can be added/removed from the cell
% CELLS contains the matrix with definitions of ROIs
% nop>0 = added pixels
% nop<0 = removed pixels
% L. Polerecky (17.7.2011, Bremen)

vc=setdiff(unique(CELLS),0);
C=[]; p4=[]; ind_all=[];

if ~isempty(vc)
    indc = find(CELLS==vc(id));
    p4 = zeros(size(CELLS));
    p4(indc) = ones(size(indc));
    dxdy = [1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1];
    [B,L]=bwboundaries(p4,'noholes');
    bdr = B{1};
    indb = [1:size(bdr,1)];
    ind_all = [];
    cnt = 0;
    if nop>0
        for ii=1:length(indb)
            % add a pixel around it, accept it if it doesn't belong to the cell
            % already
            for k=1:8                
                x = bdr(ii,2) + dxdy(k,1);
                y = bdr(ii,1) + dxdy(k,2);
                if x>0 & y>0 & x<=size(p4,2) & y<=size(p4,1)
                    if p4(y,x)==0
                      p4(y,x)=1;
                      ind = find(p4==1);
                      cnt = cnt+1;
                      ind_all(cnt) = setdiff(ind,indc);
                      p4(y,x)=0;
                    end;
                end;
            end;               
        end;
        ind_all = unique(ind_all);
        % choose all possible selections of nop pixels attached to the boundary
        % for nop>=5 this was taking too long, so it was removed
        %C = nchoosek(ind_all,nop);  
        C = ind_all;
    elseif nop<0
        p5 = zeros(size(p4));
        for ii=1:size(bdr,1)
            p5(bdr(ii,1),bdr(ii,2)) = 1;
        end;
        ind_all = unique(find(p5==1));
        % for nop>=5 this was taking too long, so it was removed
        %C = nchoosek(ind_all,-nop);  
        C = ind_all;
    else
        C = [];
        ind_all = [];    
    end;

    if 0
        % display results
        for ii=1:size(C,1)
            p5 = p4;
            if nop>0
                p5(C(ii,:)) = ones(size(C(ii,:)));
            else
                p5(C(ii,:)) = zeros(size(C(ii,:)));
            end;
            p6 = p5([min(bdr(:,1))-1:max(bdr(:,1))+1],[min(bdr(:,2))-1:max(bdr(:,2))+1]);
            figure(2);
            imagesc(p6);
            input('Press enter to continue');
        end;
    end;

end;    
