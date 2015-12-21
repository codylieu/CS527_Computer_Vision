clc;
clearvars;

load fisheriris
T.X = meas;
[T.y, T.labelMap] = numberize(species);
[V, mu, sigma2] = PCA(T.X);
T.X = compress(T.X, V, mu, 2);

clc;

tau = trainTree(T, 0, false);
