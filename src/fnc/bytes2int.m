function out = bytes2int(h,reverse_bytes, b8)
if reverse_bytes 
    % when data have been stored under Windows, the bytes are reversed
    h=h(end:-1:1);
end;

out=((h(1)*b8+h(2))*b8+h(3))*b8+h(4);