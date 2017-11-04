function [mm,ms,mmed]=my_meanstdmedian(d)

ind=find(d>0);
if(~isempty(ind))
    mm=mean(d(ind));
    ms=std(d(ind));
    mmed=median(d(ind));
else
    mm=0; ms=0; mmed=0;
end;