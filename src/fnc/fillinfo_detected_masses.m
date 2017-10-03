function fillinfo_detected_masses(handles, im, imfile)

if ~isempty(im)
    
    %set(handles.edit2,'String',imfile);
    set(handles.edit2,'String',im.filename);    
    sc=[]; indsc=[];
    he(1) = handles.edit3;
    hs(1) = handles.edit33;
    hi{1} = handles.edit12;
    cb(1) = handles.checkbox25;
    he(2) = handles.edit4;
    hs(2) = handles.edit34;
    hi{2} = handles.edit13;
    cb(2) = handles.checkbox26;
    he(3) = handles.edit5;
    hs(3) = handles.edit35;
    hi{3} = handles.edit14;
    cb(3) = handles.checkbox27;
    he(4) = handles.edit6;
    hs(4) = handles.edit36;
    hi{4} = handles.edit15;
    cb(4) = handles.checkbox28;
    he(5) = handles.edit7;
    hs(5) = handles.edit37;
    hi{5} = handles.edit16;
    cb(5) = handles.checkbox29;
    he(6) = handles.edit8;
    hs(6) = handles.edit38;
    hi{6} = handles.edit17;
    cb(6) = handles.checkbox30;
    he(7) = handles.edit9;
    hs(7) = handles.edit39;
    hi{7} = handles.edit18;
    cb(7) = handles.checkbox31;
    he(8) = handles.edit74;
    hs(8) = handles.edit76;
    hi{8} = handles.edit75;
    cb(8) = handles.checkbox70;
    
    % find out the previous scale for each new mass
    indsc = [0 0 0 0 0 0 0 0];
    sc={'[0 1]', '[0 1]', '[0 1]', '[0 1]', '[0 1]','[0 1]','[0 1]','[0 1]'};
    for ii=1:length(cb)
        if(ii<=length(im.mass))
            tmps1=im.mass{ii};
            for jj=1:length(cb)
                tmps2=get(he(jj),'string'); 
                % treat Esi and m0 as equivalent
                if(strcmpi(tmps1,'Esi') | strcmpi(tmps1,'m0'))
                    if(strcmpi(tmps2,'Esi') | strcmpi(tmps2,'m0'))
                        scmpi=1;
                    else
                        scmpi=0;
                    end;
                else
                    scmpi=strcmpi(tmps1,tmps2);                
                end;
                if(scmpi)
                    indsc(ii) = jj;
                    sc{ii} = get(hs(jj),'string');
                    break;
                end;
            end;
        else
            indsc(ii) = 0;
            sc{ii} = '[0 1]';
        end;
    end;
    
    % fill out the masses and corresponding scales
    % also fill the 'images' field to [] by default, which means that all
    % planes will be used for averaging
    for ii=1:length(cb)
        if(ii<=length(im.mass))
            if(indsc(ii)>0)
                set(he(ii),'string', im.mass{ii});
                set(hs(ii),'string', sc{ii});
            else
                set(he(ii),'string',im.mass{ii});
                set(hs(ii),'string','[0 1]');
            end;
            set(hi{ii},'string','[]');
            set(cb(ii),'value',1);
        else
            set(he(ii),'string','');
            set(hs(ii),'string','[0 1]');
            set(hi{ii},'string','[]');
            set(cb(ii),'value',0);
        end;
    end;
    
end;
