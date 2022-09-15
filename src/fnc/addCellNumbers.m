function cellnumbers=addCellNumbers(f,CELLS,textcolor)
% find all cells from the mask image CELLS and add the numbers

be_verbous = 1;

if(nargin>2)
    tc=textcolor;
else
    tc='w';
end

[Nx,Ny] = size(CELLS);
[xg,yg]=meshgrid([1:Ny],[1:Nx]);

%CELLS=findCells(CELLS);
    
if strcmp(get(f,'type'),'axes')
    ax=f;
elseif strcmp(get(f,'type'),'figure')
    ax=get(f,'Children');
end

vc=setdiff(unique(CELLS(:)),0);
Nc = length(vc);

max_nc = 3000;
% for a large amount of ROIs writing the ROI numbers may take a while, so
% write numbers for max max_nc uniformly selected ROIs
if Nc>max_nc
    vc=round(linspace(min(vc),max(vc),max_nc));
    vc=unique(vc);
    fprintf(1,'There are %d ROIs, which is too many to annotate.\n',Nc);
    Nc = length(vc);
    fprintf(1,'ROI numbers written only for %d ROIs.\n',Nc);
else
    if be_verbous & Nc>0
        fprintf(1,'Adding ROI numbers for %d ROIs. Please be patient...',Nc);
    end
end

roin = findobj(ax,'tag','roi_number');
roin_cnt = 0;
roin_max = length(roin);
if roin_max==0
    hold on;
end

for ii = 1:Nc
    ind=find(CELLS==vc(ii));
    cc = [mean(xg(ind)) mean(yg(ind))];
    if nargin>2
        tc = textcolor;
    else
        if ii<=5*Nc/19 || ii>=17*Nc/19
            tc = 'w';
        else
            tc = 'k';
        end
    end
    roin_cnt = roin_cnt+1;
    if roin_cnt<=roin_max
        %roin_old = str2num(get(roin(roin_cnt),'String'));
        %if vc(ii)~=roin_old
            set(roin(roin_cnt), 'position',[cc,0],'String',num2str(vc(ii)),'Color',tc,...
                'FontSize',8,'VerticalAlignment','middle',...
                'HorizontalAlignment','center', ...
                'tag','new_roi_number');
        %else
        %    set(roin(roin_cnt),'tag','new_roi_number');
        %end
    else
        a = text(ax,'position',[cc,0],'String',num2str(vc(ii)),'Color',tc,...
            'FontSize',8,'VerticalAlignment','middle',...
            'HorizontalAlignment','center');
        set(a, 'tag','new_roi_number');
    end
end

roin = findobj(ax,'tag','roi_number');
if ~isempty(roin)
    delete(roin);
end

roin = findobj(ax,'tag','new_roi_number');
for ii=1:length(roin)
    set(roin(ii),'tag','roi_number');
end

%hold off;
if be_verbous
    fprintf(1,'Done.\n');
end