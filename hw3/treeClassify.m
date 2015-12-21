function y = treeClassify(x, tau)

if isempty(tau.d)
    indicesOfMax = find(tau.p == max(tau.p));
    y = indicesOfMax(1);
else
    y = treeClassify(x, split(x, tau));
end

    function child = split(x, tau)
        if x(tau.d) <= tau.t
            child = tau.L;
        else
            child = tau.R;
        end
    end
end