function s = removespaces(r)
imin=min(find(r~=' '));
se = 0;
s=[];
for ii=imin:length(r)
    if(r(ii)==' ')
        se = se+1;
        if(se<2)
            s = [s r(ii)];            
        end;
    else
        s = [s r(ii)];
        se = 0;
    end;
end;
