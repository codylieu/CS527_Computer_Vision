function m = descentMethod(alpha, delta, epsilon, maxMotion, maxIter, verbose)

m.name = 'gradient descent';
m.move = @move;
m.order = 1;
m.alpha = alpha;
m.done = @converged;
m.delta = delta;
m.epsilon = epsilon;
m.maxMotion = maxMotion;
m.maxIteration = maxIter;
m.verbose = verbose;

    function state = move(cost, method, state)
        % Compute and take a step along the negative gradient
        x = state.previous.x - method.alpha * state.previous.g;
        state.current = cost.f(x, cost, method.order);
    end
end