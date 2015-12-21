function [y, dyda] = ReLU(x)

y = max(0, x);
dyda = zeros(size(x));
dyda(x > 0) = 1;
