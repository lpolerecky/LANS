function [d,cellid,area,pixels,xpos,ypos,l2w, cls]=getratiodata(ct,fn,fncells,q,verbose)
% get data from the file fn according to the cell definition 
% in fncells for all cell types specified in ct

% test both uppercase and lower case filenames


if(~isempty(q))
    
    [pathstr, name, ext] = fileparts(fn);
    fn1=[pathstr,delimiter,name,ext];
    fn2=[pathstr,delimiter,lower(name),ext];

    % if the '*.dac' file is requested and it does not exist, load the data
    % from the '*.dat' file (this is usually the case when one wants to plot
    % pure mass, i.e., not a ratio image)

    if(exist(fn1)==2)
        fn=fn1;
    else
        if(exist(fn2)==2)
            fn=fn2;
        else
            fn=[];
        end
    end

    if(~isempty(fn) && exist(fn)==2)
        [~,r]=readdacfile(fn,1,verbose);

        if (exist(fncells,'file')==2)
            % parse the fncells file and gather data according to the cell
            % types
            if(verbose), disp(['Processing file ',fncells]); end
            fid=fopen(fncells,'r');
            A = fscanf(fid,'%d %c',[2,inf]);
            cnum=A(1,:)';
            cid=char(A(2,:)');
            fclose(fid);
            % if specific classes are empty, load data for all classes
            if isempty(ct)
                ct = unique(cid);
            end
            for ii=1:length(ct)
                ind=find(cid==ct(ii));
                if(~isempty(ind) && size(r,1)==length(cnum))
                   d{ii}=r(cnum(ind),4:5);
                   cellid{ii}=r(cnum(ind),1);
                   area{ii}=[r(cnum(ind),7) zeros(length(ind),1)];
                   pixels{ii}=[r(cnum(ind),8) zeros(length(ind),1)];
                   xpos{ii}=[r(cnum(ind),2) zeros(length(ind),1)];
                   ypos{ii}=[r(cnum(ind),3) zeros(length(ind),1)];
                   l2w{ii}=[r(cnum(ind),9:10)];
                   %dl2w{ii}=[r(cnum(ind),10) zeros(length(ind),1)];
                   cls{ii}=ct(ii)*ones(length(ind),1);
                else
                    if ii==1 && size(r,1)~=length(cnum)
                        fprintf(1,'ERROR: Lengths inconsistent for files:\n');
                        fprintf(1,'  %s\n  %s\n',fn,fncells);
                        fprintf(1,'Please reexport the ASCII data or redefine classes for the corresponding dataset.\n');
                    end
                    d{ii}=[];
                    cellid{ii}=[];
                    area{ii}=[];
                    pixels{ii}=[];
                    xpos{ii}=[];
                    ypos{ii}=[];
                    l2w{ii}=[];
                    %dl2w{ii}=[];
                    cls{ii}=[];                   
                end
            end
            % issue warning of the output is empty (e.g. when none of the
            % cell classes defined in the Color scheme were found in the
            % classification file)
            is_empty=1;
            for ii=1:length(d)
                is_empty = is_empty & isempty(d{ii});
            end
            if is_empty
                fprintf(1,'*** Warning: Returning empty output.\n');
                fprintf(1,'Possible reason: None of the cell classes defined in the "Color scheme" found in the classification file.\n');
                fprintf(1,'Cell classes defined in the "Color scheme": %s\n',ct);
                fprintf(1,'Cell classes defined in the classification file: %s\n',unique(cid));
            end
                
        else
            % cells are not defined, so take data for all cells
            disp(['** Classification file ',fncells,' not found. All cells treated as equal (class "a").']);
            ii=1; d=[];
            d{ii} = r(:,4:5);
            cellid{ii}=r(:,1);
            area{ii}=[r(:,7) zeros(size(r,1),1)];
            pixels{ii}=[r(:,8) zeros(size(r,1),1)];
            xpos{ii}=[r(:,2) zeros(size(r,1),1)];
            ypos{ii}=[r(:,3) zeros(size(r,1),1)];
            l2w{ii}=[r(:,9:10)];
            %dl2w{ii}=[r(:,10) zeros(size(r,1),1)];
            cls{ii}='a'*ones(length(cellid{ii}),1);
            
        end
    else
      disp(['File ',fn1,' missing. Returning empty output.']);
      d=[];
      cellid=[];
      area=[];
      pixels=[];
      xpos=[];
      ypos=[];
      l2w=[];
      %dl2w=[];
    end
else
    d=[];
    cellid=[];
    area=[];
    pixels=[];
    xpos=[];
    ypos=[];
    l2w=[];
    %dl2w=[];
end