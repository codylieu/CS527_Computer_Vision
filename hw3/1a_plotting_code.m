colors = ['r', 'g', 'b'];
figure;
hold on;
for i = 1:size(T.labelMap, 1)
    I = find(T.y == i);
    plot(T.X(I, 1), T.X(I, 2), strcat(colors(i), '.'));
end
axis equal;
axis tight;
xlabel('Feature 1');
ylabel('Feature 2');