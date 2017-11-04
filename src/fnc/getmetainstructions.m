function [id,fname,tmnt,ct,xyz,nf,all,plot3d,basedir,image_range]=getmetainstructions(fn, all_cell_types, plot3d)
% read the meta-file and figure out the instructions

fid = fopen(fn,'r');
j=0;
id=[]; fname=[]; tmnt=[]; ct=[]; xyz=[]; basedir=[]; image_range=[];

while 1
	tline = fgetl(fid);
	if ~ischar(tline) | isempty(tline), break, end;
	if tline(1)=='#' 
        if j==0
            % this is the first line, which contains the basedir
            ind=findstr(tline,' ');
            if length(ind)==1
                basedir = tline(ind+1:end);
                fprintf(1,'Base directory: %s\n',basedir);
            end;
        end;
    else
        if length(tline)>3 
            j=j+1;
            disp(['Processing line ',tline]);
            [a1,a2,a3,a4,a5,a6,a7] = getmetadata(tline,all_cell_types);
            %plot3d = (plot3d & ~isempty(a7));
            id{j}=a1;
            fname{j}=a2;
            tmnt{j}=a3;
            ct{j}=a4;
            xyz{j}=a5;
            all{j}=a6;
            image_range{j}=a7;
        end;
	end;
end;
fclose(fid);
nf=j;
