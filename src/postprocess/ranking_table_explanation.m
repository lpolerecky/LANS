function ranking_table_explanation(fid,stats,object,f)

if strcmp(object,'ROI') | strcmp(object,'treatment')
    objects = [object 's'];
else
    objects = [object 'es'];
end;

if f(1)
    fprintf(fid,'\nRANKING TABLE EXPLANATION:\n');
    fprintf(fid,'* MEAN(95%c) - (lower upper) limits of the 95%c confidence interval of the MEAN\n','%','%');
    fprintf(fid,'* SEM - standard error of the MEAN\n');
    fprintf(fid,'* Rmin/Rmax - minimum/maximum rank of the %s\n',object);
    fprintf(fid,'  %s values for %s with the same ranking DO NOT significantly differ,\n',stats,objects);
    fprintf(fid,'  whereas %s values for %s with different ranking DO significantly differ.\n',stats,objects);
    fprintf(fid,'  If, for a given %s, Rmin is not equal Rmax, its %s does not significantly\n',object,stats);
    fprintf(fid,'  differ from that of %s with ranking Rmin and Rmax.\n', object);
end;
if f(2)
    fprintf(fid,'\nRANKING GRAPH EXPLANATION:\n');
    fprintf(fid,'* Square symbols show the MEAN, error-bars show the 95%c confidence interval of the MEAN\n','%');
    fprintf(fid,'  crosses show the boundaries of the standard error or the MEAN.\n');
    fprintf(fid,'* Colored patches indicate boundaries of the %s ranks,\n',object);
    fprintf(fid,'  as derived from multiple comparison analysis of %ss.\n\n',stats);
end;