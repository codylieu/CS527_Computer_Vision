function [d, state] = track(method, I, J, pos, d0, winsize)

% Just to be safe
pos = pos(:);
d0 = d0(:);

% Make the optimization cost function object
cost = ssdCost(I, J, pos, winsize);

% Do the work
if nargout >= 2
    [d, state] = minimize(cost, method, d0);
else
    d = minimize(cost, method, d0);
end

% Report the outcome
if method.verbose
    if any(isnan(d))
        fprintf(' lost\n');
    elseif nargout >= 2
            fprintf('tracked in %d steps, ', length(state.history)-1);
            fprintf('RMS residual %g gray levels per pixel\n', ...
                    sqrt(state.current.y / prod(cost.winsize)));
    else
        fprintf('\n');
    end
end