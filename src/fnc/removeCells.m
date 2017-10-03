function [VCELLS]=removeCells(CELLS)
% remove cells from the CELLS image

a=input('Enter ID''s of valid cells (e.g., [2:6] or [1 2 4 7]): ','s');
% valid cells
eval(['vc=',a,';']);

VCELLS=zeros(size(CELLS));
for ii=1:length(vc)
    ind=find(CELLS==vc(ii));
    VCELLS(ind)=ii*ones(size(ind));
end;


