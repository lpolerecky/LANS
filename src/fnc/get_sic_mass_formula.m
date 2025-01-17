function [fla2, mass_id] = get_sic_mass_formula(sic_mass)
%function [fla2, negative_flag] = get_sic_mass_formula(sic_mass, mass)
% convert the string in sic_mass to a formula for
% calculating intensity modulation "mass"      

% new approach: 17-01-2025
% substitute every digit by m{digid}
sic_mass_mod = [];
mass_id = [];
for ii=1:length(sic_mass)
    if double(sic_mass(ii)) >= double('0') && double(sic_mass(ii)) <= double('9')
        sic_mass_mod = [sic_mass_mod 'm{', sic_mass(ii), '}'];
        mass_id = [mass_id, sic_mass(ii)];
    else
        sic_mass_mod = [sic_mass_mod sic_mass(ii)];
    end
end
sic_mass_mod = regexprep(sic_mass_mod, 'log','log10');

fla2 = [sic_mass_mod ';'];

% old approach (before 17-01-2025)
if 0
    fla1 = [];
    negative_flag = 0;
    if strcmp(sic_mass(1),'-')
        negative_flag=1;
        sic_mass = sic_mass(2:length(sic_mass));
    end
    for indf=1:length(sic_mass)
        if double(sic_mass(indf))>double('0') && double(sic_mass(indf))<double('9')
            fla1 = [fla1 mass{double(sic_mass(indf))-double('0')}];
        else
            fla1 = [fla1 sic_mass(indf)];
        end
    end
    fla1 = ['1/(' fla1 ')'];
    [fla2, ~, ~] = parse_formula_lans(fla1,mass);
    fla2 = regexprep(fla2, 'r = ', '');
end
