function a=logtransform(logf,a)
if logf
    ind0=find(a<=0);
    a(ind0)=0.9*ones(size(ind0));
    a=log10(a);
end;
