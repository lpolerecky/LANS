function add_image_title(axid,title_,ratio_,fac,imsize, show_title, log_flag)

global additional_settings;

orig_ratio_ = ratio_;
orig_title_ = title_;
tmargin=2;
    
ratio = reformat_ratio_string(ratio_);

if strcmp(ratio_,'cells')
    ratio = 'ROIs';
    orig_ratio_ = ratio;
else
    if fac~=1
        ratio = sprintf('%s \\times 10^{%d}',ratio,log10(fac));
    end
    if log_flag
        ratio = ['log(', ratio, ')'];
        orig_ratio_ = ['log(', orig_ratio_, ')'];
    end
end

%% add/remove mass/ratio expression
st = findobj('Tag',sprintf('expr_fig%d',get(get(axid,'Parent'),'Number')) );
if additional_settings.title_position>0
    % make the ratio a latex math expression
    ratio = ['$\mathbf{' ratio '}$'];
    
    switch additional_settings.title_position
        case 1, ha='left'; va='top'; xpos = tmargin; ypos = tmargin;
        case 2, ha='right'; va='top'; xpos = imsize(2)-tmargin; ypos = tmargin;
        case 3, ha='left'; va='bottom'; xpos = tmargin; ypos = imsize(1)-tmargin;
        case 4, ha='right'; va='bottom'; xpos = imsize(2)-tmargin; ypos = imsize(1)-tmargin;
        otherwise, ha='center'; va='bottom'; xpos=imsize(2)/2; ypos=0;
    end

    if additional_settings.fill_title_background
        tbc = additional_settings.title_background_color;
    else
        tbc = 'none';
    end

    % find title font color and size
    tfsc = additional_settings.title_font_size_color;
    
    ind=find( double(tfsc)>=double('0') & double(tfsc)<=double('9') );
    if ~isempty(ind)
        tfs = str2num( tfsc(ind) );
    else
        tfs = 14;
    end
   
    ind = setdiff( [1:length(tfsc)], ind);
    if ~isempty(ind)
        tfc = tfsc(ind(1));
    else
        tfc = 'k';
    end
    
    if isempty(st)
        st=text(xpos,ypos,ratio,...
            'horizontalalignment',ha,'verticalalignment',va,...
            'color',tfc,'BackgroundColor',tbc,'Margin',tmargin,...
            'FontSize',tfs,'interpreter','latex', ...
            'Tag',sprintf('expr_fig%d',get(get(axid,'Parent'),'Number')) );
    else
        set(st,'Position',[xpos ypos 0], 'string',ratio, ...
            'horizontalalignment',ha,'verticalalignment',va,...
            'color',tfc,'BackgroundColor',tbc,'Margin',tmargin,...
            'FontSize',tfs,'interpreter','latex');
    end
else
    if ~isempty(st)
        delete(st);
    end
end
    
if additional_settings.title_position==0
    % combine the title_ and ratio_ strings and display the resulting
    % string above the image   
    title_ = [title_ ': ' orig_ratio_];
end

%% add/remove title
oid = findobj('Tag',sprintf('title_fig%d',get(get(axid,'Parent'),'Number')) );
if show_title
    
    if ~strcmp(orig_title_,' ')
        % trim the title so that it's not too long
        if(length(title_)>additional_settings.title_length)
            title_=['...',title_([(length(title_)-additional_settings.title_length):length(title_)])];
        end
        if isempty(oid)
            tith = title(axid,title_,'interpreter','none','fontweight','normal',...
                'FontSize',additional_settings.defFontSize,...
                'color','k','BackgroundColor','none','HandleVisibility','on');
            set(tith, 'Tag', sprintf('title_fig%d',get(get(axid,'Parent'),'Number')));
        else
            set(oid,'string', title_);
        end
    else
        if isempty(oid)
            tith = title(axid, orig_ratio_,'interpreter','none','fontweight','normal',...
                'FontSize',additional_settings.defFontSize,...
                'color','k','BackgroundColor','none','HandleVisibility','on');
            set(tith, 'Tag', sprintf('title_fig%d',get(get(axid,'Parent'),'Number')));
        else
            set(oid, 'string', orig_ratio_);
        end
    end
else    
    if ~isempty(oid)
        delete(oid);
    end
end

    