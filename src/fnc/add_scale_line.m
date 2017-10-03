function add_scale_line(xyscale,IM,oc)

global additional_settings;

if isfield(additional_settings,'defFontSize')
    defFontSize = additional_settings.defFontSize;
else 
    defFontSize=10;
end;

if isfield(additional_settings,'scale_bar_pos')
    scale_bar_pos = additional_settings.scale_bar_pos;
else
    scale_bar_pos = 1;
end;

if isfield(additional_settings,'include_scale_text')
    include_scale_text = additional_settings.include_scale_text;
else
    include_scale_text = 1;
end;

if isfield(additional_settings,'scale_bar_length')
    sll = additional_settings.scale_bar_length;
else
    sll = 1;
end;

if scale_bar_pos>0
    
    hold on;
    
    % scaling factor to make things look nicer
    f=2.^(log2( size(IM,1) )-8);
    
    %sll=round(xyscale/10);
    %if(sll>0)
    %    slp= sll/xyscale*size(IM,2);    
    %else
    %    sll=round(2*xyscale)/10;
    %    slp=sll/xyscale*size(IM,2);
    %end;
    
    % length of the scale-bar, in pixels
    slp=sll/xyscale*size(IM,2);

    % find out the color of the scale-bar
    if length(oc)>1
        ind=find((double(oc)>=double('0') & double(oc)<=double('9')) | double(oc)==double('.'));
        ind=setdiff([1:length(oc)],ind);
        oc=oc(ind);
    end;  
    
    % determine the location of the scale-bar
    bc=25;    
%     switch scale_bar_pos
%         case 1, t_xpos = 6*f + 0*slp/2; t_ypos = f*bc; line_x = [0 slp]+6*f; line_y = 2.5*f+f*5*[1 1];
%         case 2, t_xpos = size(IM,2) - 6*f - 0*slp/2; t_ypos = f*bc; line_x = size(IM,2)-[0 slp]-6*f; line_y = 2.5*f+f*5*[1 1];
%         case 3, t_xpos = 6*f + 0*slp/2; t_ypos = size(IM,1)-f*bc; line_x = [0 slp]+6*f; line_y = size(IM,1) - f*5*[1 1] -2.5*f;
%         case 4, t_xpos = size(IM,2) - 6*f - 0*slp/2; t_ypos = size(IM,1)-f*bc; line_x = size(IM,2)-[0 slp]-6*f; line_y = size(IM,1) - f*5*[1 1]-2.5*f;
%         otherwise, t_xpos = 6*f + 0*slp/2; t_ypos = f*bc; line_x = [0 slp]+6*f; line_y = 2.5*f+f*5*[1 1];
%     end;
    
    switch scale_bar_pos
        case 1, line_x = [0 slp]+6*f; line_y = 2.5*f+f*5*[1 1];
        case 2, line_x = size(IM,2)-[0 slp]-6*f; line_y = 2.5*f+f*5*[1 1];
        case 3, line_x = [0 slp]+6*f; line_y = size(IM,1) - f*5*[1 1] -2.5*f;
        case 4, line_x = size(IM,2)-[0 slp]-6*f; line_y = size(IM,1) - f*5*[1 1]-2.5*f;
        otherwise, line_x = [0 slp]+6*f; line_y = 2.5*f+f*5*[1 1];
    end;
    
    % include the scale-bar line
    sl=plot(line_x,line_y,oc,'linewidth',3);

    switch oc(1)
        case 'w', set(sl,'Color',0.99*[1 1 1]);
        case 'k', set(sl,'Color',[0 0 0]);
        case 'r', set(sl,'Color',[1 0 0]);
        case 'g', set(sl,'Color',[0 1 0]);
        case 'b', set(sl,'Color',[0 0 1]);
        otherwise set(sl,'Color',0.99*[1 1 1]);
    end;
    
    %st=text(t_xpos,t_ypos,[num2str(sll), ' \mum'],...
    %    'FontSize',14); %,'interpreter','latex'); %, 'fontweight','bold');
    
    % include the scale text, if requested
    if include_scale_text
        
        text_xpos = mean(line_x);
        switch scale_bar_pos
            case 1, yoff = 1; va='top';
            case 2, yoff = 1; va='top';
            case 3, yoff = -1; va='bottom';
            case 4, yoff = -1; va='bottom';
        end;
        text_ypos = mean(line_y) + yoff;

        st=text(text_xpos,text_ypos,[num2str(sll), ' um'],...
            'horizontalalignment','center',...
            'verticalalignment',va,...
            'FontSize',defFontSize); %,'interpreter','latex'); %, 'fontweight','bold');
        
        switch oc(1)
            case 'w', set(st,'Color',[1 1 1]); 
            case 'k', set(st,'Color',[0 0 0]); 
            case 'r', set(st,'Color',[1 0 0]); 
            case 'g', set(st,'Color',[0 1 0]);
            case 'b', set(st,'Color',[0 0 1]); 
            otherwise set(st,'Color',[1 1 1]);
        end;

    end;
    
end;