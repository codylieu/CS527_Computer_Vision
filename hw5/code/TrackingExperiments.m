% Information for finding data
directory = strcat('..', filesep, 'Sequence');
prefix = 'i_';
extension = 'pgm';
nFrames = 8;
pointFile = 'points.mat';
verbose = true;

winsize = 15 * [1 1];    % Size in pixels of the tracking window

% Optimization parameters
delta = 1e-2;    % Stop searching when the step gets smaller than this (in pixels)...
epsilon = sqrt(eps); % ... or the cost decreases by less than this
alpha = 1e-3;    % Learning rate for steepest descent
maxMotionIter = min(winsize) / 2; % Maximum motion for iterative methods
maxIter = 100;   % Max number of iterations for iterative methods
from = -5 * [1 1]; % Row, column start for grid search
to = 5 * [1 1];  % Row, column finish for grid search
pitch = 1;       % Sampling pitch for the search grid

% Load images and coordinates of the points to track
[I, p0] = loadData(directory, prefix, extension, nFrames, pointFile, verbose);

% Make the minimization methods
Newton = NewtonMethod(delta, epsilon, maxMotionIter, maxIter, verbose);
descent = descentMethod(alpha, delta, epsilon, maxMotionIter, maxIter, verbose);
grid = gridMethod(from, to, pitch, verbose);

% Run the experiments
[PN, sN, timeN] = experiment(Newton, 1, I, p0, winsize);
[PD, sD, timeD] = experiment(descent, 4, I, p0, winsize);
[PG, sG, timeG] = experiment(grid, 7, I, p0, winsize);

% Print some diagnostics
fprintf('Points that survived in both iterative searches are %.4g pixels apart on average\n', ...
    discrepancy(PN, PD));
fprintf('Newton''s method called ssd %d times and took %.2g seconds\n',...
    evaluations(sN), timeN);
fprintf('The gradient descent method called ssd %d times and took %.2g seconds\n', ...
    evaluations(sD), timeD);
fprintf('The grid search method called ssd %d times and took %.2g seconds\n', ...
    evaluations(sG), timeG);