function a=ANME_activity
% calculate ANME activity as a function of SRB

% default mat and file containing the CELLS (ROI's) definition
cells_matfile='cells.mat';
cells_datfile='cells.dat';

% default masses that's going to be read and processed
m1='13C';
%m1='32S';
m2='12C';
%m3='31P';
m3='13C';
%m3='32S';
m4='12C';

anme_active_scale=[0.01 0.016];
srb_active_scale=[0.01 0.016];

% load settings from the ini file
load nanosimsini.mat

% get default base_dir
base_dir = h.edit1.string;
% ask for the base directory with all the processed files
disp('Select base directory with all processes data');
dname = uigetdir(base_dir,'Select base directory with all processes data');
if(dname~=0)
    base_dir=dname;
end;
base_dir=fixdir(base_dir);

% specify the meta-file with the meta-instructions
disp('Select file with the meta-instructions');
[FileName,newdir,newext] = uigetfile({'*.txt';'*.meta';'*.dat'}, 'Select metafile', base_dir);
if(FileName~=0)
    metafname = [newdir, FileName];
else
    % default
    metafname = [base_dir,delimiter,'summary9.txt'];
end;

% specify the final output file basename and the title
[pathstr, name, ext, versn] = fileparts(metafname);
foutname = [pathstr,delimiter,name];

% get instructions from the meta file
[id,fname,tmnt,ct,xs,ys,zs,nf]=getmetainstructions(metafname);

for id=1:nf
    cellimage_file{id}=[base_dir,fname{id},delimiter,cells_matfile];
    celldata_file{id}= [base_dir,fname{id},delimiter,cells_datfile];
    mass_file{id}.f1 = [base_dir,fname{id},delimiter,'mat',delimiter,m1,'.mat'];
    mass_file{id}.f2 = [base_dir,fname{id},delimiter,'mat',delimiter,m2,'.mat'];
    mass_file{id}.f3 = [base_dir,fname{id},delimiter,'mat',delimiter,m3,'.mat'];
    mass_file{id}.f4 = [base_dir,fname{id},delimiter,'mat',delimiter,m4,'.mat'];
end;

colors= ['rgbmckrgbmck'];
symbols=['......oooooo'];
%R=250/12.5;fac=25/12.5;
R=250/2.5;fac=25/2.5;
for nf=1:length(cellimage_file)
    disp(['Calculating ',num2str(nf),'/',num2str(length(cellimage_file))]);
    [mmia,mmis]=getANME_activity(cellimage_file{nf},celldata_file{nf},mass_file{nf},R,fac);
    % normalize the s21_3 activity to 28h incubation
    if(1 & nf>=5 & nf<=10)
        nabund=0.0106;
        mmia(:,1)=(mmia(:,1)-nabund)*28/44 + nabund;
        mmia(:,3)=(mmia(:,3)-nabund)*28/44 + nabund;
    end;
    if(1 & nf>=5 & nf<=10)   
        nabund=0.0106;
        mmis(:,2)=(mmis(:,2)-nabund)*28/44 + nabund;
    end;
    
    figure(3);
    
    subplot(2,2,1); if(nf==1), hold off, else, hold on; end;
    plot(mmis(:,3)*100,mmia(:,1),[colors(nf),symbols(nf)])
    set(gca,'xlim',[0 100],'ylim',anme_active_scale);
    s=sprintf('R=%.0fpix, edge=%.0fpix',R,R/fac);
    title(s);
    xlabel('% SR/(SR+ANME) in circle \piR^2');
    ylabel(['ANME-cell activity, (',m1,'/',m2,')']);

    subplot(2,2,2); if(nf==1), hold off, else, hold on; end;
    plot(mmis(:,2)*1e0,mmia(:,1),[colors(nf),symbols(nf)]);
    set(gca,'xlim',srb_active_scale,'ylim',anme_active_scale);
    xlabel(['avg SR activity in circle \piR^2\newlineper cell, (\Sigma',m3,'/',m4,') / N_{cell}']);
    ylabel(['ANME-cell activity, (',m1,'/',m2,')']);
    
    subplot(2,2,3); if(nf==1), hold off, else, hold on; end;
    plot(mmis(:,3)*100,mmia(:,3),[colors(nf),symbols(nf)]);
    set(gca,'xlim',[0 100],'ylim',anme_active_scale);
    xlabel('% SR/(SR+ANME) in circle \piR^2');
    ylabel(['avg ANME activity in circle \piR^2\newlineper cell, (\Sigma',m1,'/',m2,') / N_{cell}']);
    
    subplot(2,2,4); if(nf==1), hold off, else, hold on; end;
    plot(mmis(:,2)*1e0,mmia(:,3),[colors(nf),symbols(nf)]);
    set(gca,'xlim',srb_active_scale,'ylim',anme_active_scale);
    xlabel(['avg SR activity in circle \piR^2\newlineper cell, (\Sigma',m3,'/',m4,') / N_{cell}']);
    ylabel(['avg ANME activity in circle \piR^2\newlineper cell, (\Sigma',m1,'/',m2,') / N_{cell}']);
    
    %a=input('Enter');
end;

for nf=1:length(cellimage_file)
    disp([fname{nf},': ',colors(nf),symbols(nf)]);
end;

function [mmia,mmis]=getANME_activity(cellimage_file, celldata_file, mass_file, R, fac)

% read cells dat file
disp(['Reading file ',celldata_file]);
if(exist(celldata_file)==2)
    fid=fopen(celldata_file,'r');
    d=fscanf(fid,'%d %s',[2,inf]);
    fclose(fid);
    d=d';
    cellid=d(:,1);
    celltype=char(d(:,2));
end

% find out centers of all cells
% find out also average mass values in all cells
disp(['Reading file ',cellimage_file]);
c=load(cellimage_file);
c=c.Maskimg;
mi1=load(mass_file.f1);
mi2=load(mass_file.f2);
mi3=load(mass_file.f3);
mi4=load(mass_file.f4);
vc=setdiff(unique(c),0);
ncells=length(vc);
ct=zeros(size(c));
cca=[];
ccs=[];
manme=[];
msr=[];
ianme=0;
isr=0;
for ii=1:ncells
    tmp=zeros(size(c));
    ind=find(c==vc(ii));
    tmp(ind)=ones(size(ind));
    gd = regionprops(tmp,'basic');
    if(celltype(vc(ii))=='a')
        ianme=ianme+1;
        ct(ind)=ones(size(ind));
        cca(ianme,1:2)=gd.Centroid;
        manme(ianme,1:2)=[mean(mi1.IM(ind))/mean(mi2.IM(ind)) mean(mi3.IM(ind))/mean(mi4.IM(ind))];
    end;
    if(celltype(vc(ii))=='s')
        isr=isr+1;
        ct(ind)=2*ones(size(ind));
        ccs(isr,1:2)=gd.Centroid;
        msr(isr,1:2)=[mean(mi1.IM(ind))/mean(mi2.IM(ind)) mean(mi3.IM(ind))/mean(mi4.IM(ind))];
    end;
end;

inneranme=0;
ccia=[];
mmia=[];
mmis=[];

% for all anme cells further away from an edge than R/fac, find the total
% amount of SR cells surrounding it within a circle of radius R, as well as
% the total amount of P/12C present in the SR cells
w=size(c,2);
h=size(c,1);
for ii=1:size(manme,1)
    if(cca(ii,1)>R/fac & cca(ii,1)<(w-R/fac) & cca(ii,2)>R/fac & cca(ii,2)<(h-R/fac))
        inneranme=inneranme+1;
        ccia(inneranme,1:2)=cca(ii,1:2);
        % activity of a single ANME cell
        mmia(inneranme,1)=manme(ii,1);
        % calculate co-ordinates of ANME & SR cells relative to this inner anme
        % cell
        cca2=cca-ones(size(cca,1),1)*ccia(inneranme,1:2);
        ccs2=ccs-ones(size(ccs,1),1)*ccia(inneranme,1:2);
        % find which ANME & SR cells are within the radius R
        anme_anme_dist=sqrt(cca2(:,1).^2 + cca2(:,2).^2);
        sr_anme_dist=sqrt(ccs2(:,1).^2 + ccs2(:,2).^2);
        inds=find(sr_anme_dist<=R);
        if(~isempty(inds))
            % number of SR cells within R, mean SR "activity" in this
            % region
            mmis(inneranme,1:2)=[length(inds) mean(msr(inds,2))];
        else
            mmis(inneranme,1:2)=[0 0];
        end;
        inda=find(anme_anme_dist<=R);
        if(~isempty(inda))
            % number of ANME cells within R, mean ANME activity in this
            % region
            mmia(inneranme,2:3)=[length(inda) mean(manme(inda,1))];
        else
            mmia(inneranme,2:3)=[0 0];
        end;
        if 0
            % sort the distance from ANME to SR and find the average of M
            % nearest neighbours
            dasr=sort(sr_anme_dist);
            M=5;
            mmis(inneranme,3)=mean(dasr(1:M));
        else
            % find relative abundance of SR vs all cells in R
            mmis(inneranme,3)=length(inds)/(length(inds)+length(inda));
        end;
        if 0
        figure(1); subplot(1,1,1); hold off;            
        imagesc(ct); hold on;
        plot(ccia(inneranme,1),ccia(inneranme,2),'rv',...
            ccs(inds,1),ccs(inds,2),'kx',...
            cca(inda,1),cca(inda,2),'ko');

        figure(2);        
        subplot(2,2,1); hold off;
        plot(mmia(:,1),mmis(:,3),['.'])
        subplot(2,2,2); hold off;
        plot(mmia(:,1),mmis(:,2),['o']);
        subplot(2,2,3); hold off;
        plot(mmia(:,3),mmis(:,3),['.']);
        subplot(2,2,4); hold off;
        plot(mmia(:,3),mmis(:,2),['o']);
        end;
        a=0;
    end;
end;
