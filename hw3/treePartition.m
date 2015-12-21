function p = treePartition(tau, box)

xMin = box(1, 1);
xMax = box(2, 1);
yMin = box(1, 2);
yMax = box(2, 2);

if tau.d == 1
    p = [tau.t, yMin; tau.t, yMax];
    
    if isempty(tau.L.p)
        leftBox = [xMin, yMin; tau.t, yMax];
        p = cat(3, p, treePartition(tau.L, leftBox));
    end
    
    if isempty(tau.R.p)
        rightBox = [tau.t, yMin; xMax, yMax];
        p = cat(3, p, treePartition(tau.R, rightBox));
    end
else
    p = [xMin, tau.t; xMax, tau.t];
    
    if isempty(tau.L.p)
        leftBox = [xMin, yMin; xMax, tau.t];
        p = cat(3, p, treePartition(tau.L, leftBox));
    end
    
    if isempty(tau.R.p)
        rightBox = [xMin, tau.t; xMax, yMax];
        p = cat(3, p, treePartition(tau.R, rightBox));
    end
end

end