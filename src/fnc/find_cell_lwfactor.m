function LWfactor = find_cell_lwfactor(cell, jj)
% calculate the ratio between the longer and shorter axis of the ellipse 
% circumscribing the cell outline

[B,L]=bwboundaries(cell,'noholes');
boundary = B{1};
if(size(boundary,1)>3 ...
        & min(boundary(:,1))~=max(boundary(:,1)) ...
        & min(boundary(:,2))~=max(boundary(:,2)))
    % find ellipse circumscribing the cell boundary
    [A, cnt] = MinVolEllipse(boundary', .01);
    % find svd of the ellipse matrix, which contains the 1/a^2 and
    % 1/b^2 on the diagonal, where a and b are the shorter and
    % longer axes of the ellipse, and use them to calculate the
    % LWfactor (length-to-width ratio)
    [U,B,V] = svd(A);
    LWfactor = sqrt(B(1,1))/sqrt(B(2,2));
else
    % if all points lie on a line (either in x or y direction), or if
    % the cell boundary is too short, set LWfactor to 0 by default, and
    % issue warning
    fprintf(1,'Cell %d is somewhat odd: LWfactor = 0. Please verify.\n', jj);
    LWfactor = 0;
end;
