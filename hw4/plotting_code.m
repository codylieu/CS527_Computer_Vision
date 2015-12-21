load test
gb = backprop(convnet, @ee2, xn, yn);
gn = numeric(convnet, @ee2, xn, yn);
dg = gb - gn;
x=1:42

clf
plot(x, gb, 'b')
hold on
plot(x, gn, 'r')
legend('gb', 'gn')

%%%%%%%%


ndg = norm(dg) / mean([norm(gn), norm(gb)]);

plot(x, dg, 'g')

%%%%%%%%%

