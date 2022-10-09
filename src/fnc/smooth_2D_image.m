function im2 = smooth_2D_image(im1,mk1,mk2)

% im2 = wiener2(im1,mk1, mk2);
% im2 = gaussfilt_external(im1,mk1,mk2);
allowed_mk = [1:2:15];
if sum(ismember(allowed_mk,mk1))==0
    fprintf(1,'Kernel size %d is not allowed. Allowed values:\n',mk1);
    fprintf(1,'%d ',allowed_mk);
    fprintf(1,'\n');
    
    d = allowed_mk - mk1;
    ind0 = find(d>=0);
    if ~isempty(ind0)
        ind = find(d==min(d(ind0)));
    else
        ind = 1;
    end;
    mk1 = allowed_mk(ind);
    fprintf(1,'Kernel size changed to %d\n',mk1);
end;
if mk1>1
    im2 = sg_smoothimage(im1,mk1);
else
    im2 = im1;
end;
