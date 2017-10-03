function print_stacks(fig,fname,mass,printf)
if printf
    newdir = sprintf('%s%ceps',fname,filesep);
    if ~isdir(newdir)
        mkdir(newdir);
        fprintf(1,'Directory %s did not exist, so it was created.\n',newdir);
    end;
    fout=sprintf('%s%ceps%c%s-stacks.eps',fname,filesep,filesep,mass);
    global additional_settings;
    print_figure(fig,fout,additional_settings.print_factors(3));
    mepstopdf(fout,'epstopdf');
end;
