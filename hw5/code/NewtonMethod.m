function m = NewtonMethod(delta, epsilon, maxMotion, maxIter, verbose)

m.name = 'Newton';
m.move = @move;
m.order = 2;
m.done = @converged;
m.delta = delta;
m.epsilon = epsilon;
m.maxMotion = maxMotion;
m.maxIteration = maxIter;
m.verbose = verbose;

    function state = move(cost, method, state)
        
        % Make sure Hessian is non-singular
        H = state.previous.H;
        H = H + sqrt(eps) * eye(size(H));
        
        % Compute and take the Newton step
        x = state.previous.x - H \ state.previous.g;
        state.current = cost.f(x, cost, method.order);
    end
end