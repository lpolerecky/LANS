function k=identifyMass(masses, mass)
% identify which of the masses is mass
k=0;
for ii=1:length(masses)
    if strcmp(mass,masses{ii})
        k=ii;
        break;
    end
end
