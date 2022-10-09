function [new_im, new_mass_name, new_nb_mass, new_Nptrue] = rearrange_raw_image_data(im, mass_name)
% When deflection voltage peak switching is used, some masses will be
% detected multiple-times (2x) "per plane", while others only once "per
% plane". Find the unique masses detected, and rearrange the data
% accordingly. 
% LP, 27-02-2020, Utrecht University

fprintf(1,'WARNING: Some masses were measured multiple times, possibly due to deflection voltage peak switching.\nRearranging data...');
[new_mass_name, ia, ic] = unique(mass_name,'stable');
new_nb_mass = length(new_mass_name);
ia=[1:new_nb_mass];
Nb_factor = ceil(length(mass_name)/new_nb_mass);
[h,w,l]=size(im{1});
new_Nptrue = Nb_factor * l;

% preallocate space for the output
new_im = [];
for jj=1:new_nb_mass
    new_im{jj} = uint16( zeros(h,w,new_Nptrue) );
end

for ii=1:l
    
    for jj=1:new_nb_mass
        
        ind = find(ic==ia(jj));
        
        for kk=1:Nb_factor
            if kk<=length(ind)
                added_image = im{ind(kk)}(:,:,ii);
            else
                added_image = uint16(zeros(h,w));
            end
            new_im{jj}(:,:,Nb_factor*(ii-1)+kk) = added_image;
        end
        
    end
    
end
fprintf(1,'Done\n');
