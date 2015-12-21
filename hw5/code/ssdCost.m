function cost = ssdCost(I, J, pos, winsize)

cost.f = @ssd;
cost.OK = @OK;
cost.I = I;
cost.J = J;
cost.pos = pos;
cost.winsize = winsize;

    function point = ssd(d, cost, order)
        
        % Allow for multiple displacement vectors (only for order == 0)
        if order > 0 && ~isvector(d)
            error('if order is nonzero, d must be a column vector')
        end
        nd = size(d, 2);
        
        half = floor(cost.winsize/2);
        
        % Just to be safe
        cost.pos = double(cost.pos);
        d = double(d);
        
        % Square root of a Gaussian filter
        tail = min(half) / 2;
        gr = sqrt(gauss(-half(1):half(1), 0, tail, 1));
        gc = sqrt(gauss(-half(2):half(2), 0, tail, 1));
        w = gr(:) * gc(:)';
        s = size(w);
        w = w(:);
        
        % Pixel coordinates in the two image windows
        ri = cost.pos(1)+(-half(1):half(1));
        ci = cost.pos(2)+(-half(2):half(2));
        rj = ones(nd, 1) * ri + d(1, :)' * ones(1, s(1));
        cj = ones(nd, 1) * ci + d(2, :)' * ones(1, s(2));
        
        % Pixel values in the two image windows
        Iwin = repmat(safeInterp(cost.I, ri, ci), [1 1 nd]);
        Jwin = zeros([s, nd]);
        for k = 1:nd
            Jwin(:, :, k) = safeInterp(cost.J, rj(k, :), cj(k, :));
        end
        
        % Pixel discrepancies
        dI = Jwin - Iwin;
        dI= reshape(dI, [prod(s), nd]);
        
        point.x = d;
        
        % Residual
        point.y = w' * (dI .^ 2);
        
        % Only compute gradient and Hessian if requested
        if order >= 1
            % Memoize for efficiency
            if ~isfield(cost, 'Jr')
                gr = grad(cost.J);
                cost.Jr = gr{1};
                cost.Jc = gr{2};
            end
            
            gr = safeInterp(cost.Jr, rj, cj);
            gc = safeInterp(cost.Jc, rj, cj);
            
            % Gradient
            G = [w .* gr(:) w .* gc(:)];
            g = w .* dI;
            point.g = 2 * G' * g;
            
            if order >= 2
                % Approximation to the Hessian
                point.H = 2 * (G' * G);
            end
        end
        
        % Interpolate mindful of image boundaries. The result is always an
        % array of size [length(r), length(c)], padded by replication as needed
        function W = safeInterp(I, r, c)
            pre = [0 0];
            post = [0 0];
            pre(1) = max(0, 1 - floor(r(1)));
            pre(2) = max(0, 1 - floor(c(1)));
            post(1) = max(0, ceil(r(end)) - size(I, 1));
            post(2) = max(0, ceil(c(end)) - size(I, 2));
            rcrop = r(r >= 1 & r <= size(I, 1));
            ccrop = c(c >= 1 & c <= size(I, 2));
            if isempty(rcrop) || isempty (ccrop)
                W = NaN(length(r), length(c));
            else
                W = interp2(I, ccrop, rcrop');
                W = padarray(W, pre, 'replicate', 'pre');
                W = padarray(W, post, 'replicate', 'post');
            end
        end
    end

    function good = OK(cost, method, state)
        
        % Window size and half of it
        ws = cost.winsize;
        half = floor(ws / 2);
        
        good = true;
        reason = '';
        
        % Do we exceed the image bounds?
        x = cost.pos + state.current.x;
        for i = 1:2
            good = good && x(i) >= half(i) + 1;
            good = good && x(i) <= size(cost.J, i) - half(i);
            if ~good
                reason = 'image bounds exceeded';
            end
        end
        
        % Too far away from d0?
        if good
            good = norm(state.current.x - state.first.x) <= method.maxMotion;
            if ~good
                reason = sprintf('moved more than %g pixels from d0', method.maxMotion);
            end
        end
        
        % Last iteration and cost too big?
        if good && state.iteration == method.maxIteration
            maxCost = prod(cost.winsize) * 10;
            good = state.current.y <= maxCost;
            if ~good
                reason = sprintf(...
                    'residual %g is more than %g gray levels after %d iterations', ...
                    state.current.y, maxCost, state.iteration);
            end
        end
        
        if ~good && method.verbose
            fprintf('Search failed for the following reason:\n%s\n', reason);
        end
    end
end