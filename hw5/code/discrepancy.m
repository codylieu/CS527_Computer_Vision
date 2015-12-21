function d = discrepancy(P, Q)

if any(size(P) ~= size(Q))
    error('Input arrays must have equal size')
end

P = P(:);
Q = Q(:);
common = ~isnan(P) & ~isnan(Q);
P = P(common);
Q = Q(common);
d = norm(P - Q) / length(P) * 2;