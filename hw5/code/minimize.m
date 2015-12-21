function [x, state] = minimize(cost, method, x0)

% Do we want to record tracking-history information?
if nargout >= 2
    state.history = [];
end

% Initialize the search state by computing function values at x0
state.first = cost.f(x0, cost, method.order);
state.current = state.first;
state = record(state);

for t = 1:method.maxIteration
    % Remember where we are
    state.iteration = t;
    state.previous = state.current;
    
    % Make the move
    state = method.move(cost, method, state);
    state = record(state);
    
    % Did the user cost function return an invalid result?
    if any(isnan(state.current.x))
        break;
    end
    
    % Does the user accept the current state?
    if ~cost.OK(cost, method, state)
        state.current.x = NaN(size(x0));
        state.current.y = NaN;
        break;
    end
    
    % Converged?
    if method.done(method, state)
        break;
    end
end

x = state.current.x;

    function state = record(state)
        if isfield(state, 'history')
            state.history = [state.history state.current];
        end
    end
end