function s=parseoutputtex(f)
% parse outputtex file 
% convert all eps graphics to pdf, using epstopdf (NOTE: make sure epstopdf
% is installed on your system!!!)

% open f, read line by line, and remember only lines that do not contain
% specific strings

s=[];
if(exist(f)==2)
    fid=fopen(f,'r');
    j=0;
    % findout the directory of the input file
    [pathstr,name,ext]=fileparts(f);
    while 1        
        tline=fgetl(fid);
        if ~ischar(tline), break, end;       
        %disp(['Line: ', tline]);
        ind=[findstr(tline,'document'),...
            findstr(tline,'usepackage')];;
        if(isempty(ind))
            j=j+1;
            tline2=regexprep(tline,'eps',[pathstr,delimiter,'eps']);
            indeps=findstr(tline2,'eps');
            if(~isempty(indeps))
                % extract eps filename and convert it to pdf
                indlb=findstr(tline,'{eps');
                indrb=findstr(tline,'}');
                stmp=[];
                for ii=1:length(indlb)
                    epsfile = [pathstr,delimiter,tline((indlb(ii)+1):(indrb(ii)-1))];
                    if(exist([epsfile,'.pdf'])~=2)
                         mepstopdf([epsfile,'.eps'],'epstopdf');
                    end;
                    % change \\ to / (under windows), otherwise LaTeX will complain
                    if(delimiter=='\')
                        if ii==1
                            stmp=[tline(1:indlb(1))];
                            stmp=[stmp,regexprep(epsfile,'\\','/')];
                        else
                            stmp=[stmp,tline(indrb(1):indlb(2))];          
                            stmp=[stmp,regexprep(epsfile,'\\','/')];
                        end;
                        if(ii==length(indlb))
                            stmp=[stmp,tline(indrb(ii):length(tline))];
                        end;
                        tline2=stmp;
                    end;
                end;
            end;
            s{j}=tline2;
        end;
    end;
    fclose(fid);
else
    fprintf(1,'Warning: file %s does not exist. Skipping.\n',f);
    fprintf(1,'You need to execute Output -> Generate LaTeX + PDF output to generate this file.\n');
end;

