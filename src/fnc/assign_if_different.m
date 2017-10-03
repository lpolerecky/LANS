function out = assign_if_different(p_im, p, fld);

out = getfield(p,fld);
if isfield(p_im,fld)
    a = getfield(p,fld);
    b = getfield(p_im,fld);
    if isstruct(a)
        af = fieldnames(a);
        N=length(af);        
        for ii=1:N
            if getfield(a,af{ii}) ~= getfield(b,af{ii})
                setfield(b,af{ii}, getfield(a,af{ii}));
            end;
        end;
        out = b;
    else
        if getfield(p_im,fld) ~= getfield(p,fld)
            out= getfield(p_im,fld);
        end;
    end;
end;

