function [Q, R] = mggs(A, Q, R)

if nargin < 3 || isempty(Q) || isempty(R)
    Q = [];
end

[Q, R] = qr([Q A], 0);
r = rank(R, sqrt(eps));
Q = -Q(:, 1:r);
R = -R(1:r, :);