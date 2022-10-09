function export_data_from_input_files(varnames, foutname, t1, t2)

%% generate format with which the data will be exported 
fmt=sprintf('#id\tfile\ttreatment\troi_class\troi_id\tsize\tpixels\tl2w\txpos\typos');
fmt1='%d\t%s\t%d\t%c\t%d\t%.3f\t%d\t%.2f\t%.2f\t%.2f';
fmt2=[];
for j=1:length(varnames{1})
    fmt=[fmt sprintf('\t%s\tSE',varnames{1}{j})];
    fmt2=[fmt2 '\t%.4e\t%.4e'];
end
fmt2=[fmt2,'\n'];

% filename of the final output
fn = [foutname,'.dac'];  

fprintf(1,'\nExporting data to %s ... \n',fn); 
fid=fopen(fn,'w');
%fid=1;

%% export data
fprintf(fid,'%s\n',fmt);
for ii=1:size(t2,1)
    fprintf(fid,fmt1, t1.id(ii), t1.file{ii}, t1.treatment(ii), t1.roi_class(ii), t1.roi_id(ii), t1.size(ii),...
        t1.pixels(ii), t1.l2w(ii), t1.xpos(ii), t1.ypos(ii));
    fprintf(fid,fmt2, table2array(t2(ii,:)));
end
fclose(fid);
fprintf(1,'Done.\n');       
