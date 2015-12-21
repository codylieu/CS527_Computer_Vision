clearvars
clc

load test

net = convnet;
loss = @ee2;

[gc, ec] = numeric(net, loss, xn, yn);

clc

[g, c] = backprop(net, loss, xn, yn);

