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
    case 10, cmap=cmap_turbo;
    case 11, cmap=bone;
    case 12, cmap=copper;
    case 13, cmap=pink;
    case 14, cmap=gwyddion;
    case 15, cmap=cubehelix;
    case 16, cmap=cmrmap;
    case 17, cmap=viridis;
    otherwise, cmap=clut;
end
