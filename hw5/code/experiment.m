function [P, State, time] = experiment(method, fig, I, p0, winsize)

fprintf('*** Tracking experiment with %s method ***\n', method.name);

nFrames = size(I, 3);
p = p0;
P = p;
k = size(p, 2);
d = zeros(size(p));
State = cell(nFrames-1, k);

tic;

for i = 2:nFrames,
    if method.verbose
        fprintf('To frame %d:\n', i);
    end
    
    I1 = squeeze(I(:, :, i-1));
    I2 = squeeze(I(:, :, i));
    
    for j = 1:k
        if ~isnan(p(1, j))
            if method.verbose
                fprintf('Point %d ', j);
            end
            [d(:, j), State{i-1, j}] = track(method, I1, I2, p(:, j), d(:, j), ...
                winsize);
        end
    end
    
    p = p + d;
    
    P = cat(3, P, p);
end
if method.verbose
    fprintf('\n');
end

time = toc;

%%% Display inputs and results

Ifirst = squeeze(I(:, :, 1));
Ilast = squeeze(I(:, :, nFrames));

figure(fig)
clf
imagesc(Ifirst)
colormap gray
axis image
axis ij
hold on
showPoints(p0, 'r', true)
title('Initial points')
set(gcf, 'Name', sprintf('%s method', method.name))

fig = fig + 1;
figure(fig)
clf
imagesc(Ilast)
colormap gray
axis image
axis ij
hold on
showPoints(squeeze(P(:, :, end)), 'g', true)
title('Final Surviving Points')
set(gcf, 'Name', sprintf('%s method', method.name))

fig = fig + 1;
figure(fig)
clf
imagesc(Ilast)
colormap gray
axis image
axis ij
hold on
for i = 1:size(P, 2)
    hp = plot(squeeze(P(2, i, :)), squeeze(P(1, i, :)), 'w');
    set(hp, 'Color', 'w', 'LineWidth', 2);
    showPoints(p0, 'r', true);
    showPoints(squeeze(P(:, :, end)), 'g', false)
end
title('Tracks Superimposed on the Last Frame (green is endpoint)')
set(gcf, 'Name', sprintf('%s method', method.name))
