function y=dy2(time)
if time<1
    y = 1;
elseif (time>=1 && time<3)
    y = -1;
elseif (time>=3 && time<4)
    y = 1;
else
    y = 0;
end
end