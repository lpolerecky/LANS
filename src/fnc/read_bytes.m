function [out,h] = read_bytes(fid, location, num_bytes, ttype, reverse_bytes, b8)

fseek(fid,location,'bof');
h=fread(fid,num_bytes,ttype);

if reverse_bytes 
    % when data have been stored under Windows, the bytes are reversed
    h=h(end:-1:1);
end;

hmax = [255*ones(1,num_bytes-1) 256];

if strcmp(ttype, 'uint8')
    out=h(1);  
    maxv=hmax(1);
    for ii=2:num_bytes
        out = out*b8 + h(ii);
        maxv = maxv*b8 + hmax(ii);
    end;
    if h(1)==255
        out = out-maxv;
    end;
elseif strcmp(ttype, 'char')
    out = char(h');
else
    out = h;
end;
