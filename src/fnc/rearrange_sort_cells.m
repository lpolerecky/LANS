function [VCELLS,indc]=rearrange_sort_cells(CELLS)
% Rearrange CELLS, in case the new cell was drawn over the old ones, thus
% making the old ones not defined. Furthermore, sort the cells such that
% their center positions are increasing. Last but not least, remove cells
% whose size is less then 1 pixels.

ucells=setdiff(sort(unique(CELLS)),0);
if(~isempty(ucells))
    VCELLS=zeros(size(CELLS));
    jj=0;
    for ii=1:length(ucells)
        ind=find(CELLS==ucells(ii));
        if(length(ind)>=1)
            jj=jj+1;
            VCELLS(ind) = jj*ones(size(ind));
        else
            fprintf(1,'Warning: ROI not added, as it had less then 1 pixels.\n');
        end;
    end;
    ucells=setdiff(sort(unique(VCELLS)),0);

    l2=zeros(size(VCELLS));
    for ii=1:length(ucells)
        p4=zeros(size(VCELLS));
        ind=find(VCELLS==ii);
        p4(ind)=ones(size(ind));
        [B,L]=bwboundaries(p4,'noholes');
        % find the "center" position (x and y)
        xc(ii)=mean(B{1}(:,2));
        yc(ii)=mean(B{1}(:,1));
        l2(ind)=ii*ones(size(ind));
    end;
    l3=l2;
    % sort the cells according to the increasing x-center position
    % account also for the y position of the center (i.e., if two cells
    % have the same y position, the one with lower y will come first)
    [xcyc,indc]=sort(yc+size(CELLS,1)*xc);    
    l2=zeros(size(l3));
    for ii=1:length(indc)
        ind=find(l3==indc(ii));
        l2(ind)=ii*ones(size(ind));
    end;
    VCELLS=l2;
else
    VCELLS = CELLS;
    indc=[];
end;