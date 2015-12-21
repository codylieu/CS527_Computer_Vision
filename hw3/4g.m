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

% CORRECTED ERROR RATES FORMULA
sums(1, 1) = sum(errorRates(:, 1));
sums(2, 1) = sum(errorRates(:, 2));
errorRatesPercentage(:, 1) = errorRates(:, 1) ./ sums(1, 1) .* 100;
errorRatesPercentage(:, 2) = errorRates(:, 2) ./ sums(2, 1) .* 100;
errorRatesPercentage = round(errorRatesPercentage, 1);