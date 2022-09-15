function [rat rat_m]=read_statc(fname, ratios)

global verbose
if verbose 
    fprintf('Processing file %s\n', fname);
end

fid=fopen(fname,'r');

tline=fgetl(fid);
rat_id=0;
k=1;

while isempty(strfind(tline,'Cumulated results'))
    if ~isempty(tline)
        %disp(tline);
        A = sscanf(tline,'%d %s %e %e %d %e %e %e');
        rat_id = rat_id+1;
        rat(k, rat_id) = A(5);
        if rat_id==length(ratios), rat_id = 0; k=k+1; end;
    end
    tline=fgetl(fid);
end

while isempty(strfind(tline,'Ratio#'))
    tline=fgetl(fid);
end

tline=fgetl(fid);

for i=1:length(ratios) 
    tline=fgetl(fid); 
    A = sscanf(tline,'%s %e %e %e %e %e'); 
    rat_m(i) = A(4);
end

fclose(fid);
