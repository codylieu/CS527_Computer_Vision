colors = ['r', 'b'];
figure;
hold on;
for i = 1:size(Train.labelMap, 2)
    I = find(Train.y == i);
    plot(Train.X(I, 1), Train.X(I, 2), strcat(colors(i), '.'));
    legendInfo(i) = Train.labelMap(i);
end
axis equal;
axis tight;
xlabel('X');
ylabel('Y');