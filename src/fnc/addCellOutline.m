function [CELLS]=addCellOutline(f,CELLS,outline_color)

% determine the outline color first
if(nargin>2)
    oc=outline_color;
    
    if length(oc)>1
        ind=find((double(oc)>=double('0') & double(oc)<=double('9')) | double(oc)==double('.'));
        if ~isempty(ind)
            lw=str2num(oc(ind));
        else
            lw=1;
        end;
        ind=setdiff([1:length(oc)],ind);
        oc=oc(ind);
    else
        lw=1;
    end;    
    
else
    oc='w-';
    lw=1;
end;

figure(f);
hold on;
vc=setdiff(unique(CELLS),0);
nc=length(vc);

t1=now;
if nc>0
    fprintf(1,'Adding ROI outlines. This may take a few seconds if there are many ROIs...');
end;

% draw boundaries around all defined CELLS
for ii = 1:nc
    ind = find(CELLS==vc(ii));
    p4=zeros(size(CELLS));
    p4(ind) = CELLS(ind);
    %[B,L]=bwboundaries(p4,'noholes');
    [B,L]=bwboundaries(p4,'holes');
    % fprintf(1,'cell %d has %d boundaries\n',ii, length(B));
    for j=1:length(B)
        boundary = B{j};
        if(size(boundary,1)>3)
            if 0
                k = convhull(boundary(:,2),boundary(:,1));
                plot(boundary(k,2), boundary(k,1), [oc], 'LineWidth', lw);
            else
                plot(boundary(:,2), boundary(:,1), [oc], 'LineWidth', lw);
            end;
        end;
    end;
end

t2=now;
fprintf(1,'Done.\n');
%fprintf(1,'Plotting of boundaries for %d cells took %.3fs\n',nc,(t2-t1)*24*3600);
