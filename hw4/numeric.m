function [g, e] = numeric(net, loss, xn, yn)

d = 10^-6;

w1 = weights(net);

[y, x, a] = cnn(xn, net);
[e, ew] = loss(yn, y);

g = zeros(size(w1));

for i = 1:size(w1)
    di = zeros(size(w1));
    di(i) = d;
    
    wTemp = w1 + di;
    net = setWeights(wTemp, net);
    [y, ~, ~] = cnn(xn, net);
    [eTemp, ~] = loss(yn, y);

    g(i) = (eTemp - e)/d;
end


end