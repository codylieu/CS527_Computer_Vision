function ph = showPath(h, xStar, color)

path = [h(:).x];
ph = plot(path(1, :), path(2, :), sprintf('-%c', color));
plot(path(1, :), path(2, :), sprintf('.%c', color))
plot(xStar(1), xStar(2), sprintf('*%c', color))