function w = weights(net)

ok(net);
w = [];
for l = 1:length(net)
    for j = 1:length(net(l).bias)
        wk = net(l).kernel(:, :, j);
        w = [w; wk(:); net(l).bias(j)]; %#ok<AGROW>
    end
end