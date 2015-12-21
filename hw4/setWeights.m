function net = setWeights(w, net)

ok(net);
for l = 1:length(net)
    for j = 1:length(net(l).bias)
        s = size(net(l).kernel(:, :, j));
        len = prod(s);
        net(l).kernel(:, :, j) = reshape(w(1:len), s);
        w = w((len+1):end);
        net(l).bias(j) = w(1);
        w = w(2:end);
    end
end