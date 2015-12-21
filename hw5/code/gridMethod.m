function m = gridMethod(from, to, pitch, verbose)

m.name = 'grid';
m.move = @move;
m.order = 0;
m.done = @done;
m.from = from;
m.to = to;
m.pitch = pitch;
m.maxMotion = Inf;
mi = 1;
for k = 1:length(from)
    mi = mi * length(from(k):pitch:to(k));
end
m.maxIteration = mi;
m.verbose = verbose;

    function state = move(cost, method, state)
        
        % Don't want to use integer division!
        t = double(state.iteration);
        
        % Grid coordinates of current point starting at 0
        dim = length(state.current.x);
        x = zeros(dim, 1);
        n = t - 1;
        for d = 1:dim
            Xd = method.from(d):method.pitch:method.to(d);
            nd = length(Xd);
            x(d) = Xd(mod(n, nd) + 1);
            n = floor(n / nd);
        end
        x = x + state.first.x;
        
        % Value and possibly derivatives of the cost function at x
        point = cost.f(x, cost, method.order);
        
        % Update the state
        state.current = point;
        if t > 1 && state.previous.y <= point.y
            state.current = state.previous;
        end
    end

    function answer = done(method, state)
        answer = state.iteration > method.maxIteration;
    end
end