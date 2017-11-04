function rgb=clut(ncol)
% Function for generating the same colormap as used by 
% the Cameca software.
%
% Lubos Polerecky, 26.4.2009, MPI Bremen

if nargin==1
    nc=ncol;
else
    nc=64;
end;

rgb = flipud([255    6    4
  254   22    4
  253   38    4
  252   54    4
  251   70    4
  250   86    4
  249  102    4
  248  118    4
  247  134    4
  246  151    4
  245  153    4
  244  156    5
  243  159    5
  242  161    5
  241  164    5
  240  167    5
  236  177    5
  232  187    5
  228  197    5
  224  207    5
  220  217    5
  216  227    6
  212  237    6
  208  247    6
  204  248    6
  189  249    6
  174  250    6
  160  251    6
  145  252    6
  131  253    6
  116  255    6
  102  254    7
   87  253   27
   72  253   48
   58  252   68
   43  252   89
   29  247  109
   14  243  130
    0  236  150
    0  230  171
    0  224  191
    0  218  212
    0  202  232
    0  186  253
    0  170  253
    0  154  253
    0  138  253
    0  122  253
    0  106  253
    0   90  253
    0   74  255
    0   58  245
    0   43  236
    0   39  227
    0   35  200
    0   31  178
    0   27  156
    0   23  133
    0   19  111
    0   15   89
    0   11   66
    0    7   44
    0    3   22
    0    0    0
    %255 255 255
])/255;

%rgb=1-rgb;
    
if nc~=64
    % extrapolate above values for nc colors
    x1=[1:size(rgb,1)]';
    x2=linspace(min(x1),max(x1),nc)';
    re=interp1(x1,rgb(:,1),x2,'linear');
    ge=interp1(x1,rgb(:,2),x2,'linear');
    be=interp1(x1,rgb(:,3),x2,'linear');
    rgb=[re ge be];    
end;