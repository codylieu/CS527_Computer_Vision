function e = cverr(S, K)

dMax = 3;
sMin = 1;

N = size(S.X, 1);

% Compute size of each bucket and the range of each bucket to index into
% the random permutation of integers from 1 to N
% this seems convoluted and there's probably a better way to do it
bucketSizes = zeros(1, K) + floor(N/K);
for i = 1:mod(N, K)
    bucketSizes(i) = bucketSizes(i) + 1;
end
separatingIndices = zeros(1, K);
separatingIndices(1) = bucketSizes(1);
for i = 2:K
    separatingIndices(i) = separatingIndices(i - 1) + bucketSizes(i);
end

[~, index] = sort(rand(N, 1));

% build trainingSet from K - 1 partitions then test on the last set
numWrong = 0;
trainingSet.labelMap = S.labelMap;
for k = 1:K
    trainingSet.X = [];
    trainingSet.y = [];
    for j = 1:K
        if k ~= j
            startIndex = separatingIndices(j) - bucketSizes(j) + 1;
            endIndex = separatingIndices(j);
            set = index(startIndex:endIndex);
            trainingSet.X = [trainingSet.X; S.X(set, :)];
            trainingSet.y = [trainingSet.y; S.y(set, :)];
        end
    end
    tree = trainTree(trainingSet, 0, false, dMax, sMin);
    % This code can be eliminated by using err.m and multiplying by size,
    % but not sure if it's worth it
    for x = separatingIndices(k) - bucketSizes(k) + 1:separatingIndices(k)
        y = treeClassify(S.X(index(x), :), tree);
        if y ~= S.y(index(x))
            numWrong = numWrong + 1;
        end
    end
end

e = numWrong / N;

end