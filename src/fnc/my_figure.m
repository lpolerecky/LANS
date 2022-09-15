function [f, ax]=my_figure(f)
ax=[];
% make the figure in the center of the screen by default

% new attempt of figure activation implemented on 2021-05-28
if ishandle(f)     
     % return handle to the existing figure
     fh = handle(f);
else
    fh = [];
end

if isgraphics(fh,'figure')
    f = fh;
    figure(f);
    % return also handles to any axes the figure may have
    ax = findall(f,'type','axes');     
else
    FigPos=get(0,'DefaultFigurePosition');
    FigWidth = FigPos(3);
    FigHeight = FigPos(4);
    FigPos(3) = FigWidth*1;
    FigPos(4) = FigHeight*1;
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);
    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
    fpos=FigPos;
    % activate the figure and place it in the middle of screen
    f=figure(f);
    %set(f,'Renderer','painters');
    set(f,'Position',fpos,'ToolBar','figure','MenuBar','None');
end
