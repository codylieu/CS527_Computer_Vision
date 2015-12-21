function Y = compress(X, V, mu, k)

if isempty(k) || k > size(V, 2)
    k = size(V, 2);
end

Ac = X - ones(size(X, 1), 1)*mu;

V = V(:, 1:k);
Y = Ac*V;

end