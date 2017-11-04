function Maskimg = auto_calculate_mask(handles)

p=handles.p;
p = load_masses_parameters(handles);

%if(~isfield(p,'Maskimg'))
    p.Maskimg = zeros(size(p.im{1},1),size(p.im{1},2));
%end;

[op,opind]=my_intersect(p.Mask,'/*+-');
if( isempty(op) )
    m1=identifyMass(p.mass,p.Mask);
    p.maskmass=getAccumMeanInCells(p.im{m1},zeros(size(p.im{m1})),p.Maskimg,p.fdir,p.Mask,'+');
    for ii=1:7
        if(strcmp(p.Mask,p.mass{ii}))
            ps=p.imscale{ii};
            break;
        end;
    end;
else
    p.maskmass=find_special_through_mask(op,opind,p.Mask,p.mass,p.im,p.Maskimg,p.fdir,0);            
    for ii=1:7
        if(strcmp(p.Mask,p.special{ii}))
            ps=p.special_scale{ii};
            break;
        end;
    end;        
end;
        
if(get(handles.radiobutton1,'value'))
    % use this if the cells are nicely separated
    Maskimg = getmask(p.maskmass,p.mask_thr,p.mask_kernel);
else
    % use this if cells are touching and many
    [Maskimg,nc,cc,cello]=draw_findCells(p.maskmass,1,1,30,ps,handles);
end;

if 0
    % trick for niculina (combining two images to form a mask)
    C=zeros(size(Maskimg));
    ind=find(wiener2(p.im{6},[5 5])>1.4);
    C(ind)=ones(size(ind));
    ind=find(wiener2(p.im{2},[5 5])<2);
    C(ind)=zeros(size(ind));
    Maskimg=C;
    CELLS=findCells(Maskimg);
    ind=find(CELLS==11 | CELLS==6 | CELLS==1 | CELLS==4 | CELLS==10);
    C=zeros(size(Maskimg));
    C(ind)=-ones(size(ind));
    a=load('f:\expdata\nanosims\RF_A1_A_3\cells_old.mat');
    ind=find(a.Maskimg>0);
    C(ind)=a.Maskimg(ind);
    Maskimg=C;
end;

%CELLS=findCells(Maskimg);
plotImageCells(51,p.maskmass,Maskimg,p.fdir,p.Mask,'w-');
plotImageCells(52,Maskimg,Maskimg,p.fdir,'cells-c','w-',[0 max(Maskimg(:))]);
a=input('Should these cells be saved to disk? (yes=1, no=0): ');
%a=1;
if(a)
    %Maskimg=CELLS;
    eval(['save ',p.fdir,'cells.mat -v6 Maskimg']);
    disp(['Cell outline saved as ',p.fdir,'cells.mat']);
end;
figure(51);