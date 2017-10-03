function s=my_get(h,p)
% return property p of handle h, if h is handle, or the field p
% if h has the p field, otherwise return ''
s='';
if(ishandle(h))
    s = get(h,p);
end;
if(isfield(h,p))
    s=eval(['h.',p]);
end;
