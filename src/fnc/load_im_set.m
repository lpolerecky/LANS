function p=load_im_set(handles)
% function to load all tiff images in the image sets

handles.p = load_masses_parameters(handles);
p = handles.p;

% find alignment co-ordinates of the images
if(p.find_alignments)
    aname=[p.fdir,'xyalign.mat'];
    if(exist(aname)==2)
        load(aname);
        disp(['XY-alignment loaded from ',aname]);
    else
        xyalign = findimagealignments(0,[p.fdir,p.alignment_mass], ...
            p.alignment_mass_images, p.alignment_image,...
            p.alignmentregion_x, p.alignmentregion_y);
        s=['save ',aname,' xyalign -v6'];
        eval(s);
        disp(['XY-alignment saved as ',aname]);
    end;    
else
    xyalign = [];
end;
p.xyalign = xyalign;

% load all tiff images
im=[]; ima=[];
for ii=1:length(p.mass)
    [it] = getimages([p.fdir,p.mass{ii}], p.images{ii}, p.xyalign);
    im{ii} = it;
    %ima{ii} = ita;
end;
p.im = im;
%p.ima = ima;
