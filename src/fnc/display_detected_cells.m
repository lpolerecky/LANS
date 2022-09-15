function display_detected_cells(handles)

[opt1,opt3,opt4]=load_options(handles,0);

global additional_settings;
global CELLSFILE;

p=handles.p;

if(isempty(my_get(handles.edit63,'string')))
    tit=fixdir(p.fdir);
else
    tit = my_get(handles.edit63,'string');
end;

% when exporting cells, outlines are always plotted, and image is always
% displayed
opt1(1)=1;
opt1(6)=1;

% also the dat/cells.dat and eps/cells.eps are always exported, because it may happen that the
% user forgets to check the Export DAT/EPS checkboxes, which would leave the info needed
% during metafile postprocessing and graphical export missing
opt1(10)=1;
opt1(11)=1;

% set default cell outline color to 'w', if not defined
if(~isfield(handles,'edit62'))
    outlinec='w';
else
    outlinec=my_get(handles.edit62,'string');
end;

% plot colorful cell image
%plotImageCells(51,p.Maskimg,p.Maskimg,p.fdir,'cells-c',...
%    [outlinec,'-'],[0 max(p.Maskimg(:))],opt1,0,1,p.scale, tit, [], p.images{1},p.planes);
%addCellNumbers(51,p.Maskimg,[outlinec]); 

% plot image of cell outlines 
fig50=50;
[~,~,~,~,ax] = plotImageCells(fig50,nan(size(p.Maskimg)),p.Maskimg,p.fdir,CELLSFILE,...
    'r-',[0 1],opt1,0,1,p.scale, tit, [], p.images{1},p.planes);
addCellNumbers(ax,p.Maskimg,'k');

if opt1(11)
    %exportImageCells(51,p.fdir,'cells-c',p.ext);
    exportImageCells(fig50,p.fdir,CELLSFILE,p.ext, ...
        additional_settings.print_factors(7));
end;

if opt1(10)
    out=get_Cell_pos_size(p.Maskimg,p.scale);
    o = [out(:,1:3) out(:,1) zeros(size(out,1),2) out(:,4:7)];
    export_ascii_data_for_ROIS(o, p.fdir, CELLSFILE, '.dac', 'd');
end;

my_figure(fig50);
