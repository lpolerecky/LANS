function [x y m ax] = my_ginput(fig_handle)

ax = [];
m=[];
x = [];
y = [];

try
    kkk = waitforbuttonpress;
catch
    fprintf(1,'GUI closed\n');
end;

ax = gca;
point_pressed = get(ax,'CurrentPoint');
x = point_pressed(1,1);
y = point_pressed(1,2);

if kkk==0 % button clicked
    click_type=get(fig_handle,'SelectionType');
    if strcmp(click_type,'normal')
        m=1;
    elseif strcmp(click_type,'alt')
        m=3;
    end;
else % key pressed
    character_type=get(fig_handle,'CurrentCharacter');
    if ~isempty(character_type)
        m = double(character_type);
        %fprintf(1,'Character type = %d\n',m);
        character_type=[];
    end;
end;
