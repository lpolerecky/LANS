function display_all_masses(handles)
% function for displaying all masses as raw images
p=handles.p;
font_gap = 1;
global additional_settings;
fontsize = additional_settings.defFontSize;

nmasses = length(p.mass);
nscales = length(p.imscale);

if nmasses>nscales    
    for ii=1:(nmasses-nscales)
        %p.imscale{nscales+ii} = quantile(p.accu_im{nscales+ii}(:),additional_settings.autoscale_quantiles);
        p.imscale{nscales+ii} = round(find_image_scale(p.accu_im{nscales+ii}));
    end
end

if nmasses>8
    nmasses=8;
end
if nscales>8
    nscales=8;
end

[f31, ax]=my_figure(31);
fpos=get(f31,'position');

%sp=0;
if ~p.planes_aligned 
    disp('Please first align and accumulate the mass images.');
else  
    disp('*** Displaying masses ***')

    nim=length(p.accu_im);
    if nim>4
        noc=ceil(nim/2);
        jmax=2;
    else
        noc=nim;
        jmax=1;
    end
    
    w=size(p.accu_im{1},2);    
    h=size(p.accu_im{1},1);   
    im=zeros(jmax*h,noc*w);
    
    
    % assemble images into a big matrix
    def_cmat = get_colormap(additional_settings.colormap);   
    [opt1, ~, ~]=load_options(handles,1);    
    %def_cmat = clut(64);
    k=0;
    for jj=1:jmax
        for ii=1:noc
            k=k+1;
            if k<=nim
                
                ims = p.accu_im{k};                
                ch_scale = p.imscale{k};
                if opt1(4) % log-transform requested                    
                    if ch_scale(1)==0
                        ch_scale_auto = find_image_scale(ims, 0, additional_settings.autoscale_quantiles, opt1(4), 0);
                        ch_scale(1) = ch_scale_auto(1);
                        p.imscale{k} = ch_scale;
                    end
                    [ims, ch_scale] = log10transform_image(ims,ch_scale);
                end
                ncol_cmat = size(def_cmat,1);
                ims = ncol_cmat*(ims-min(ch_scale))/diff(ch_scale);
                %ind=find(ims<0);
                %if ~isempty(ind), ims(ind)=zeros(size(ind)); end
                %ind=find(ims>size(def_cmat,1));
                %if ~isempty(ind), ims(ind)=size(def_cmat,1)*ones(size(ind)); end
                im((jj-1)*h+[1:h],(ii-1)*w+[1:w])=ims;
            end
        end
    end
    % add white areas for annotations
    %fac = round(h/128);
    fac = (h/128);
    im2 = zeros(size(im,1)+round((jmax+1)*(fontsize+2*font_gap)*fac),size(im,2));
    im2([1:h]+round((fontsize+2*font_gap)*fac),:) = im([1:h],:);
    if jmax>1
        im2([1:h]+h+round(2*(fontsize+2*font_gap)*fac),:) = im([1:h]+h,:);
    end
    im = im2;
    % convert from indexed image to rgb, so that we can recolor the
    % annotation areas to white
    im2=ind2rgb(round(im),def_cmat);
    % recolor the annotation areas to white
    for jj=1:(jmax+1)
        ind = [1:round((fontsize+2*font_gap)*fac)] + round((jj-1)*(h+(fontsize+2*font_gap)*fac));
        im2(ind,:,1)=1;
        im2(ind,:,2)=1;
        im2(ind,:,3)=1;
    end
    im=im2;
    % display the assembled image
    if isempty(ax)
        figure(f31);
        ax=subplot(1,1,1);
    end
    axes(ax); 
    pause(0.1);
    imagesc(im);
    %colormap(def_cmat);
    %colormap(get_colormap(additional_settings.colormap));
    set(ax,'xtick',[],'ytick',[],'box','off',...
        'xcolor',0.999*[1 1 1],'ycolor',0.999*[1 1 1]);
    % add mass names and scale
    k=0;
    if isfield(p,'mag_factor')
        mf = p.mag_factor;
    else
        mf = 1;
    end        
    for jj=1:jmax
        for ii=1:noc
            k=k+1;
            if k<=nim
                if mf<=1
                    scale_string = sprintf('[%d %d]',round(p.imscale{k}));
                else
                    scale_string = sprintf('[%.2f %.2f]',p.imscale{k});
                end
                ts = sprintf('%s %s',p.mass{k},scale_string);
                if opt1(4)
                    ts = sprintf('log(%s)',ts);
                end
                t=text((ii-1)*w+w/2,...
                    round((jj-1)*(h+fac*(fontsize+2*font_gap))+(fontsize/2+font_gap)*fac+0),...
                    ts,...
                    'HorizontalAlignment','center','VerticalAlignment','middle',...
                    'Fontsize',fontsize,'FontName','Helvetica');
            end
        end
    end
    % add image size and number of planes
    ss=round(10*p.scale)/10;
    ss2 = round(10*p.scale*p.height/p.width)/10;
    if (round(ss)~=ss)
        ff='%.1f';
    else
        ff='%d';
    end
    if (round(ss2)~=ss2)
        ff2='%.1f';
    else
        ff2='%d';
    end
    
    if isfield(p,'xyalign')
        pl = size(p.xyalign,1);
    elseif isempty(p.images{1})
        pl = length(p.planes);
    else
        pl = length(p.images{1});
    end
    s=sprintf([ff , 'x', ff2, 'um %dx%dpix %d planes (%s@%s; %d ms)'],...
        ss,ss2,p.width,p.height,pl,p.date,p.time,p.dwell_time);
    
    if w~=p.width | h~=p.height
        s = [s sprintf(' [resized: %dx%dpix]',w,h)];
    end
        
    t=text(ax,noc/2*w,...
           round(jmax*(h+fac*(fontsize+2*font_gap))+(fontsize/2+font_gap)*fac+0),...
           s,...
           'HorizontalAlignment','center','VerticalAlignment','middle',...
           'Fontsize',fontsize,'FontName','Helvetica');
    
    % export figure as PNG
    fout=[p.filename '.png'];
    if opt1(4)
        fout = [p.filename, '_log.png'];
    end
    global additional_settings;
    pf = additional_settings.print_factors(1);
    wi=7;
    set(f31,'PaperPosition',[0.25 0.5 pf*1.3*wi pf*wi]);
    set(f31,'Position',[fpos(1:2) 200*[noc size(im,1)/h]]);
    set(f31,'toolbar','none');
    set(ax,'position',[0.0 0.0 1 1]);
    set(ax,'DataAspectRatio',[1 1 1]);
    set(f31,'PaperPositionMode','auto')
    print(f31,fout,'-dpng');
    fprintf(1,'Summary figure exported to %s\n',fout);

    a=0;

end
