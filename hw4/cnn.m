function [y, x, a] = cnn(x1, net)

ok(net);

L = size(net, 1);

x = cell(L, 1);
a = cell(L, 1);

for i = 1:L
    x{i} = x1;
    curNet = net(i);
    curKernels = curNet.kernel;
    output = [];
    for j = 1:size(curKernels, 3)
        output = [output, convn(x1, curKernels(:, :, j), 'valid') + curNet.bias(j)];
    end
    x1 = output(1:curNet.stride:end, :);
    a{i} = x1;
    [x1, dhda] = curNet.h(x1);
end

y = x1;

end