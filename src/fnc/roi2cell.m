function [cell, ind] = roi2cell(h, boundary_type)

if( boundary_type == 0 ) % ellipse

    % find the ellipse circumscribing the drawn points
    BW = createMask(h);
    [B,L]=bwboundaries(BW,'noholes');
    c=B{1};
    % x=c(:,2);y=c(:,1);
    [A, cnt] = MinVolEllipse(c', .01);
    c2=Ellipse_plot(A,cnt,20,0);
    x2=c2(:,2); y2=c2(:,1);
    % create mask defined by the boundary of this ellipse
    cell = poly2mask(x2,y2,size(BW,1),size(BW,2));        
    %% debugging
    % figure(3); hold on;
    % imagesc(in); hold on;
    % plot(x,y,'g-');
    % plot(x2,y2,'y--');

else

    cell = createMask(h); % coarse polygon, incl. rectangle

end;

ind = find(cell>0);

if 0
    figure(121);
    imagesc(cell);
    colormap(clut);
end;