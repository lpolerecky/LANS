function [x y] = get_points_lateral_profile(pos)
% connect the beginning and end points in pos with a line,
% and get the coordinates of the pixels on that line
% assumuption: x = 1st column; y = 2nd column in pos
k = diff(pos,1);
if abs(k(1))>abs(k(2))
    dx = diff(pos(:,1))/abs(diff(pos(:,1)));
    x = [pos(1,1):dx:pos(2,1)];
    y = round((x-x(1))*k(2)/k(1) + pos(1,2));
else
    dy = diff(pos(:,2))/abs(diff(pos(:,2)));
    y = [pos(1,2):dy:pos(2,2)];
    x = round((y-y(1))*k(1)/k(2) + pos(1,1));
end;