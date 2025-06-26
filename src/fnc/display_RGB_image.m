function [rgb7_fname, rgb8_fname] = display_RGB_image(rgb7, rgb8, p, opt1, tit, xl, yl, zl, cw)
% display the rgb image, with some simple formating, and export it as eps
% and 16-bit tif

rgb7_fname=[];
rgb8_fname=[];

global additional_settings;


if ~isempty(rgb7) || ~isempty(rgb8)

    for ii=1:2
        if ii==1
            rgb=rgb7;
            plotopt=opt1(7);
        else
            rgb=rgb8;
            plotopt=opt1(8);
        end
        
        if plotopt
            
            % the same code as in plotImageCells.m to place the figure
            mf=figure(35+ii);
            set(mf,'ToolBar','none','MenuBar','none','Name','RGB');
            ax=subplot(1,1,1);
            hold off;
            if isempty(get(mf,'children'))
                FigPos=get(0,'DefaultFigurePosition');
                FigPos(3:4)=1.2*FigPos(4)*[1 1];
                ScreenUnits=get(0,'Units');
                set(0,'Units','pixels');
                ScreenSize=get(0,'ScreenSize');
                set(0,'Units',ScreenUnits);
                FigPos(1)=1/2*(ScreenSize(3)-FigPos(3));
                FigPos(2)=2/3*(ScreenSize(4)-FigPos(4));
                fpos=FigPos;
                set(mf,'Units','pixels');
                set(mf,'Position',fpos);
                set(mf,'ToolBar','none','MenuBar','none','Name','RGB');
            else
                fpos = get(mf,'Position');
            end

            % display the image
            imagesc(rgb);
            
            % modify the axis properties to look the same as mass/ratio
            % images
            set(ax,'DataAspectRatio',[1 1 1],'xtick',[],'ytick',[],...
                'Visible','off');            
            sfac=size(rgb7,1)/size(rgb7,2);
            if sfac<=1
                set(ax,'Position',[0.1 0.06+0.5*0.9*(1-sfac) 0.8 0.9*sfac]);
            else
                set(ax,'Position',[0.1+0.5*0.8*(1-1/sfac) 0.11 0.8/sfac 0.8]);
            end
                
            % include title and xlabel, if requested
            if opt1(15)
                      
                % too difficult to make it general, idea abandoned
                if 0
                rlab = reformat_ratio_string(xl,additional_settings.defFontSize);
                glab = reformat_ratio_string(yl,additional_settings.defFontSize);
                blab = reformat_ratio_string(zl,additional_settings.defFontSize);
                xlab = ['\fontsize{' num2str(additional_settings.defFontSize),'}', ...
                    '\color{red}',rlab,' \color{green}',glab,' \color{blue}' blab];
                else
                    xlab = ['\fontsize{' num2str(additional_settings.defFontSize),'}', ...
                        '\color{red}',xl,' \color{green}',yl,' \color{blue}' zl];
                end
                
                title(xlab,'interpreter','tex');
                
                if ~isempty(tit)
                    % trim the title so that it's not too long
                    if length(tit)>additional_settings.title_length
                        tit=['...',tit([(length(tit)-additional_settings.title_length):length(tit)])];
                    end
                    xlabel(tit,'FontSize',additional_settings.defFontSize,'interpreter','none');
                    %text(0,size(rgb7,1)+3*size(rgb7,1)/128,tit,...
                    %    'horizontalalignment','left','verticalalignment','top',...
                    %    'color','k','BackgroundColor','none','Margin',2*size(rgb7,1)/128,...
                    %    'FontSize',additional_settings.defFontSize,'interpreter','none');   
                end
                
            end
            
            % add scale line
            if isempty(cw)
                cw = 'w';
            end
            add_scale_line(p.scale,rgb7(:,:,1),cw);
            
            % add cell outline
            if(opt1(1))
                %hold on;
                addCellOutline(ax,p.Maskimg,cw);
            end
                        
            % export RGB image (as eps and tif)
            if(opt1(11))                
                if(~isempty(xl) && ~isempty(yl) && ~isempty(zl))
                    xyfile0=[xl,'-vs-',yl,'-vs-',zl];
                else
                    if(isempty(xl))
                        xyfile0=[yl,'-vs-',zl];
                    end
                    if(isempty(yl))
                        xyfile0=[xl,'-vs-',zl];
                    end
                    if(isempty(zl))
                        xyfile0=[xl,'-vs-',yl];
                    end
                end
                if(ii==1)
                    ext='-rgb';
                    ext_cmyk = '-cmyk';
                else
                    ext='-rgba';
                    ext_cmyk = '-cmyka';
                end              
                xyfile=convert_string_for_texoutput([xyfile0,ext]);
                xyfile=[xyfile,'.eps'];
                xyfile=[p.fdir,'eps',delimiter,xyfile];
                epsdir = fileparts(xyfile);
                if(~isfolder(epsdir))
                    mkdir(epsdir);
                    fprintf(1,'Directory %s did not exist, so it was created.\n',epsdir);
                end
                print_figure(mf,xyfile,additional_settings.print_factors(1));
                outfname = mepstopdf(xyfile,'epstopdf');
                outfname = regexprep(outfname,'\','/');
                if ii==1
                    rgb7_fname = outfname;
                else
                    rgb8_fname = outfname;                    
                end
                xyfile=convert_string_for_texoutput([xyfile0,ext]);
                xyfile=[xyfile, '.tif'];
                xyfile_cmyk=convert_string_for_texoutput([xyfile0,ext_cmyk]);
                xyfile_cmyk=[xyfile_cmyk, '.tif'];
                tifdir=[p.fdir, 'tif'];
                if(~isfolder(tifdir))
                    mkdir(tifdir);
                    fprintf(1,'Directory %s did not exist, so it was created.\n',tifdir);
                end
                xyfile=[p.fdir,'tif',delimiter,xyfile];
                xyfile_cmyk=[p.fdir,'tif',delimiter,xyfile_cmyk];
                Nbits = 8;
                if Nbits==16
                    imwrite(uint16(rgb*(2^Nbits-1)),xyfile);
                elseif Nbits==8
                    imwrite(uint8(rgb*(2^Nbits-1)),xyfile);
                end
                fprintf(1,'%d-bit RGB image saved as %s\n', Nbits, xyfile);
                % also save the image as CMYK
                outprof = iccread('USSheetfedCoated.icc'); 
                inprof = iccread('sRGB.icm');
                C = makecform('icc',inprof,outprof);   
                rgb(isnan(rgb(:)))=0; % set NaN to 0
                cmyk = applycform(rgb, C);
                imwrite(cmyk, xyfile_cmyk);
                %a = 0;
            end
            
        end
    end
    
end
