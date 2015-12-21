function d = dilute(x, p)
m = size(x, 1);
s = ceil(p / m);
d = zeros(s * m, size(x, 2));
d(1:s:end, :) = x;
d = d(1:p, :);