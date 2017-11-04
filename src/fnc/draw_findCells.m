function [l2,nc,c,cello]=draw_findCells(p,thr,man_draw,f,pscale,handles)
% function for recognizing positions of cells in image p, based on drawing of one cell
% outline. searching of cell peaks will be done from the maximum (1) until thr<1.


disp('*** This is draw_findCells ***');

if(nargin>1)
    tt=thr;
else
    tt=0.5;
end;
if(nargin>2)
    md=man_draw;
else
    md=1;
end;
if(nargin>3)
    fn=f;
else
    fn=20;
end;
if(nargin>4)
    ps=pscale;
else
    ps=[0 1];
end;

if(md)
    [x,y]=meshgrid([1:size(p,1)],[1:size(p,2)]);
    fn=figure(fn); 
    close(fn);
    fn=figure(fn); 
    hold off; 
    imagesc(p,ps); title('original image');
    colormap(gray);
    workdir=handles.p.fdir;
    workdir=fixdir(workdir);
    disp('Select file with the training cell');
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select *.MAT file with the training cell', workdir);
    if(FileName~=0)
        imfile = [newdir, FileName];
        eval(['c=load(''',imfile,''');']);
        tcell=c.tcell;
        fe=c.fe;
        [B,L]=bwboundaries(tcell,'noholes');
        cello = B{1};
        % center cell outline
        cello = cello - ones(size(cello,1),1) * mean(cello,1);
    else
        % ask to draw the region corresponding to one cell
        disp(['Ok. You decided to draw the training cell by hand.']);
        input('Resize the figure and press enter before drawing.');
        disp('Draw a training cell.');
        c=mousetrack2;
        cello=c;
        %in=inpolygon(x,y,c(:,1),c(:,2));
        in = poly2mask(round(c(:,1)),round(c(:,2)),size(Maskimg,1),size(Maskimg,2));
        fe=p.*in;
        % extract only the feature, not the zero around it
        yint=[floor(min(c(:,2))):ceil(max(c(:,2)))];
        xint=[floor(min(c(:,1))):ceil(max(c(:,1)))];
        fe=fe(yint,xint);
        figure(fn+1);
        imagesc(fe); title('feature to be recognized');
        colormap(gray);
        disp(['Specify file name for the specified cell.']);
        tcell=fe;
        ind=find(tcell>0);
        tcell(ind)=ones(size(ind));    
        % save defined cell into a file
        disp('Select file where the training cell will be stored');
        [FileName,newdir,newext] = uiputfile('*.mat', 'Select *.MAT file to store the training cell', workdir);
        if(FileName~=0)
            imfile = [newdir, FileName];
            eval(['save ',imfile,' tcell fe -v6']);
        end;
    end;
    
    % here we know the training cell, so we can search it in the entire
    % image. but if the positions have been already saved, we should give
    % the user a chance to load it
    
    disp('Select file with training cell centers, ESC for automated detection.');
    [FileName,newdir,newext] = uigetfile('*.mat', 'Select *.MAT file with the cell centers', workdir);
    if(FileName~=0)
        imfile = [newdir, FileName];
        eval(['cc=load(''',imfile,''');']);
        c=cc.c;
    else
        % find centers automatically

        % smooth the image before searching for the feature (remove spikes)
        p=medfilt2(p,[5 5]);

        % calculate 2D correlation from which the local peaks will be found
        Ic=xcorr2(p,fe);
        Ic=(Ic/max(Ic(:)));
        ds=ceil((size(Ic)-size(p))/2);
        I_eq=Ic(ds(1):(size(Ic,1)-ds(1)),ds(2):(size(Ic,2)-ds(2)));
        Ic=I_eq;

        Il=zeros(size(Ic));
        step=0.01;
        ml=ceil(tt/step);
        % search for peaks in Ic;
        disp(['Searching for peaks, please be patient.'])
        for ii=1:ml
            bw1 = im2bw(Ic, 1-step*ii);
            bw2 = im2bw(Ic, 1-step*(ii-1));    
            ind=find(bw1==1 & bw2~=1);
            Il(ind)=bw1(ind)*(ml+1-ii);
            if(ii==1)
                [lb_old,nob_old] = bwlabel(Il,8);        
            else
                [lb_new,nob_new] = bwlabel(Il,8);
                [lb_new,nob_new,lb_old] = getnewarea(lb_old,nob_old,lb_new,nob_new);
                if(nob_new>0)
                    lb_old=lb_old+lb_new;
                    nob_old=nob_old+nob_new;
                else
                    lb_old=lb_new;
                end;
            end;   
            %s=sprintf('%d/%d ',ii,ml);
            %disp(s);
            % use this to display the partial results
            if 0
                figure(fn+4); imagesc(Il); colormap(jet); colorbar;
                Ia=zeros(size(lb_old));
                ind=find(lb_old>0);
                Ia(ind)=ones(size(ind));
                figure(fn+5); imagesc(lb_old); colormap(jet); colorbar;
                % if(ii>30), input([num2str(ii),': press enter']); end;
                pause(0.25);
            end;
        end;

        gd_old = regionprops(lb_old,'basic');
        c = cat(1, gd_old.Centroid);
    end;

    % now the centers of the peaks, corresponding to the cells centers, 
    % were found, so show them on the original image
    close(fn);
    fn=figure(fn); 
    hold off; 
    imagesc(p,ps); title('original image');
    colormap(clut);
    figure(fn); hold on;
    cp(1)=plot(c(:,1),c(:,2),'wo');
    cp(2)=plot(c(:,1),c(:,2),'kx');
    
    disp('Cell centers found. Use mouse to redefine those that were localized incorrectly');
    disp('*** Left-click=select point; Right-click=confirm point; ESC=finish ***');
    m=1;
    pt=[];
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
                pt(1)=plot(xp,yp,'wo');
                pt(2)=plot(xp,yp,'rx');
            else
                set(pt(1),'xdata',xp,'ydata',yp);
                set(pt(2),'xdata',xp,'ydata',yp);
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
                    c=[c; [xp yp]];
                end;
                % update currently defined points
                set(cp(1),'xdata',c(:,1),'ydata',c(:,2));
                set(cp(2),'xdata',c(:,1),'ydata',c(:,2));
            end;           
        end;
    end;
    
    % sort cells such that their x positions are increasing
    [cs,ind]=sort(c(:,1));
    c(:,1)=cs;
    c(:,2)=c(ind,2);

    % here all the cell centers are known, so just add the cell outlines
    % and you are done
    
    % the first approach is the one that I developed first, but then it is
    % perhaps better just to add the cell outline defined for one
    % represenative cell.
    if 1
        nc=size(c,1);
        % transfer the cell outline so that it's center is [0 0]
        cello = cello - ones(size(cello,1),1) * mean(cello,1);
        px=size(p,2); 
        py=size(p,1);
        l3=zeros(py,px);
        for ii=1:nc
            pts = cello+ones(size(cello,1),1) * [c(ii,1) c(ii,2)];
            bw=poly2mask(pts(:,1),pts(:,2),py,px);
            ind=find(bw>0);
            l3(ind)=bw(ind)*ii;
        end;            
    end;
    
    if 0 % this was the old appraoch
        % reconstruct bwlabels from the identified cell centers and the feauture
        nc=size(c,1);
        fee=adapthisteq(fe);
        ind=find(fee<1);
        fee(ind)=zeros(size(ind));
        l2=zeros(size(p));
        l3=zeros(size(p));
        l2b=[];
        disp('Defining cells');
        for ii=1:nc
            ix=round([1:size(fee,2)] + c(ii,1) - round(size(fee,2)/2));
            ind=find(ix>0 & ix<=size(l2,2));
            ix_old = ix(ind);
            [ix,indx]=intersect(ix,ix_old);
            iy=round([1:size(fee,1)] + c(ii,2) - round(size(fee,1)/2));
            ind=find(iy>0 & iy<=size(l2,1));
            iy_old = iy(ind);
            [iy,indy]=intersect(iy,iy_old);
            pe=p(iy,ix).*fee(indy,indx);
            pe2=zeros(size(pe));
            ind0=find(pe>0);
            ind=find(pe>=0.2*median(pe(ind0)));
            pe2(ind)=pe(ind);
            pe2=imfill(pe2,'holes');
            ind=find(pe2>0);
            pe2(ind)=ones(size(ind));
            p3=l2(iy,ix);
            p4=zeros(size(p3));
            ind=find(p3==0);
            p4(ind)=ii*pe2(ind);
            ind=find(p3>0);
            p4(ind)=p3(ind)+pe2(ind);
            %l2(iy,ix)=ii*pe2;
            l2(iy,ix)=p4;
            [B,L] = bwboundaries(p4,'noholes');
            %if(ii==77), keyboard; end;
            kk=1;
            ml=length(B{kk});
            for jj=1:length(B)
                if(length(B{jj})>ml)
                    kk=jj;
                end;
            end;
            x = B{kk}(:,1);
            y = B{kk}(:,2);        
            %disp(num2str(ii));
            [k,a] = convhull(x, y);
            l2b{ii}(:,1)=B{kk}(k,2)+c(ii,1)- round(size(fee,2)/2);
            l2b{ii}(:,2)=B{kk}(k,1)+c(ii,2)- round(size(fee,1)/2);
            pts=l2b{ii};
            bw=poly2mask(pts(:,1),pts(:,2),256,256);
            ind=find(bw>0);
            l3(ind)=bw(ind)*ii;
        end;
    end;
    
    l2=l3;
    disp([num2str(nc),' cells identified.']);
    % now labels of the identified cells are stored in l2
    
    % display identified cells
    %figure(fn+2); hold off;
    %imagesc(l2); colormap(jet); 
    %set(gca,'xtick',[],'ytick',[]);
    
    % display cell outlines in the original image, redraw it, because
    % mousetrack2 makes it non-resizeable (somehow)
    %fn=figure(fn); 
    f1=figure(fn);
    close(f1);
    f1=figure(fn+1);
    close(f1);
    
     
    %hold off; 
    %imagesc(p,ps); title('original image');
    %colormap(clut);
    %set(gca,'xtick',[],'ytick',[]);
    %addCellOutline(fn,l2);
    
    disp('Select filename to save cells centers.');
    
    % save the cell centers into a file
    [FileName,newdir,newext] = uiputfile('*.mat', 'Select *.MAT file to save cells centers', workdir);
    if(FileName~=0)
        imfile = [newdir, FileName];
        eval(['save ',imfile,' c -v6']);
        disp(['Cell centers saved into ',imfile]);
    end;
end;
