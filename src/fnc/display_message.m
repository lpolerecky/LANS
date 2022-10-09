function display_message(msg)
global be_verbous
if be_verbous
    ind = findstr(msg,'\');
    if ~isempty(ind)
        ind2 = find(ind<(length(msg)-1));
        ind = ind(ind2);
        msg(ind)='/';
    end
    fprintf(1,msg);
end