function Maskimg = add_remove_cells(handles, method)
p=handles.p;
p=load_masses_parameters(handles);

% find out the image that is used as a mask
[op,opind]=my_intersect(p.Mask,'/*+-');
if( isempty(op) )
    m1=identifyMass(p.mass,p.Mask);
    maskmass=p.im{m1};
    ps=p.imscale{m1};
else
    maskmass=find_special_through_mask(op,opind,p.Mask,p.mass,p.im,p.Maskimg,p.fdir,0);            
    for ii=1:length(p.special)
        if(strcmp(p.Mask,p.special{ii}))
            ps=p.special_scale{ii};
        end;
    end;        
end;

% load the currently stored cells
disp(['Cells loaded from ',p.fdir,'cells.mat']);
c=load([p.fdir,'cells.mat']);
CELLS=c.Maskimg;
Maskimg=CELLS;

% text-based interaction
if 0
    disp('Available methods:')
    disp('1: add by drawing of ROIs');
    disp('2: add by manual selection of cell centers and thresholding');
    disp('3: add by dividing cells with a line');
    disp('4: remove by selecting undesired cells');

    method = input('Which method should be used? ');
end;

if(method==1)
    Maskimg=drawing_ROIs_with_mouse(maskmass,CELLS,ps,50,p.fdir);
end;

if(method==2)    
    Maskimg=add_cells_interactively(maskmass,CELLS,ps,50,p.fdir);
end;

if(method==3)
    Maskimg = splitCells(maskmass,CELLS,ps,50,p.fdir);
end;

if(method==4)
    Maskimg=remove_cells_interactively(maskmass,CELLS,ps,50,p.fdir);
end;


if(method==5)
    Maskimg = maskmass;
    % use this if cells are touching and many

    % load the cell shape and cell positions
    workdir=get(handles.edit2,'String');
    if(~strcmp(workdir(length(workdir)),delimiter))
        workdir=[workdir,delimiter];
    end;
    if(isdir(workdir))
        newdir=workdir;
    else
        newdir='';
    end;
    disp('Select file with the cell shape');
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select CELL shape', workdir);
    if(FileName~=0)
        imfile1 = [newdir, FileName];
        eval(['load ',imfile1]);
        [B,L]=bwboundaries(tcell,'noholes');
        cello = B{1};
        % center cell outline
        cello = cello - ones(size(cello,1),1) * mean(cello,1);
    end;
    disp('Select file with the cell centers');
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select CELL centers', workdir);
    if(FileName~=0)
        imfile2 = [newdir, FileName];
        eval(['load ',imfile2]);
        % c was updated
    end;
      
    fn=figure(50); 
    hold off; 
    imagesc(Maskimg,ps);
    global additional_settings;
    colormap(get_colormap(additional_settings.colormap));
    figure(fn); hold on;
    cp=plot(c(:,1),c(:,2),'ro');
    happy=0;
    while(~happy)
        disp('Define cell centers.');
        disp('*** Left-click=select point; Right-click=confirm point; ESC=finish ***');
        m=1;
        pt=[];
        ptcell=[];
        cnum=0;
        while(m==1 | m==3)
            [x2,y2,m]=ginput(1);
            if(m==1 | m==3)
                if(m==1)
                   x=x2; y=y2;
                end;
                r=sqrt((c(:,1)-x).^2+(c(:,2)-y).^2);
                mi=find(r==min(r));
                if(r(mi)<5)
                    xp=c(mi,1); yp=c(mi,2);
                else
                    xp=x; yp=y;
                end;
                if(isempty(pt))
                    pt=plot(xp,yp,'rx');
                else
                    set(pt,'xdata',xp,'ydata',yp);
                end;
                if(isempty(ptcell))
                    ptcell=plot(xp+cello(:,1),yp+cello(:,2),'r-');
                else
                    set(ptcell,'xdata',xp+cello(:,1),'ydata',yp+cello(:,2));
                end;
                % remove selected point, if it corresponds to one of c, or define
                % a new one, if it doesn't, when right-click used
                if(m==3)
                    r=sqrt((c(:,1)-xp).^2+(c(:,2)-yp).^2);
                    mi=find(r==min(r));
                    if(r(mi)==0)
                        % remove point [xp yp] from the c-vector
                        ind=setdiff([1:size(c,1)],mi);
                        c=c(ind,:);
                    else
                        % add the selected point
                        c=[c; [xp yp]];
                    end;
                    % update currently defined points
                    set(cp,'xdata',c(:,1),'ydata',c(:,2));
                end;           
            end;
        end;
        happy=input('Should currently defined cells be saved to cells.mat?  (yes=1, no=0, continue=2): ');
    end;
    if(happy)
        % construct the CELLS image
        % sort cells such that their x positions are increasing
        close(fn);
        [cs,ind]=sort(c(:,1));
        c(:,1)=cs;
        c(:,2)=c(ind,2);
        nc=size(c,1);
        % transfer the cell outline so that it's center is [0 0]
        px=size(Maskimg,2); 
        py=size(Maskimg,1);
        l3=zeros(py,px);
        for ii=1:nc
            pts = cello+ones(size(cello,1),1) * [c(ii,1) c(ii,2)];
            bw=poly2mask(pts(:,1),pts(:,2),py,px);
            ind=find(bw>0);
            l3(ind)=bw(ind)*ii;
        end;
        Maskimg=l3;
        eval(['save ',imfile2, ' c -v6']);
        disp(['New cell centers saved into ',imfile2]);
    end;
end;

hello=1;

%eval(['save ',p.fdir,'cells.mat -v6 Maskimg']);
%disp(['Cell outline saved as ',p.fdir,'cells.mat']);
