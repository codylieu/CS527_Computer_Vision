% I think this is wrong
nPCA = [3780 1000 500 200 100 50 20 10 5 2];
errorRates = zeros(size(nPCA));
[V, mu, sigma2] = PCA(forest1.X);
for i = 1:size(nPCA, 2)
forestTemp = fitensemble(compress(forest1.X, V, mu, nPCA(i)), HOGTrain.y, 'Bag', 100, 'tree', 'Type', 'classification');
errorRates(i) = oobLoss(forestTemp);
end

figure;
semilogx(nPCA, errorRates);
xlabel('Number of Principal Components (log scale)');
ylabel('Error Rate');

% I think this is the right way
nPCA = [3780 1000 500 200 100 50 20 10 5 2];
errorRates = zeros(size(nPCA));
[V, mu, sigma2] = PCA(HOGTrain.X);
for i = 1:size(nPCA, 2)
forest = fitensemble(compress(HOGTrain.X, V, mu, nPCA(i)), HOGTrain.y, 'Bag', 100, 'tree', 'Type', 'classification');
errorRates(i) = oobLoss(forest);
end

figure;
semilogx(nPCA, errorRates);
xlabel('Number of Principal Components (log scale)');
ylabel('Error Rate');
title('Number of Principal Components vs. Error Rate')

% results
errorRates =

    0.1485    0.1033    0.0769    0.0490    0.0357    0.0289    0.0235    0.0351    0.0621    0.1387

7th is the lowest error rate
this corresponds to nPCA 20