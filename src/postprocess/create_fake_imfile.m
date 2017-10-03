function a=create_fake_imfile(chk_im_file, ppim, outname)
% function for creating a "fake" im file from 2 or more partially processed
% im files

[pathstr, name, ext, versn] = fileparts(chk_im_file);
im =im2tiff([fixdir(pathstr),name],0);
m=[];
for ii=1:length(im.mass)
    m{ii}=im.mass{ii}.isotope;
end;
 
% gather all the data into a multidimensional cell
err=0;
IMF=[];
for ii=1:length(ppim)
    for jj=1:length(m)
        infile = [fixdir(ppim{ii}), 'mat', delimiter, m{jj}, '.mat'];
        if(exist(infile)==2)
            fprintf(1,'Loaded %s\n', infile);
            eval(['load ',infile]);
            IMF{jj}(:,:,ii)=IM;
        else
            fprintf(1,'Error: file %s not found\n',infile);
            err=1;
            break;
        end;
    end;
end;

if(~err)
   % copy the original chk_im file to the fake chk_im file   
   copyfile(chk_im_file,outname);
   % save the IMF variable to the fake im file
   [pathstr, name, ext, versn] = fileparts(outname);
   fakef=[fixdir(pathstr),name,'.imf'];
   save(fakef,'IMF','-v6','-mat');
   fprintf(1,'Combined im file created in %s\n', fakef);
end;

a=0;