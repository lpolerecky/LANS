function cellnumbers=addCellNumbers(f,CELLS,textcolor)
% find all cells from the mask image CELLS and add the numbers

if(nargin>2)
    tc=textcolor;
else
    tc='w';
end;

[Nx,Ny] = size(CELLS);
[xg,yg]=meshgrid([1:Ny],[1:Nx]);

%CELLS=findCells(CELLS);
    
if strcmp(get(f,'type'),'axes')
    axes(f);
elseif strcmp(get(f,'type'),'figure')
    figure(f);
end;
hold on;
vc=setdiff(unique(CELLS(:)),0);
Nc = length(vc);
for ii = 1:Nc
    %tmp=zeros(size(CELLS));
    ind=find(CELLS==vc(ii));
    %tmp(ind)=ones(size(ind));
    %gd = regionprops(tmp,'basic');
    %cc=gd.Centroid;
    cc = [mean(xg(ind)) mean(yg(ind))];
    if nargin>2
        tc = textcolor;
    else
        if ii<=5*Nc/19 | ii>=17*Nc/19
            tc = 'w';
        else
            tc = 'k';
        end;
    end;
    text('position',[cc,ii],'String',num2str(vc(ii)),'Color',tc,...
        'FontSize',8,'VerticalAlignment','middle',...
        'HorizontalAlignment','center');
end
hold off;