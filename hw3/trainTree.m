function tau = trainTree(S, depth, random, dMax, sMin)

if depth == 0
    if nargin < 3 || isempty(random)
        random = false;
    end
    
    if nargin < 4 || isempty(dMax)
        dMax = Inf;
    end
    
    if nargin < 5 || isempty(sMin)
        sMin = 1;
    end
end

tau.d = [];
tau.t = [];
tau.L = [];
tau.R = [];
tau.p = [];

% Your code here
if OkToSplit(S, depth)
    [L, R, dOpt, tau.t] = findSplit(S);

    % Still needs the case where x has two y's
    if (dOpt == -1)
        tau.p = distribution(S);
    else
        tau.d = dOpt;
        tau.L = trainTree(L, depth+1, random, dMax, sMin);
        tau.R = trainTree(R, depth+1, random, dMax, sMin);
    end
else
    tau.p = distribution(S);
end

    function answer = OkToSplit(S, depth)
        % Your code here
        answer = (impurity(S) > 0) && (size(S.X, 1) > sMin) && (depth < dMax);
    end

    function [LOpt, ROpt, dOpt, tOpt] = findSplit(S)
        % Your code here
        iS = impurity(S);
        deltaOpt = -1;
        
        LOpt = [];
        ROpt = [];
        dOpt = -1;
        tOpt = -1;
        
        for d = 1:size(S.X, 2)
            dimensionToSplit = d;
            if random
                dimensionToSplit = randi([1 size(S.X, 2)]);
            end
            x = S.X(:, dimensionToSplit);
            list = thresholds(x);
            for l = 1:size(list, 2)
                curCol = S.X(:, dimensionToSplit);
                
                curL.X = S.X(curCol <= list(l), :);
                curL.y = S.y(curCol <= list(l), :);
                curL.labelMap = S.labelMap;
                
                curR.X = S.X(curCol > list(l), :);
                curR.y = S.y(curCol > list(l), :);
                curR.labelMap = S.labelMap;

                delta = iS - (size(curL.X, 1)/size(S.X, 1))*impurity(curL) - (size(curR.X, 1)/size(S.X, 1))*impurity(curR);
                if delta > deltaOpt
                    deltaOpt = delta;
                    LOpt = curL;
                    ROpt = curR;
                    dOpt = dimensionToSplit;
                    tOpt = list(l);
                end
            end
        end
    end

    function p = distribution(S)
        % Your code here
        p = zeros(size(S.labelMap));
        n = size(S.y, 1);
        for i = 1:n
            p(S.y(i)) = p(S.y(i)) + 1;
        end
        p = p / n;
    end

    function i = impurity(S)
        % Your code here
        % Using the Gini index as opposed to err(S)
        i = 1;
        n = size(S.y, 1);
        for j = 1:size(S.labelMap)
            p = (size(find(S.y == j), 1) / n) ^ 2;
            i = i - p;
        end
    end

    function list = thresholds(x)
        % Your code here
        % This function produces a sorted list of split thresholds to try
        % given a vector x of the values in a single feature dimension
        x = sort(unique(x));
        ud = size(x) - 1;
        list = [];
        for i = 1:ud
            list(i) = (x(i) + x(i + 1)) / 2;
        end
    end
end