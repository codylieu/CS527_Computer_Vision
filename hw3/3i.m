% Picking which dimensions to use

clearvars;
clc;

load fisheriris
T.X = meas;
[T.y, T.labelMap] = numberize(species);

clc;

cErrors = [];

for DOut = 1:4
	S.X = meas(:, DOut);
	S.y = T.y;
	S.labelMap = T.labelMap;

	cErrors(DOut) = cverr(S,  length(S.y));
end

clc;

disp(cErrors)