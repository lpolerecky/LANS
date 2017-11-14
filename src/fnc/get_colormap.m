function cmap = get_colormap(colmap)
switch colmap
    case 1, cmap=clut;
    case 2, cmap=gray;
    case 3, cmap=hsv;
    case 4, cmap=hot;
    case 5, cmap=cool;
    case 6, cmap=spring;
    case 7, cmap=summer;
    case 8, cmap=autumn;
    case 9, cmap=winter;
    case 10, cmap=jet;
    case 11, cmap=bone;
    case 12, cmap=copper;
    case 13, cmap=pink;
    otherwise, cmap=clut;
end;
