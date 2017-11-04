function [x,y,z]=make_data_correction(x,y,z,k,j)
% HACK for Jana (correct for Au background)
if 0
    disp(['Warning: making off-set correction for y{2}(:,1)']);
    aumean=mean(x{2}(:,1));
else
    aumean=0;
end;
% HACK for Jana (correct for incubation times)
if(0 & j>=5 & j<=10)
    cnatabund=0.0106;
    cfac=28/44;
else
    cnatabund=0.0106;
    cfac=1;
end;            
if(~isempty(x{k}))
    % specify which variable should be corrected
    vcor='x';
    s=[vcor,'{k}(:,1)=',vcor,'{k}(:,1)-aumean;'];
    eval(s);
    s=[vcor,'{k}(:,1)=(',vcor,'{k}(:,1)-cnatabund)*cfac+cnatabund;'];
    eval(s);
    vcor='z';
    s=[vcor,'{k}(:,1)=sqrt(',vcor,'{k}(:,1));'];
    %eval(s);
end;
