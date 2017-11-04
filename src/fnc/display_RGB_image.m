function display_RGB_image(rgb7, rgb8, p, opt1, tit, xl, yl, zl,h)
% display the rgb image, with some simple formating, and export it as eps
% and 16-bit tif
if matversion==2015
defFontSize=10;
else
defFontSize=14;
end;

global additional_settings;

if(~isempty(rgb7) | ~isempty(rgb8))

    for ii=1:2
        if ii==1
            rgb=rgb7;
            plotopt=opt1(7);
        else
            rgb=rgb8;
            plotopt=opt1(8);
        end;
        if(plotopt)
            mf=my_figure(35+ii); hold off;
            imagesc(rgb);
            set(gca,'DataAspectRatio',[1 1 1],'xtick',[],'ytick',[]);
            % include title, if requested
            if opt1(15)
                if(~isempty(tit))
                    tit2=[tit];
                    xlab=['R=',xl,'; G=',yl,'; B=',zl];
                    if(length(tit2)>38)
                        tit2=['...',tit2([(length(tit2)-38):length(tit2)])];
                    end;
                    xlabel(tit2,'interpreter','none','fontweight','normal','FontSize',additional_settings.defFontSize);
                    title(xlab,'interpreter','none','fontweight','normal','FontSize',additional_settings.defFontSize);
                else
                    title(['R=',xl,'; G=',yl,'; B=',zl],'interpreter','none','fontweight','normal','FontSize',additional_settings.defFontSize);
                    %xl=xlabel('');
                    %delete(xl);
                end;
            end;
            
            % add scale line
            cw=get(h.edit62,'string');
            if(isempty(cw))
                cw = 'w';
            end;
            add_scale_line(p.scale,rgb7(:,:,1),cw);
            
            % add cell outline
            if(opt1(1))
                %hold on;
                addCellOutline(mf,p.Maskimg,cw);
            end;
                
            
            if(opt1(11))
                % export RGB image (as eps and tif)
                if(~isempty(xl) & ~isempty(yl) & ~isempty(zl))
                    xyfile0=[xl,'-vs-',yl,'-vs-',zl];
                else
                    if(isempty(xl))
                        xyfile0=[yl,'-vs-',zl];
                    end;
                    if(isempty(yl))
                        xyfile0=[xl,'-vs-',zl];
                    end;
                    if(isempty(zl))
                        xyfile0=[xl,'-vs-',yl];
                    end;
                end;
                if(ii==1)
                    ext='-rgb';
                else
                    ext='-rgba';
                end;                
                xyfile=convert_string_for_texoutput([xyfile0,ext]);
                xyfile=[xyfile,'.eps'];
                xyfile=[p.fdir,'eps',delimiter,xyfile];
                %xlabel('\it Olavius algarvensis \rm (section 25h-sec)');
                epsdir = fileparts(xyfile);
                if(~isdir(epsdir))
                    mkdir(epsdir);
                    fprintf(1,'Directory %s did not exist, so it was created.\n',epsdir);
                end;
                print_figure(mf,xyfile,additional_settings.print_factors(1));
                %fprintf(1,'RGB image saved as %s\n', xyfile);
                mepstopdf(xyfile,'epstopdf');
                xyfile=convert_string_for_texoutput([xyfile0,ext]);
                xyfile=[xyfile, '.tif'];
                tifdir=[p.fdir,'tif'];
                if(~isdir(tifdir))
                    mkdir(tifdir);
                    fprintf(1,'Directory %s did not exist, so it was created.\n',tifdir);
                end;
                xyfile=[p.fdir,'tif',delimiter,xyfile];
                imwrite(uint16(rgb*(2^16-1)),xyfile);
                fprintf(1,'16-bit RGB image saved as %s\n', xyfile);
            end;
            
        end;
    end;
    
end;
