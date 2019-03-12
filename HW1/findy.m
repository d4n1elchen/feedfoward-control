function dy=findy(time,y)
    dy = zeros(2,1);
    dy(1) = y(2);
    dy(2) = dy2(time);
end

