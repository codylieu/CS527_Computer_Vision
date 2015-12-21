function [e, ey]= ee2(yn, y)

e = norm(yn-y)^2;

d = 10^-6;

ey = zeros(size(y));

for i = 1:size(ey, 1)
    di = zeros(size(y));
    di(i) = d;
    yd = y + di;
    ey(i) = (norm(yn - yd)^2 - e) / d;
end

end