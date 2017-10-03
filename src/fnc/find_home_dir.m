function hdir=find_home_dir
if(isunix)
    % under unix-like systems, return the home directory of the user
    w=getenv('HOME');
    hdir=[w,delimiter];
end;

if(ispc)
    % under windows-like systems, return the directory of the Look@NanoSIMS
    % program
    %hdir=[pwd(), delimiter];
    hdir = [getenv('HOMEDRIVE'), getenv('HOMEPATH'), delimiter];
end;