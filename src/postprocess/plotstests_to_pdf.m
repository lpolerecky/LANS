function plotstests_to_pdf(s)
% generate LaTeX file with all plots and test results included
% (c) Lubos Polerecky, 05.07.2011, MPI Bremen

% the output filename will have the same base-name as the metafile
if(~isempty(s.metafile))
    [fdir, fn, fext] = fileparts(s.metafile);
    foutname = [fdir, delimiter, fn, delimiter, fn, '-plots-tests.tex'];
    gdir = [fdir delimiter fn delimiter 'pdf'];
else
    foutname = [];
end;

if(~isempty(foutname))

    % generate the PDF-LaTeX file
    fn = foutname;
    fid=fopen(fn,'w');
    fprintf(fid,'\\documentclass[12pt,a4paper]{article}\n','');
    fprintf(fid,'\\usepackage{graphicx}\n','');
    fprintf(fid,'\\usepackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}\n','');
    fprintf(fid,'\\usepackage[bookmarksopen=false,pdfauthor=Look@NanoSIMS,pdftitle=%s]{hyperref}\n',...
        regexprep(s.metafile,'\','/'));
    fprintf(fid,'\\begin{document}\n','');
    fprintf(fid,'\\def\\bdir{%s}\n',regexprep(gdir,'\','/'));
    fprintf(fid,'\\begin{center}\n\n');
    
    % add 2d graphs
    f = dir([gdir delimiter '*2d*.pdf']);
    include_graphs(f,fid);
    
    % add 3d graphs
    f = dir([gdir delimiter '*3d*.pdf']);
    include_graphs(f,fid);
       
    % add Levene's tests graphs
    f = dir([gdir delimiter '*-lev-*.pdf']);
    include_graphs(f,fid);
    
    % add ANOVA tests graphs
    f = dir([gdir delimiter '*-anova-*.pdf']);
    include_graphs(f,fid);
    
    % add Kruskal-Wallis tests graphs
    f = dir([gdir delimiter '*-kw-*.pdf']);
    include_graphs(f,fid);
    
    % add any other graph in the directory, but not *2d*, *3d*, *lev*,
    % *anova* and *kw*.
    f = dir([gdir delimiter '*.pdf']);
    f2=[];
    k=0;
    for ii=1:length(f)
        if isempty([strfind(f(ii).name,'2d') strfind(f(ii).name,'3d') ...
                strfind(f(ii).name,'lev') strfind(f(ii).name,'anova') strfind(f(ii).name,'kw')])
            k=k+1;
            f2(k).name=f(ii).name;
            f2(k).date=f(ii).date;
            f2(k).bytes=f(ii).bytes;
            f2(k).isdir=f(ii).isdir;
            f2(k).datenum=f(ii).datenum;
        end;
    end;
    if ~isempty(f2)
        include_graphs(f2,fid);
    end;        
    
    fprintf(fid,'\n\\end{center}\n\\end{document}');
    fclose(fid);
    fprintf(1,'*** Output written to %s\n',fn);
    
    mepstopdf(fn,'pdflatex',0);
    mepstopdf(fn,'pdflatex',1);
    %disp('You can use pdflatex to generate a PDF file from it');
end;

function include_graphs(f,fid)
k=0;
N=length(f);
if N>0
    fprintf(fid,'\\begin{tabular}{cc}\n');
    for ii=1:N
        if ~f(ii).isdir
            a = f(ii).name;
            [b a] = fileparts(a);
            fprintf(fid,'\\includegraphics[width=0.42\\textwidth]{\\bdir/%s}\n',a);
            k=k+1;
            if mod(k,2)==1
                fprintf(fid,'&\n');
                end_printed = 0;
            else
                fprintf(fid,'\\end{tabular}\n');
                if ii<N
                    fprintf(fid,'\\begin{tabular}{cc}\n');
                end;
                end_printed = 1;
            end;
        end;
    end;
    if ~end_printed
        fprintf(fid,'\\end{tabular}\n');
    end;
end;
