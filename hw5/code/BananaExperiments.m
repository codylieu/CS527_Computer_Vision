a = 1.2;
b = 0.1;
x0 = [-1; -1];
verbose = true;

% UNCOMMENT THE FOLLOWING LINE ONCE YOUR CODE IS READY
cost = bananaCost(a, b);

% Optimization parameters
delta = eps ^ (1/4);    % Stop searching when the step gets smaller than this (in pixels)...
epsilon = eps ^ (1/2); % ... or the cost decreases by less than this
alpha = 1e-2;    % Learning rate for steepest descent
maxDeltaX = Inf; % Maximum allowed motion from starting point
maxIter = 1000;   % Max number of iterations for iterative methods
from = -2 * [1 1]; % Row, column start for grid search
to = 3 * [1 1];  % Row, column finish for grid search
pitch = 0.1;

% Make the minimization methods
Newton = NewtonMethod(delta, epsilon, maxDeltaX, maxIter, verbose);
descent = descentMethod(alpha, delta, epsilon, maxDeltaX, maxIter, verbose);
grid = gridMethod(from, to, pitch, verbose);

% UNCOMMENT THE FOLLOWING LINES ONCE YOUR CODE IS READY
[xN, stateN] = minimize(cost, Newton, x0);
[xD, stateD] = minimize(cost, descent, x0);
[xG, stateG] = minimize(cost, grid, x0);

figure(1)
clf
% xStar = NaN; % REPLACE NaN WITH THE POINT WHERE f REACHES ITS MINIMUM
xStar = [a, a^2];
[residual, rfrom, rto] = gridResidual(grid, cost, x0);
showContours(residual', rfrom, pitch, rto, x0, 1);

hN = showPath(stateN.history, xStar, 'r');
hD = showPath(stateD.history, xStar, 'g');
hG = showPath(stateG.history, xStar, 'b');
legend([hN, hD, hG], ...
    sprintf('Newton (%d evaluations)', length(stateN.history)), ...
    sprintf('gradient descent (%d evaluations)', length(stateD.history)), ...
    sprintf('grid search (%d evaluations)', length(stateG.history)), ...
    'Location', 'NW')
