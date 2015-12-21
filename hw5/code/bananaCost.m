function cost = bananaCost(a, b)

cost.f = @banana;
cost.OK = @OK;
cost.a = a;
cost.b = b;

    function point = banana(x, cost, order)
        % YOUR CODE HERE

        if order > 0 && ~isvector(x)
            error('if order is nonzero, x must be a column vector')
        end

        x = double(x);
        cost.a = double(cost.a);
        cost.b = double(cost.b);

        point.x = x;
        point.y = (cost.a - x(1,:)).^2 + cost.b * (x(2,:) - x(1,:).^2).^2;

		if order>=1
			point.g(1,1) = -2 * cost.a + 4 * cost.b * x(1)^3 - 4 * cost.b * x(1) * x(2) + 2 * x(1);
			point.g(2,1) = 2 * cost.b * (x(2) - x(1)^2);
			if order>=2
				point.H(1,1) = 12 * cost.b * x(1)^2 + 2;
				point.H(1,2) = -4 * cost.b * x(1);
				point.H(2,1) = point.H(1,2);
				point.H(2,2) = 2 * cost.b;
			end
		end
 
    end

    function good = OK(~, ~, ~)
        % YOUR CODE HERE
        good = true;
    end
end