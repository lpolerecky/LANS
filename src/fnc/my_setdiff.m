function s3=my_setdiff(s1,s2)
% the same as setdiff, but the output is not sorted
k=0;
for ii=1:length(s1)
    if ~isempty(setdiff(s1(ii),s2))
        k=k+1;
        s3(k)=char(s1(ii));    
    end;
end;
if k==0
    s3=[];
end;
