function [CELLS]=addCellOutline(ax,CELLS,outline_color,mag_fac)

if nargin<4
    mag_fac=1;
end

global verbose

% determine the outline color first
if(nargin>2)
    oc=outline_color;
    
    if length(oc)>1
        ind=find((double(oc)>=double('0') & double(oc)<=double('9')) | double(oc)==double('.'));
        if ~isempty(ind)
            lw=str2num(oc(ind));
        else
            lw=1;
        end
        ind=setdiff([1:length(oc)],ind);
        oc=oc(ind);
    else
        lw=1;
    end 
    
else
    oc='w-';
    lw=1;
end

%figure(f);
%hold on;
vc=setdiff(unique(CELLS(:)),0);
nc=length(vc);

% for a large amount of ROIs drawing the ROI outlines would take a while, so
% draw outlines for max max_nc uniformly selected ROIs
max_nc = 3000;
if nc>max_nc
    vc=round(linspace(min(vc),max(vc),max_nc));
    vc=unique(vc);
    fprintf(1,'WARNING: There are %d ROIs, which is too many to draw outlines for.\n',nc);
    nc = length(vc);
    fprintf(1,'ROI outlines only drawn for %d ROIs.\n',nc);
else
     if verbose
         fprintf(1,'Adding ROI outlines. Please be patient...');
     end
end

% draw outlines of all defined ROIs

% LP (2020-04-22): Improved speed.
% Previously, boundary for each ROI was calculated separately, which made
% it necessary to run a for-loop over all ROIs resulting in long execution
% if the amount of ROIs was large.
% Now, boundaries are calculated for the entire ROI image, and only the
% ROIs that are connected are treated separately. This leads to a
% considerably faster execution.
t1=clock;
p4 = CELLS;
n_con_rois=0;
if mag_fac>1 % LUBOS DEBUGGING 2022
    p4=imresize(p4,mag_fac,'method','nearest');
end
[B, L] = bwboundaries(p4,'holes');

roib = findobj(ax,'tag','roi_boundary');
roib_cnt = 0;
roib_max = length(roib);
if roib_max==0
    axes(ax);
    hold on;
end

for j=1:length(B)
    
    ind=find(L==j);
    up4 = unique(p4(ind));
    p5 = zeros(size(p4));
    
    if length(up4)>1
    
        for ii=1:length(up4)
            ind = find(p4==up4(ii));
            p5(ind) = up4(ii);
            B2=bwboundaries(p5,'noholes');
            p5(ind) = 0;
            for k=1:length(B2)
                boundary = double(B2{k}+1*(mag_fac-1)/2)/mag_fac;
                if(size(boundary,1)>3)
                    roib_cnt = roib_cnt+1;
                    if roib_cnt<=roib_max
                        set(roib(roib_cnt),'xdata',boundary(:,2), 'ydata',boundary(:,1),'LineWidth',lw,'tag','new_roi_boundary');
                    else
                        a=plot(boundary(:,2), boundary(:,1), [oc], 'LineWidth', lw);
                        set(a,'tag','new_roi_boundary');
                    end
                    n_con_rois = n_con_rois+1;
                end
            end
        end
        
    else
    
        boundary = double(B{j}+1*(mag_fac-1)/2)/mag_fac;
        if(size(boundary,1)>3)
            roib_cnt = roib_cnt+1;
            if roib_cnt<=roib_max
                set(roib(roib_cnt),'xdata',boundary(:,2), 'ydata',boundary(:,1),'LineWidth',lw,'tag','new_roi_boundary');
            else
                a=plot(boundary(:,2), boundary(:,1), [oc], 'LineWidth', lw);
                set(a,'tag','new_roi_boundary');
            end
        end
        
    end
end

roib = findobj(ax,'tag','roi_boundary');
if ~isempty(roib)
    delete(roib);
end

roib = findobj(ax,'tag','new_roi_boundary');
for ii=1:length(roib)
    set(roib(ii),'tag','roi_boundary');
end
 
t2=clock;

%% THIS IS THE OLDER APPROACH, considerably slower.
if 0
    t1=clock;
    p4=zeros(size(CELLS));
    for ii = 1:nc
        ind = find(CELLS==vc(ii));
        %p4=zeros(size(CELLS));
        %p4(ind) = CELLS(ind);
        p4(ind) = vc(ii);
        %[B,L]=bwboundaries(p4,'noholes');
        % to draw the outline AROUND the ROI pixels, first magnify the ROI
        % image, then find the boundaries, and add them into the image as
        % plots. However, do this only when using the Interactive ROI
        % definition tool. When displaying/exporting cells from the main LANS
        % GUI, the ROI outlines are plotted only through the centers of the
        % pixels at the ROI boundary.
        if mag_fac>1
            p4=imresize(p4,mag_fac,'method','nearest');
        end
        B=bwboundaries(p4,'holes');
        p4(ind)=0;
        % fprintf(1,'cell %d has %d boundaries\n',ii, length(B));
        for j=1:length(B)
            boundary = double(B{j}+1*(mag_fac-1)/2)/mag_fac;
            if(size(boundary,1)>3)
                a=plot(boundary(:,2), boundary(:,1), [oc], 'LineWidth', lw);
                set(a,'tag','roi_boundary');
            end
        end    
    end
    t2=clock;
end

if verbose
    fprintf(1,'Done.\n');
    fprintf(1,'addCellOutline.m: %.3fs (%d ROIs, %d connected ROIs)\n',etime(t2,t1),nc,n_con_rois);
end
