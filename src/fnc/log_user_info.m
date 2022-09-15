function log_user_info(s)

% add info to the log string
if(isunix)
    s = [datestr(now()), ' ', getenv('USER'), ' ', s];
end
if(ispc)
    s = [datestr(now()), ' ', getenv('USERNAME'), ' ', s];
end

global LANS_version;
s=[s ' (version ',LANS_version,')'];

% log string s to the default log file
[a,b,c]=fileparts(pwd);
logdir=[a,filesep,'log'];
if(~isdir(logdir))
    mkdir(logdir);
end
logf=[logdir,delimiter,'lookatnanosims.log'];
fid=fopen(logf,'a');
if(fid>0)
    fprintf(fid,'%s\n',s);
    fclose(fid);
end
