function showPoints(p, color, putLabel)

hold on
plot(p(2, :), p(1, :), '.k', 'MarkerSize', 20)
plot(p(2, :), p(1, :), sprintf('.%c', color), 'MarkerSize', 6)
if putLabel
    for i = 1:size(p, 2)
        h = text(p(2, i) - 20, p(1, i), sprintf('%d', i));
        set(h, 'Color', 'w', 'FontWeight', 'bold', 'FontName', 'Arial', ...
            'BackgroundColor', 'k')
    end
end
