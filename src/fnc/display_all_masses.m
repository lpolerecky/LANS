function display_all_masses(handles)
% function for displaying all masses as raw images
p=handles.p;
fontsize = 8;
font_gap = 1;

nmasses = length(p.mass);
nscales = length(p.imscale);
if nmasses>nscales
    global additional_settings;
    for ii=1:(nmasses-nscales)
        %p.imscale{nscales+ii} = quantile(p.accu_im{nscales+ii}(:),additional_settings.autoscale_quantiles);
        p.imscale{nscales+ii} = round(find_image_scale(p.accu_im{nscales+ii}(:)));
    end;
end;

if nmasses>8
    nmasses=8;
end;
if nscales>8
    nscales=8;
end;

f31=my_figure(31);
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
    end;
    
    w=size(p.accu_im{1},2);    
    h=size(p.accu_im{1},1);    
    im=zeros(jmax*h,noc*w);
    
    
    % assemble images into a big matrix
    def_cmat = clut(64);
    k=0;
    for jj=1:jmax
        for ii=1:noc
            k=k+1;
            if k<=nim
                ims=size(def_cmat,1)*(p.accu_im{k}-min(p.imscale{k}))/(max(p.imscale{k})-min(p.imscale{k}));
                ind=find(ims<0);
                if ~isempty(ind), ims(ind)=zeros(size(ind)); end;
                ind=find(ims>size(def_cmat,1));
                if ~isempty(ind), ims(ind)=size(def_cmat,1)*ones(size(ind)); end;            
                im((jj-1)*h+[1:h],(ii-1)*w+[1:w])=ims;
            end;
        end;
    end;
    % add white areas for annotations
    fac = round(h/128);
    im2 = zeros(size(im,1)+jmax*(fontsize+2*font_gap)*fac,size(im,2));
    im2([1:h]+(fontsize+2*font_gap)*fac,:) = im([1:h],:);
    if jmax>1
        im2([1:h]+h+2*(fontsize+2*font_gap)*fac,:) = im([1:h]+h,:);
    end;
    im = im2;
    % convert from indexed image to rgb, so that we can recolor the
    % annotation areas to white
    im2=ind2rgb(round(im),def_cmat);
    % recolor the annotation areas to white
    im2([1:(fontsize+2*font_gap)*fac],:,1)=1;
    im2([1:(fontsize+2*font_gap)*fac],:,2)=1;
    im2([1:(fontsize+2*font_gap)*fac],:,3)=1;
    if jmax>1
        im2([1:(fontsize+2*font_gap)*fac]+h+(fontsize+2*font_gap)*fac,:,1)=1;
        im2([1:(fontsize+2*font_gap)*fac]+h+(fontsize+2*font_gap)*fac,:,2)=1;
        im2([1:(fontsize+2*font_gap)*fac]+h+(fontsize+2*font_gap)*fac,:,3)=1;
    end;
    im=im2;
    % display the assembled image
    imagesc(im);
    colormap(def_cmat);
    set(gca,'xtick',[],'ytick',[],'box','off');
    % add mass names and scale
    k=0;
    for jj=1:jmax
        for ii=1:noc
            k=k+1;
            if k<=nim
                if k==1
                    ss=round(10*p.scale)/10;
                    if (round(ss)~=ss)
                        ff='%.1fum';
                    else
                        ff='%dum';
                    end;
                    s=sprintf([' (', ff, '/%dx%d/%d)'],ss,p.width,p.height,length(p.planes));
                else
                    s=[];
                end;
                t=text((ii-1)*w+w/2,(jj-1)*(h+fac*(fontsize+2*font_gap))+(fontsize/2+font_gap)*fac,sprintf('%s [%d %d]%s',p.mass{k},round(p.imscale{k}),s),...
                    'HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',fontsize,...
                    'FontName','Helvetica');
                %'BackgroundColor',[1 1 1],...
            end;
        end;
    end;
    
end;

% export figure as PNG
fout=[p.filename '.png'];
global additional_settings;
pf = additional_settings.print_factors(1);
w=7;
set(f31,'PaperPosition',[0.25 0.5 pf*1.3*w pf*w]);
set(f31,'Position',[fpos(1:2) 200*[noc size(im,1)/h]]);
set(f31,'toolbar','none');
set(gca,'position',[0.0 0.0 1 1]);
set(gca,'DataAspectRatio',[1 1 1]);
set(f31,'PaperPositionMode','auto')
print(f31,fout,'-dpng');
fprintf(1,'Summary figure exported to %s\n',fout);

a=0;
