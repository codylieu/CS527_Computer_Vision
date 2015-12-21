function [y, dyda] = square(x)

y = x .^ 2;
dyda = 2 * x;