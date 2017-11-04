function [sdm , gnamess, ranking, minmaxband] = get_sdm(m,m95,sem,c,gnames)
% calculate the comparison matrix, cell ranking, number of significant
% ranks, and boundaries of the significant ranks

% sort means, halfwidths and names of the classes
[ms,ind2]=sort(m,'descend');
m95s=m95(ind2,:);
sems=sem(ind2);
gnamess=gnames(ind2);

N=length(ms);
sdm=zeros(N,N);
ind=ind2;
c1=c(:,1); c2=c(:,2);
% if the estimate of the difference between the means does not contain 0 
% (sign of significant difference between means), the boundaries of the 
% interval should have the same sign.
for ii=1:N
    for jj=(ii+1):N 
        inds=sort([ind(ii) ind(jj)]);
        kk=find(c1==inds(1) & c2==inds(2));
        if(c(kk,3)*c(kk,5)>0)
            %fprintf(1,'Comparing [%d %d]: %d and %d (%d,%d) (k=%d)\n',ii,jj,inds,ccc(kk,1:2),kk)
            % this means that the difference in estimated mean values is
            % significant, so fill the output matrix with the
            % estimated difference in means
            sdm(ii,jj)=abs(c(kk,4));
            sdm(jj,ii)=abs(c(kk,4));
        end;
    end;
end;

% find ranking of the sorted values
jj=0;
rank1=zeros(1,N);
ii=2;
oldindr=[1];
rank1(1)=1;
for ii=2:size(sdm,1) 
    r=sdm(ii,1:(ii-1));
    indr = find(r>0);
    if(~isempty(indr))
        rank1(ii)=max(rank1(indr))+1;
        jj=max(rank1);
    else
        rank1(ii)=1;
    end;
end;
nsr=length(unique(rank1));

b=zeros(size(sdm));
a=find(sdm==0);
b(a)=ones(size(a));
minmaxrank=zeros(N,2);
% the highest class is always ranked as [1 1]
minmaxrank(1,:)=[1 1];
for ii=2:N
    r=b(ii,:);
    indr=find(r==1);
    minmaxrank(ii,1)=rank1(ii);
    ind1=indr;
    if(~isempty(ind1))
        minmaxrank(ii,2)=max(rank1(ind1));
    else
        minmaxrank(ii,2)=rank1(ii);
    end;
end;

ranking = [ms m95s sems minmaxrank];

% determine bands of the ranks; they can be used for plotting
rk=unique(rank1);
for ii=1:length(rk)
    ind1=find(minmaxrank(:,1)==rk(ii) & minmaxrank(:,2)==rk(ii));
    % rank boundaries are determined by the 95% confidence of the means
    % from all cells within the given rank
    minband=min(m95s(ind1,1));
    maxband=max(m95s(ind1,2));
    minmaxband(ii,1:3) = [rk(ii) minband maxband];
end;



