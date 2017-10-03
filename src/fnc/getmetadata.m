function [id, fname, tmnt, ct, xyz, alls, image_range] = getmetadata(Line,all_cell_types)
% parse input line to get the metadata

remain=Line;
ii=0;
jj=0;
alls=[];
xs1=[];
ys1=[];
xs2=[];
ys2=[];
xs3=[];
ys3=[];
image_range = '[]';
while 1
	[token,remain]=strtok(remain);
    if isempty(token), break; end
    ii=ii+1;
	switch ii
		case 1, id=str2num(char(token));
		case 2, fname=token;
		case 3, tmnt=str2num(char(token));
		case 4, if(token=='*'), ct=[all_cell_types]; else, ct=char(token); end;
		case 5, if is_range(token), xs1=[]; image_range = token; else, xs1=token; jj=jj+1; alls{jj}=token; end;
		case 6, if is_range(token), ys1=[]; image_range = token; else, ys1=token; jj=jj+1; alls{jj}=token; end;
		case 7, if is_range(token), xs2=[]; image_range = token; else, xs2=token; jj=jj+1; alls{jj}=token; end;
        case 8, if is_range(token), ys2=[]; image_range = token; else, ys2=token; jj=jj+1; alls{jj}=token; end;
        case 9, if is_range(token), xs3=[]; image_range = token; else, xs3=token; jj=jj+1; alls{jj}=token; end;
        case 10, if is_range(token), ys3=[]; image_range = token; else, ys3=token; jj=jj+1; alls{jj}=token; end;                        
        case 11, if is_range(token), image_range = token; end;
        otherwise, jj=jj+1; alls{jj}=token; 
	end;
end;

% change / and * to -, because that's how the data are stored
if(~isempty(xs1)), xs1=convert_string_for_texoutput(xs1); end;
if(~isempty(xs2)), xs2=convert_string_for_texoutput(xs2); end;
if(~isempty(xs3)), xs3=convert_string_for_texoutput(xs3); end;
if(~isempty(ys1)), ys1=convert_string_for_texoutput(ys1); end;
if(~isempty(ys2)), ys2=convert_string_for_texoutput(ys2); end;
if(~isempty(ys3)), ys3=convert_string_for_texoutput(ys3); end;

xyz={};
if(~isempty(xs1)), xyz={xyz{:} xs1}; end;
if(~isempty(ys1)), xyz={xyz{:} ys1}; end;
if(~isempty(xs2)), xyz={xyz{:} xs2}; end;
if(~isempty(ys2)), xyz={xyz{:} ys2}; end;
if(~isempty(xs3)), xyz={xyz{:} xs3}; end;
if(~isempty(ys3)), xyz={xyz{:} ys3}; end;

% if the metafile was created on a different platform (Linux vs. Windows),
% the folder separator will be incorrect. fix it to the right one
ind=find(fname=='/' | fname=='\');
fname(ind)=filesep*ones(size(ind));

function f=is_range(s)
f=0;
if ~isempty(findstr(s,'[')) & ~isempty(findstr(s,']'))
    f=1;
end;
