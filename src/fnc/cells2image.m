function Raim = cells2image(Ra, CELLS)
% Transform vector Ra to an image such that every pixel in a given cell (jj)
% in the image has the value Ra(jj).

Raim = zeros(size(CELLS));
vc=setdiff(unique(CELLS),0);
numObjects=length(vc);
if(numObjects>0)
    for jj=1:numObjects
        ind=find(CELLS==vc(jj));
        Raim(ind)=Ra(jj)*ones(size(ind));
    end;
end;
