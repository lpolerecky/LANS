function f=exportImageCells(f,title_,mass_,ext,print_factor)
%disp('*** This is exportImageCells ***');
title_=fixdir(title_);
if(~isempty(ext))
    
    t1=now;
    
    if(~isdir(title_))
        s=sprintf('Directory %s did not exist, so it was created.',title_);
        mkdir(title_);
        disp(s);
    end;
    
    % generate the output filename and export
    a=convert_string_for_texoutput(mass_);
    
    figdir=[title_,ext];
    if(~isdir(figdir))
        mkdir(figdir);
        fprintf(1,'Directory %s did not exist, so it was created.\n',figdir);
    end;
    
    % print as eps or png
    out = [title_,ext,delimiter,a,'.',ext];
    %fprintf(1,'Figure exported as %s\n',out);
    if(strcmp(ext,'eps'))
        print_figure(f,out,print_factor);
        mepstopdf(out,'epstopdf');
    end;
    
    t2=now;
    %fprintf(1,'Printing of the figure took %.3fs\n',(t2-t1)*24*3600);
    
end;
