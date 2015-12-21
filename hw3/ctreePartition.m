function p = ctreePartition(tau, box, index)
% kick off this function with ctreePartition(tau, box, 1)
xMin = box(1, 1);
xMax = box(2, 1);
yMin = box(1, 2);
yMax = box(2, 2);

if isequal(tau.CutPredictor(index), tau.PredictorNames(1))
    p = [tau.CutPoint(index), yMin; tau.CutPoint(index), yMax];
    
    if tau.Children(index, 1) ~= 0
        leftBox = [xMin, yMin; tau.CutPoint(index), yMax];
        p = cat(3, p, ctreePartition(tau, leftBox, tau.Children(index, 1)));
    end
    
    if tau.Children(index, 2) ~= 0
        rightBox = [tau.CutPoint(index), yMin; xMax, yMax];
        p = cat(3, p, ctreePartition(tau, rightBox, tau.Children(index, 1)));
    end
else
    p = [xMin, tau.CutPoint(index); xMax, tau.CutPoint(index)];
    
    if tau.Children(index, 1) ~= 0
        leftBox = [xMin, yMin; xMax, tau.CutPoint(index)];
        p = cat(3, p, ctreePartition(tau, leftBox, tau.Children(index, 1)));
    end
    
    if tau.Children(index, 2) ~= 0
        rightBox = [xMin, tau.CutPoint(index); xMax, yMax];
        p = cat(3, p, ctreePartition(tau, rightBox, tau.Children(index, 2)));
    end
end

end