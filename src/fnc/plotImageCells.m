function [CELLS,f,a,b, ax]=plotImageCells(f,IM,CELLS,fdir,mass_,outline_color,imscale,...
    opt1,opt3,export_flag,scale,title_,cellfile,images,planes,imconf)
% Plot image IM, together with the cell outline (CELLS, if non-empty), as a
% nicely formatted image. 
% Optionally, calculate histograms of the pixel values in the classified
% cells, display them and export as EPS.
% Optionally, export the 16-bitmaps as TIF.
% Export the IM data, with CELS, imscale and noplanes, as MAT file.

%disp('*** This is plotImageCells ***');

global additional_settings;

if isfield(additional_settings,'defFontSize')
    defFontSize = additional_settings.defFontSize;
else 
    defFontSize=10;
end;

% hack for correcting background 
if 0    
    bkg=IM(178:243,8:82);
    bkg = mean(bkg(:));
    bkg_cor=0.0005;
    IM=IM-bkg+bkg_cor;
end;

% find out color of the cell outline
if(nargin>5)
    oc=outline_color;
else
    oc='w';
end;

% define default options, if they are not defined
if(nargin>7)
    o1=opt1;
    o3=opt3;
else
    o1=[1 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0];
    o3=0;
end;

%% find scaling of the image
sf=1;
if nargin>6    
    if ischar(imscale)        
        if isempty(strfind(imscale,'auto')) % if imscale was defined        
            imscale = str2num(imscale);    
            if ~isempty(imscale)
                mi=imscale(:,1);
                ma=imscale(:,2);
            else
                for ii=1:size(IM,3)
                    a = find_image_scale(IM(:,:,ii),0,additional_settings.autoscale_quantiles,o1(4),0,[]);
                    mi(ii,1)=a(1);
                    ma(ii,1)=a(2);
                end;
            end;        
        else    % if autoscale requested
            for ii=1:size(IM,3)
                a = find_image_scale(IM(:,:,ii),0,additional_settings.autoscale_quantiles,o1(4),0,[]);
                mi(ii,1)=a(1);
                ma(ii,1)=a(2);
            end;
        end;        
    else        
        if ~isempty(imscale)
            for ii=1:size(IM,3)
                mi(ii,1)=imscale(ii,1);
                ma(ii,1)=imscale(ii,2);
            end;
        else
            for ii=1:size(IM,3)
                a = find_image_scale(IM(:,:,ii),0,additional_settings.autoscale_quantiles,o1(4),1,[]);
                mi(ii,1)=a(1);
                ma(ii,1)=a(2);
            end;
        end;            
    end;    
else    
    if min(IM(:))==max(IM(:))
        mi=0; ma=1;
    else
        for ii=1:size(IM,3)
            a = find_image_scale(IM(:,:,ii),0,additional_settings.autoscale_quantiles,o1(4),0,[]);
            mi(ii,1)=a(1);
            ma(ii,1)=a(2);
        end;
    end;
    
end;

fac = ones(length(ma),1);
for ii=1:length(ma)
    
    if mi(ii)==ma(ii)
        % in case image is flat
        ma(ii)=mi(ii)+1;
    end;

    % for small range, values will be multiplied by 1000
    if (ma(ii)-mi(ii))<=1e3 | (ma(ii)-mi(ii))>=1e4
        fac(ii)=10^ceil(-log10(ma(ii)-mi(ii)));
    else
        fac(ii) = 1;
    end;
    if ~additional_settings.apply_1e3_factor
        fac(ii) = 1.000;
    end;
    
end;

% define default export_flag, if not defined
if(nargin>9)
  ef=export_flag;
else
  ef=1;
end;

% default scale, if not known
if(nargin>10)
    xyscale=scale;
else
    xyscale=50;
end;

if nargin>15
    conf = imconf;
else
    conf = ones(size(IM,1),size(IM,2));
end;

% if "zero values outside cells" checked
if( ~isempty(CELLS) & o1(2) )
    ind=find(CELLS==0);
    IM(ind)=zeros(size(ind));
end;

%% open figure where the image will be displayed
% set the default figure position to the middle of the screen if the figure
% does not exist, or leave it as it is if it does exist.
if(ishandle(f))
    fpos=my_get(f,'Position');
else
    FigPos=get(0,'DefaultFigurePosition');
	FigPos(3:4)=1.2*FigPos(4)*[1 1];
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);
    FigPos(1)=1/2*(ScreenSize(3)-FigPos(3));
    FigPos(2)=2/3*(ScreenSize(4)-FigPos(4));
    fpos=FigPos;
end;

IM_orig=IM;
mass_orig=mass_;
mima_orig=[mi ma];

%% log10-transform the image and scale, if requested, but not if it is a cells image
if o1(4) && ~strcmp(mass_,'cells')
    fac=1;
    
    % LP: this was incorrect if only log-representation of the data is
    % displayed
    %if isempty(findstr(mass_,'log'))
    %    mass_=['log(',mass_,')'];
    %end
    
    % calculate image logarithm, but only if it is not an RGB image, because
    % 1) RGB has been already log10-transformed in the calculate_RGB_image function
    % 2) RGB should not be log10-transformed if it is an external image
    if size(IM,3)==1
        t1=now;    
        logIM=log10(mi)*ones(size(IM));
        ind=find(IM>mi);
        logIM(ind)=log10(IM(ind));
        IM=logIM;
        mi=log10(mi);
        ma=log10(ma);
        t2=now;
        %fprintf(1,'Conversion to log took %.3fs\n',(t2-t1)*24*3600);
    end
end

%% display the image, if requested
if o1(6) && prod(mi<ma)
    f=figure(f);
	set(f,'Units','pixels');
    set(f,'Position',fpos);
    set(f,'ToolBar','none','MenuBar','none','Name',mass_);
    
    fc=get(f,'Children');
    ind_ax=find(isgraphics(fc,'Axes'));
    if ~isempty(ind_ax)
        ax = fc(ind_ax);
    else
        ax=subplot(1,1,1); hold off;
    end
    
    if(size(IM,3)>1)
        % transform image according to the scale and display it
        for ii=1:size(IM,3)
            tmp=[]; 
            tmp(:,:)=(IM(:,:,ii)-mi(ii))/(ma(ii)-mi(ii));
            ind=find(tmp<0);
            tmp(ind)=zeros(size(ind));
            ind=find(tmp>1);
            tmp(ind)=ones(size(ind));
            IM(:,:,ii)=tmp;
        end
        a=imagesc(IM);
        xt_auto = [];
        xtl_auto = [];
        colmap = get_colormap(additional_settings.colormap);
    else
        % display image with the specified scale (fac is 1 or 1e3)
        if mi==0 && ma==-Inf, ma=1; end
        if o3==0            
            cmap=additional_settings.colormap;
        elseif o3==1
            cmap=2;
        end
        
        [a, xt_auto, xtl_auto, colmap, b, ~] = imagesc_conf(IM*fac, fac*mi, fac*ma, conf, ...
            cmap, additional_settings.color_bar_pos, ax, o1(4));
    end
    
    %set(ax,'xtick',[],'ytick',[],'dataaspectratio',[1 1 1]); 

    % add scale line
    if ~strcmp(mass_,'cells')
        add_scale_line(xyscale,IM,oc);
    end
    
    % add title
    add_image_title(ax,title_,mass_,fac,size(IM),o1(15));
    
    % add cell outline, if requested
    if(o1(1) && ~isempty(CELLS))
        CELLS=addCellOutline(ax,CELLS,oc);
        % hack for Jana (clasify cells faster)
        if 0
            addCellNumbers(f,CELLS);
        end
    else
        roib = findobj(ax,'tag','roi_boundary');
        if ~isempty(roib)
            delete(roib);
        end
    end

    % set axis and colorbar position nicely
    if(size(IM,3)==1)
        global CELLSFILE
                        
        if additional_settings.color_bar_pos==2

            % colorbar at the bottom
            sfac=size(IM,1)/size(IM,2);
            xylim='x';
            if sfac<=1
                set(ax,'Position',[0.1 0.13+0.5*0.8*(1-sfac) 0.8 0.8*sfac]);
                if isempty(b)
                    b=colorbar('location','SouthOutside');
                end
                set(b,'Position',[0.14 0.1+0.5*0.8*(1-sfac) 0.72 0.02]);
            else
                set(ax,'Position',[0.1+0.5*0.8*(1-1/sfac) 0.11 0.8/sfac 0.8]);
                if isempty(b)
                    b=colorbar('location','SouthOutside');
                end
                set(b,'Position',[0.14+0.5*0.8*(1-1/sfac) 0.08 0.68/sfac 0.02]);
            end  
            set(b,'Ticks', (xt_auto-mi)/(ma-mi), ...
                'TickDirection', 'out', ...
                'TickLabels', xtl_auto);

        elseif additional_settings.color_bar_pos==1

            % colorbar on the right
            sfac=size(IM,1)/size(IM,2);
            xylim='y';
            if sfac<=1
                set(ax,'Position',[0.04 0.09 + 0.5*0.8*(1-sfac) 0.8 0.8*sfac]);
                if isempty(b)
                    b=colorbar('location','EastOutside');
                end
                set(b,'Position',[0.86 0.13 + 0.5*0.8*(1-sfac) 0.02 0.72*sfac]);
            else
                set(ax,'Position',[0.04+0.5*0.8*(1-1/sfac) 0.11 0.8/sfac 0.8]);
                gcap=get(ax,'Position');
                if isempty(b)
                    b=colorbar('location','EastOutside');
                end
                set(b,'Position',[gcap(1)+gcap(3)+0.02 0.11 0.02 0.8]);
            end
            set(b,'Ticks', (xt_auto-mi)/(ma-mi), ...
                'TickDirection', 'out', ...
                'TickLabels', xtl_auto);
            b.Ruler.TickLabelRotation=0;

        end

        if additional_settings.color_bar_pos==2 || additional_settings.color_bar_pos==1
            set(b,'FontSize',defFontSize);
            if ~additional_settings.include_colorbar_label
                set(b,'YTick','');
            end
        end

        % remove colorbar from ROIs image
        if strcmp(mass_,CELLSFILE)
            if ~isempty(b)
                delete(b)
            end
        end
        
        % set the correct colormap
        if(min(IM(:))==max(IM(:)) || o3)
            colormap(get_colormap(2));
        else
            %colormap(get_colormap(additional_settings.colormap));
            colormap(colmap);
        end   
        
        % improve the arrangement of the colorbar xticks/labels nicely, but
        % only if hue intensity modulation is applicable
        if 0 && prod(conf(:))~=1 && ~strcmp(mass_,'cells') && ~isempty(b)
            % current lim of the colorbar
            xl=get(b,[xylim 'lim']);            
            yt = xt_auto;
            ytp = (yt/fac-mi)/(ma-mi);
            xtnew = ytp*diff(xl)+xl(1);
            set(b,[xylim 'tick'],xtnew);
            % center all ticklabels, to ensure that the locations and
            % strings match well (only relevant for xticklabels)
            if xylim=='x'
                for kk=1:size(xtl_auto,1)
                    sk = xtl_auto(kk,:);
                    if iscell(sk)
                        sk=sk{1};
                    end
                    indsp=findstr(sk,' ');
                    if length(indsp)>0
                        numsp=ceil(length(indsp)/2);
                        sknew=[' '*ones(1,numsp) sk(1:indsp(numsp))];
                        xtl_auto(kk,1:length(sknew)) = sknew;
                    end
                end
            end
            set(b,[xylim,'ticklabel'],xtl_auto);
            if ~additional_settings.include_colorbar_label
                set(b,[xylim 'tick'],'');
            end
        end
    else
        set(ax,'dataaspectratio',[1 1 1]);
    end 
    
    % bring window to the front
    figure(f);
    
    fitb=findobj(f,'tag','fit_button');
    if ~isempty(fitb)
        delete(fitb);
    end
    
else
    
    if mi>=ma
        fprintf(1,'WARNING: incorrect image scale. MAX must be greater than MIN.\n');
    end
    
end


% plot also histogram of the pixel values belonging to cells 
% do it for all defined cell types
if o1(3) & ~isempty(CELLS) & isempty(findstr(mass_,CELLSFILE))
    
    % define number of bins in the histogram, depending on the unique
    % values in IM
    if(length(unique(IM(:)))<60)
        hbins = 10;
    else
        hbins = 40;
    end;
    
    fncells=cellfile;
    
    % generate the histograms
    
    if isa(f,'numeric')
        f1=my_figure(f+10);
    else
        f1=my_figure(f.Number+10);
    end
    
%     if matversion >= 2015
%         f1=my_figure(f.Number+10);  % in Matlab 2015 or higher
%     else
%         f1=my_figure(f+10);
%     end;

    ax=subplot(1,1,1);
    hold off; 
    
    if(exist(fncells)==2)
        
        [cidu,cc,cid,cnum]=load_cell_classes(fncells);
        leg=[];
        xout=linspace(mi,ma,hbins);
        
        for ii=1:length(cidu)
            % find indexes of cells that belong to class cidu(ii)
            ind=find(cid==cidu(ii));
            % determine which pixels belong to those cells
            pix=ismember(CELLS,ind);
            % get IM values in those pixels and add them to the histogram
            d=IM(pix);
            ind=find(d>mi & d<ma);            
            if(~isempty(ind))
                dind = d(ind);
                [h(:,ii)]=histc(dind,xout);
                fprintf(1,'cells %c: [mean, std, q0.05, q0.95] =\t%.3e\t%.3e\t%.3e\t%.3e\n',...
                    char(cidu(ii)),mean(dind),std(dind),quantile(dind,[0.05 0.95]));
                plot(xout,h(:,ii),[cc(ii),'o-']); 
                hold on
                leg{ii}=char(cidu(ii));
                s=sprintf('%s: %.2e (SD=%.2e)',leg{ii},mean(dind),std(dind));
                leg{ii}=s;
            end;
        end;

                
        % add also the histogram for all pixels whose values are in the
        % range specified by the scale
        ind=find(CELLS>0);
        d=IM(ind);
        ind=find(d>mi & d<ma);
        if(~isempty(ind))            
            leg{ii+1}='all pixels';        
            [h(:,ii+1)]=histc(d(ind),xout);
            plot(xout,h(:,ii+1),'k-','LineWidth',2);                    
        end;
        legend(leg)
        legend('boxoff');
        
    else
        
        % if cells are not classified, just make the histogram for all pixels
        % in IM that belong to cells and whose values are in the range specified by the scale
        ind=find(CELLS>0);
        d=IM(ind);
        ind=find(d>mi & d<ma);
        xout=linspace(mi,ma,hbins);
        if(~isempty(ind))
            dind = d(ind);
            [h]=histc(dind,xout);
            h=h(:);
            bar(xout,h);            
            leg{1}='all pixels';
            s=sprintf('%s: %.2e (SD=%.2e)',leg{1},mean(dind),std(dind));
            legend(s);
            %disp(s);
            fprintf(1,'%s: [mean, std, q0.05, q0.95] =\t%.3e\t%.3e\t%.3e\t%.3e\n',...
                    leg{1},mean(dind),std(dind),quantile(dind,[0.05 0.95]));                
        end;
        
    end;
    
    % make the figures look nicer   
    set(gca,'FontSize',defFontSize);
    xlabel(mass_,'Interpreter','none','FontSize',defFontSize);
    ylabel('pixel count','Interpreter','none','FontSize',defFontSize);
    set(gca,'xlim',[mi ma]);
    if opt1(15)
        add_title(title_,additional_settings.title_length, defFontSize);
    end;
    
    % export the histograms data as ascii
    if o1(10)
        histograms=[xout(:) h];
        newdir=[fdir,'dat',delimiter];
        if(~isdir(newdir))
            mkdir(newdir);
            fprintf(1,'Directory %s did not exist, so it was created.\n',newdir);
        end;
        a=convert_string_for_texoutput(mass_);
        fout=[newdir,a,'-h.dat'];
        fid=fopen(fout,'w');
        fprintf(fid,'# %s\t',mass_);
        for ii=1:length(leg)
            fprintf(fid,'%s\t',leg{ii});
        end;
        fprintf(fid,'\n');
        fmt='%5.3e';
        for ii=1:size(h,2)
            fmt=[fmt,'\t%d'];
        end;
        fmt=[fmt,'\n'];
        fprintf(fid,fmt,histograms');
        fclose(fid);
        fprintf(1,'Histogram data saved to %s\n',fout);
    end;
        
    % export graph as pdf
    if o1(11)
        newdir=[fdir,'eps',delimiter];
        if(~isdir(newdir))
            mkdir(newdir);
            fprintf(1,'Directory %s did not exist, so it was created.\n',newdir);
        end;       
        a=convert_string_for_texoutput(mass_);
        % first print as eps, then convert to pdf
        fout=[newdir,a,'-h.eps'];
        %print(f1,fout,'-depsc2');
        print_figure(f1,fout,additional_settings.print_factors(6));
        %disp(['Histogram plotted as ',fout]);
        % create also PDF file, so that it can be included by pdflatex 
        mepstopdf(fout,'epstopdf');
        % print also as png, if requested
        if additional_settings.export_png
            fout=[newdir,a,'-h.png'];
            print(f1,fout,'-dpng');
            disp(['Histogram plotted as ',fout]);
        end
    end
    
end

% export the data as BW Tiff image as well, if B&W option was selected
if (o1(6) & o3 & additional_settings.export_tif) & ef
    
    Nbits = 8;
    % make a Nbits-bit dataset
    maxbw=2^Nbits-1;
    expim=(IM-mi)/(ma-mi)*maxbw;
    ind=find(expim<0);
    expim(ind)=zeros(size(ind));
    ind=find(expim>maxbw);
    expim(ind)=maxbw*ones(size(ind));
    % create output tif directory, if it doesn't exist yet
    fdir = fixdir(fdir);
    newdir=[fdir,'tif',delimiter];    
    if(~isdir(newdir))
        mkdir(newdir);
        fprintf(1,'Directory %s did not exist, so it was created.\n',newdir);        
    end
    
    % generate the output filename and export
    a=convert_string_for_texoutput(mass_);
    fout=[newdir,a,'.tif'];
    if Nbits==16
        imwrite(uint16(expim),fout,'tif','Compression','none');
    elseif Nbits==8
        imwrite(uint8(expim),fout,'tif','Compression','none');
    end
    fprintf(1,'%d-bit image exported as %s\n',Nbits, fout);
    
end

% export in matlab format for future post-processing
if ef & o1(6)

    % create output mat/ directory, if it doesn't exist yet
    fdir = fixdir(fdir);
    matdir=[fdir,'mat',delimiter];
    if(ef & ~isdir(matdir))
        mkdir(matdir);
        fprintf(1,'Directory %s did not exist, so it was created.\n',matdir);
    end;

    % generate the output filename and export
    a=convert_string_for_texoutput(mass_orig);
    global CELLSFILE MAT_EXT;
    fout=[matdir,a,MAT_EXT];
    if(~strcmpi(a,CELLSFILE))
        if ~isempty(images)
            noplanes =  length(images);
        else
            noplanes = length(planes);
        end
        vscale=mima_orig;
        IM=IM_orig;
        save(fout,'IM','CELLS','xyscale','noplanes','vscale','-v6');
        fprintf(1,'Variables IM, CELLS, NOPLANES, XYSCALE and VSCALE saved to %s\n',fout);
        if 0
            % export as CSV (only use when providing raw data for publishing)
            fcsv=[matdir,a,'.csv'];
            % matlab exports the data in a strange way, so I implement my
            % own export
            fmt=(ones(size(IM,2),1).*double('%.4e\t'))'; % 5 significant digits precision should be sufficient
            fmt=[char(fmt(:))' '\n'];
            fid=fopen(fcsv,'w');
            fprintf(fid,fmt,IM');
            fclose(fid);
            fprintf(1,'Variable IM exported to %s\n',fcsv);
        end
    end
    
end

if o1(6)
    figure(f);
end;
