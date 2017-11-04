function f=get_ini_file(action)
% return ini file, depending on the action ('r' or 'w')

% default ini-file
defini=[find_home_dir,'nanosimsini.mat'];
% alternative ini-file, used when the default does not exist, or cannot be
% read/written to
altini=[pwd,delimiter,'nanosimsini.mat'];


if(action=='r')
    f=[];
    fid=fopen(defini,'r+');
    if(fid>0)
        fclose(fid);
        f=defini;    
    else
        fid=fopen(altini,'r');
        if(fid>0)
            fclose(fid);
            f=altini;
        else
            disp('Error: nanosimsini.mat cannot be found.')
            disp('Please put it in the HOME or Look@NanoSIMS directory');
        end;
    end;
end;

if(action=='w')
    if(exist(defini)==2)
        fid=fopen(defini,'r+');
        if(fid>0)
            fclose(fid);
            f=defini;
        else
            fid=fopen(altini,'r+');
            if(fid>0)
                fclose(fid);
                f=altini;
            else
                f=[];
                disp('Error: nanosimsini.mat cannot be opened for writing.');
                disp('Please set permissions correctly.');
            end;            
        end;
    else
        f=defini;
    end;
end;
