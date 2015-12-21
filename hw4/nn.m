function X = nn(X, net)

for i = 1:size(net, 2)
    curNet = net(i);
    W = [curNet.gain curNet.bias];
    X = [X; ones(1, size(X, 2))];
    a = W*X;
    X = curNet.h(a);
end

end