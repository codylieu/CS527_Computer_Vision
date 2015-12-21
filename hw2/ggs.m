function [Q, R] = ggs(A, Q, R)

if nargin < 3 || isempty(Q) || isempty(R)
    Q = [];
    R = [];
end

[m, n] = size(A);
[r0, n0] = size(R);

if ~isempty(Q) && size(Q, 1) ~= m
    error('A and Q have inconsistent row sizes')
end

if ~isempty(Q) && size(Q, 2) ~= r0
    error('Q and R have inconsistent sizes')
end

[qr, qc] = size(Q);

% Your code here
r = qc;
for j = 1+qc:n+qc
    ap = A(:, j-qc);
    for i = 1:r
        R(i, j) = dot(Q(:, i), A(:, j-qc));
        ap = ap - R(i, j).*Q(:, i);
    end
    rjj = norm(ap);
    if rjj > sqrt(eps)
        r = r + 1;
        R(r,j) = rjj;
        Q(:, r) = ap/rjj;
    end
end