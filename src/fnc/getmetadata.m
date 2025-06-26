function [id, fname, tmnt, ct, xyz, alls, image_range] = getmetadata(Line,all_cell_types)
% parse input line to get the metadata

id=[];
fname=[];
tmnt=[];
ct=[];
ii=0;
jj=0;
alls=[];xyz=[];
image_range = '[]';

% new parsing (implemented on 2019-07-06)
%% new parsing (implemented on 2025-06-26)
% In the metafile, the columns should be separated by \t. However,
% sometimes there are spaces instead of \t. To avoid failure, substitute
% all \t by space, and then substitute multiple spaces by one space, then
% split the string. 
% Before doing so, determine the filename. If the filename contains spaces,
% it should be enclosed between " ", so determine that first, then proceed
% with the other parts of the string. If the filename does not contain
% spaces, then proceed as before.
if contains(Line,'"') % filename contains spaces, so it's enclosed between " " 
    items = strsplit(Line,'"');
    fname = items{2};
    Line = [items{1} items{3}];
    Line = regexprep(Line,'\t',' ');
    Line = regexprep(Line,' *',' ');
    items = strsplit(Line,' ');
else
    Line = regexprep(Line,'\t',' ');
    Line = regexprep(Line,' *',' ');
    items = strsplit(Line,' ');
    fname = items{2};
    items = items(setdiff(1:length(items),2));
end

% here, items contain everything on the Line except for the filename. Parse
% it to get all relevant items
nitems = length(items);
for ii=1:nitems
    if ii==1
        id = str2num(items{ii});
    elseif ii==2
        %fname = items{ii};
        %fname = regexprep(fname,' ','');
    %elseif ii==3
        tmnt = str2num(items{ii});
    elseif ii==3
        if items{ii}=='*'
            ct = [all_cell_types];
        else
            ct = items{ii};
        end
    else
        token = items{ii};
        if ~isempty(token)
            if is_range(token)
                image_range = token;
            else
                jj=jj+1;
                alls{jj} = token;
                xyz{jj} = convert_string_for_texoutput(token);
            end
        end
    end
end

% older code
% remain=Line;
% while 1
% 	[token,remain]=strtok(remain);
%     if isempty(token), break; end
%     ii=ii+1;
% 	switch ii
% 		case 1, id=str2num(char(token));
% 		case 2, fname=token;
% 		case 3, tmnt=str2num(char(token));
% 		case 4, if(token=='*'), ct=[all_cell_types]; else, ct=char(token); end;
% 		case 5, if is_range(token), xs1=[]; image_range = token; else, xs1=token; jj=jj+1; alls{jj}=token; end;
% 		case 6, if is_range(token), ys1=[]; image_range = token; else, ys1=token; jj=jj+1; alls{jj}=token; end;
% 		case 7, if is_range(token), xs2=[]; image_range = token; else, xs2=token; jj=jj+1; alls{jj}=token; end;
%         case 8, if is_range(token), ys2=[]; image_range = token; else, ys2=token; jj=jj+1; alls{jj}=token; end;
%         case 9, if is_range(token), xs3=[]; image_range = token; else, xs3=token; jj=jj+1; alls{jj}=token; end;
%         case 10, if is_range(token), ys3=[]; image_range = token; else, ys3=token; jj=jj+1; alls{jj}=token; end;                        
%         case 11, if is_range(token), image_range = token; end;
%         otherwise, jj=jj+1; alls{jj}=token; 
% 	end;
% end;
% 
% % change / and * to -, because that's how the data are stored
% if(~isempty(xs1)), xs1=convert_string_for_texoutput(xs1); end;
% if(~isempty(xs2)), xs2=convert_string_for_texoutput(xs2); end;
% if(~isempty(xs3)), xs3=convert_string_for_texoutput(xs3); end;
% if(~isempty(ys1)), ys1=convert_string_for_texoutput(ys1); end;
% if(~isempty(ys2)), ys2=convert_string_for_texoutput(ys2); end;
% if(~isempty(ys3)), ys3=convert_string_for_texoutput(ys3); end;
% 
% xyz={};
% if(~isempty(xs1)), xyz={xyz{:} xs1}; end;
% if(~isempty(ys1)), xyz={xyz{:} ys1}; end;
% if(~isempty(xs2)), xyz={xyz{:} xs2}; end;
% if(~isempty(ys2)), xyz={xyz{:} ys2}; end;
% if(~isempty(xs3)), xyz={xyz{:} xs3}; end;
% if(~isempty(ys3)), xyz={xyz{:} ys3}; end;

% if the metafile was created on a different platform (Linux vs. Windows),
% the folder separator will be incorrect. fix it to the correct one
ind=find(fname=='/' | fname=='\');
fname(ind)=filesep*ones(size(ind));

function f=is_range(s)
f=0;
if contains(s,'[') && contains(s,']')
    f=1;
end
