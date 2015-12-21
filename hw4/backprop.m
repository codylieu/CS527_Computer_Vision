function [g, e] = backprop(net, loss, xn, yn)

[y, x, a] = cnn(xn, net);

L = size(net, 1);

[e, ey] = loss(yn, y);

g = [];

for l=L:-1:1
    curNet = net(l);
    curKernel = curNet.kernel;
    [~, dhda] = curNet.h(a{l});
    
    ex = [];
    for j = size(curKernel, 3):-1:1
        m = size(x{l}, 1);
        n = size(curKernel, 1);
        p = m - n + 1;
        
        ea = ey(:, j) .* dhda(:, j);
        dea = dilute(ea, p);
        
        exComponent = convn(dea, reverse(curKernel(:, :, j)), 'full');
        if isempty(ex)
            ex = exComponent;
        else
            ex = ex + exComponent;
        end
        convResult = convn(dilute(ea, p), reverse(x{l}), 'full');
        ek = middle(convResult, n);
        eb = sum(ea);
        g = [g;ek(:);eb];
    end
    ey = ex;
end

end