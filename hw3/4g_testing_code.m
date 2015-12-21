% True Positive (1, 1): Classifier says pedestrian and it is
% False Positive (1, 2): Classifier says pedestrian and it's not
% False Negative (2, 1): Classifier says not pedestrian and it is
% True Negative (2, 2): Classifier says not pedestrian and it isn't

% I think this is the wrong way. Ignore until next comment
[HOGTrain, HOGTest] = readData('INRIA_Person_Database');

[VTrain, muTrain, sigma2Train] = PCA(HOGTrain.X);
forestOptimalComponents = fitensemble(compress(HOGTrain.X, VTrain, muTrain, 20), HOGTrain.y, 'Bag', 100, 'tree', 'Type', 'classification');
[VTest, muTest, sigma2Test] = PCA(HOGTest.X);
labels = predict(forestOptimalComponents, compress(HOGTest.X, VTest, muTest, 20));

[VTrain, muTrain, sigma2Train] = PCA(HOGTrain.X);
Train.X = compress(HOGTrain.X, VTrain, muTrain, 2);
Train.y = HOGTrain.y;
Train.labelMap = HOGTrain.labelMap;

forest = fitensemble(Train.X, Train.y, 'Bag', 100, 'tree', 'Type', 'classification');

[VTest, muTest, sigma2Test] = PCA(HOGTest.X, 20);
Test.X = compress(HOGTest.X, VTest, muTest, 2);
Test.y = HOGTest.y;
Test.labelMap = HOGTest.labelMap;

[VForest, muForest, sigma2Forest] = PCA(forest.X);
forestOptimalComponents = fitensemble(compress(forest.X, VForest, muForest, 20), HOGTrain.y, 'Bag', 100, 'tree', 'Type', 'classification');
labels = predict(forestOptimalComponents, Test.X);

% I think this is the right way
[HOGTrain, HOGTest] = readData('INRIA_Person_Database');

[VTrain, muTrain, sigma2Train] = PCA(HOGTrain.X);
forestOptimalComponents = fitensemble(compress(HOGTrain.X, VTrain, muTrain, 20), HOGTrain.y, 'Bag', 100, 'tree', 'Type', 'classification');
[VTest, muTest, sigma2Test] = PCA(HOGTest.X);
labels = predict(forestOptimalComponents, compress(HOGTest.X, VTest, muTest, 20));

errorRates = zeros(2);
N = size(labels, 1);
for i = 1:N
    if labels(i) == 1 && HOGTest.y(i) == 1
        % True Positive
        errorRates(1, 1) = errorRates(1, 1) + 1;
    elseif labels(i) == 2 && HOGTest.y(i) == 2
        % True Negative
        errorRates(2, 2) = errorRates(2, 2) + 1;
    elseif labels(i) == 1 && HOGTest.y(i) == 2
        % False Positive
        errorRates(1, 2) = errorRates(1, 2) + 1;
    elseif labels(i) == 2 && HOGTest.y(i) == 1
        % False Negative
        errorRates(2, 1) = errorRates(2, 1) + 1;
    end
end

sums(1, 1) = sum(errorRates(1, :));
sums(2, 1) = sum(errorRates(2, :));
errorRatesPercentage(1, :) = errorRates(1, :) ./ sums(1, 1) .* 100;
errorRatesPercentage(2, :) = errorRates(2, :) ./ sums(2, 1) .* 100;
errorRatesPercentage = round(errorRatesPercentage, 1);

% Let's try this one more time
[HOGTrain, HOGTest] = readData('INRIA_Person_Database');

[VTrain, muTrain, sigma2Train] = PCA(HOGTrain.X);
forestOptimalComponents = fitensemble(compress(HOGTrain.X, VTrain, muTrain, 20), HOGTrain.y, 'Bag', 100, 'tree', 'Type', 'classification');
[VTest, muTest, sigma2Test] = PCA(HOGTest.X);
labels = predict(forestOptimalComponents, compress(HOGTest.X, VTest, muTest, 20));

errorRates = zeros(2);
N = size(labels, 1);
for i = 1:N
    if labels(i) == 1 && HOGTest.y(i) == 1
        % True Positive
        errorRates(1, 1) = errorRates(1, 1) + 1;
    elseif labels(i) == 2 && HOGTest.y(i) == 2
        % True Negative
        errorRates(2, 2) = errorRates(2, 2) + 1;
    elseif labels(i) == 1 && HOGTest.y(i) == 2
        % False Positive
        errorRates(1, 2) = errorRates(1, 2) + 1;
    elseif labels(i) == 2 && HOGTest.y(i) == 1
        % False Negative
        errorRates(2, 1) = errorRates(2, 1) + 1;
    end
end

rowSums(1, 1) = sum(errorRates(1, :));
rowSums(2, 1) = sum(errorRates(2, :));

columnSums(1, 1) = sum(errorRates(:, 1));
columnSums(1, 2) = sum(errorRates(:, 2));

P = rowSums(1, 1);
N = rowSums(2, 1);

R = columnSums(1, 1);
I = columnSums(1, 2);

p = errorRates(1, 1) ./ R;
pi = errorRates(1, 1) ./ P;
sig = errorRates(2, 2) ./ I;
phi = errorRates(1, 2) ./ I;

TP = p * R;
FN = R * (1 - p);
FP = phi * I;
TN = (1 - phi) * I;