function [planes,ratios,cellnum,cellclass]=getratioprofiles(ct,fn,fncells,q,verbose)
% get profile data from the file fn according to the cell definition 
% in fncells for all cell types specified in ct

% default output
planes=[];
ratios=[];
cellnum=[];
cellclass=[];

if(~isempty(q))
    
    [pathstr, name, ext] = fileparts(fn);
    % test both uppercase and lower case filename 
    fn1=[pathstr,delimiter,name,ext];
    fn2=[pathstr,delimiter,lower(name),ext];

    if(exist(fn1)==2)
        fn=fn1;
    else
        if(exist(fn2)==2)
            fn=fn2;
        else
            fn=[];
        end;
    end;

    if(~isempty(fn) & exist(fn)==2)
        
        [planes,ratios]=readdatprofile(fn,1,verbose);

        if exist(fncells)==2
            % load the cell classification file 
            if(verbose), disp(['Processing file ',fncells]); end;
            fid=fopen(fncells,'r');
            A = fscanf(fid,'%d %c',[2,inf]);
            cellnum=A(1,:);
            cellclass=char(A(2,:));
            fclose(fid);
        else
            % cells are not classified, so treat all cells as class "a"
            disp(['** File ',fncells,' not found. All cells treated equal (class "a").']);
            cellnum = [1:length(planes)];
            cellclass = char('a'*ones(1,length(planes)));
        end;
        
    else
      disp(['File ',fn1,' missing. Returning empty output.']);
    end;

end;