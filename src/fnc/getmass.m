function mass=getmass(s)
s = removespaces(s);
ind=[0 find(s==' ')];
m=[];
for ii=1:4
    m{ii}=s((ind(ii)+1):(ind(ii+1)-1));
end;
mass=[];
if(~isnumber(m{2}) & isnumber(m{3}))
    mass.isotope = m{2};
    mass.mass = round(str2num(m{3}));
    mass.mass_precise = my_round(str2num(m{3})*100)/100;
end;
if( ~isnumber(m{2}) & ~isnumber(m{3}) & isnumber(m{4}) )
    mass.isotope = [m{2},m{3}];
    mass.mass = round(str2num(m{4}));
    mass.mass_precise = my_round(str2num(m{4})*100)/100;
end;
if(isnumber(m{2}) & ~isnumber(m{3}))
    mass.isotope = 'Esi';
    mass.mass = round(str2num(m{2}));
    mass.mass_precise = my_round(str2num(m{2})*100)/100;
end;
