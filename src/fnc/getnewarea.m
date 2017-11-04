function [anew,nob,aold]=getnewarea(lb_old,nob_old,lb_new,nob_new)
%disp('*** This is getnewarea ***');
anew=zeros(size(lb_old));
nob=0;
j_old=find(lb_old>0);
for ii=1:nob_new
    i_new=find(lb_new==ii);    
    if(isempty(intersect(j_old,i_new)))
        nob=nob+1;
        anew(i_new)=nob*ones(size(i_new));
    end;
end;
if(nob==0)
    anew=lb_old;
end;
aold=lb_old;
aold(j_old)=nob+aold(j_old);

if 0
    figure(20);
    subplot(2,2,1);
    imagesc(lb_old); title('lb-old'); colorbar;
    subplot(2,2,2);
    imagesc(lb_new); title('lb-new'); colorbar;
    subplot(2,2,3);
    imagesc(anew); title('anew'); colorbar;
    subplot(2,2,4);
    imagesc(aold); title('aold'); colorbar;
    input('press enter');
end;

    
    