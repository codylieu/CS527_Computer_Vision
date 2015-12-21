% Picking which dimensions to use

clearvars;
clc;

load fisheriris
T.X = meas;
[T.y, T.labelMap] = numberize(species);

clc;

% DOut

dOutT.X = meas(:, 1);
dOutT.y = T.y;
dOutT.labelMap = T.labelMap;


% PCA D

pcaT.X = T.X;
pcaT.y = T.y;
pcaT.labelMap = T.labelMap;

[V, mu, sigma2] = PCA(pcaT.X);
pcaT.X = compress(pcaT.X, V, mu, 1);

clc;

disp('Error rate for dOutT')
disp(cverr(dOutT, length(dOutT.y)))
disp('Error rate for pcaT')
disp(cverr(pcaT, length(pcaT.y)))
