function fn=getid(id,max_dig,fill_0_flag)
% Usage: fn=getid(id,max_dig,fill_0_flag)
%
% If FILL_0_FLAG==1, function returns a string of length MAX_DIG 
% corresponding to ID. The string is created in such a way that 
% any empty digits at the begining of the string are substituted 
% by zeros.
%
% If FILL_0_FLAG~=1, function returns a strings corresponding to
% ID with no additional zeros.
%
% If FILL_0_FLAG is missing int he input argument, FILL_0_FLAG=1
% is considered.
%
% (c) Lubos Polerecky, 28.4.2002, MPI Bremen

fn = num2str(id);
if(nargin<3)
    disp('here');
    fill_0_flag = 1;
end;

if(fill_0_flag)
    noz = max_dig - length(fn);
    if(noz>=0)
        fn = [ones(1,noz)*'0',fn];
    else
        disp('GETID warning: Max number of digits is lower than the actual number of digits in ID.');
    end;
end;
