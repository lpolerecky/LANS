function fla2 = get_sic_mass_formula(sic_mass, mass)
% convert the string in sic_mass to a formula for
% calculating intensity modulation "mass"                     
fla1 = [];                    
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
