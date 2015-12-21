trainingErrorRate = loss(forest, HOGTrain.X, HOGTrain.y, 'mode', 'cumulative');
outOfBagErrorRate = oobLoss(forest, 'mode', 'cumulative');
testErrorRate = loss(forest, HOGTest.X, HOGTest.y, 'mode', 'cumulative');
figure
hold on;
plot(1:100, trainingErrorRate, 'r.')
plot(1:100, outOfBagErrorRate, 'b.')
plot(1:100, testErrorRate, 'g.')
xlabel('Number of Trees')
ylabel('Classification Error')
legend('Training Error Rate', 'Out-of-bag Error Rate', 'Test Error Rate')