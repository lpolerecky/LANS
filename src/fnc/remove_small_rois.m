function L2=remove_small_rois(L,thr)
uL = setdiff(unique(L(:)),0);
L2 = zeros(size(L));
jj=1;
for ii=1:length(uL)
    ind = find(L==uL(ii));
    if length(ind)>thr
        L2(ind) = jj*ones(size(ind));
        jj=jj+1;
    end;
end;
