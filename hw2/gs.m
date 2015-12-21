function [Q, R] = gs(A)

Q = [];
R = [];

r = 0;
for j = 1:size(A, 2)
    ap = A(:, j);
    for i = 1:r
        R(i, j) = dot(Q(:, i), A(:, j));
        ap = ap - R(i, j).*Q(:, i);
    end
    rjj = norm(ap);
    if rjj > sqrt(eps)
        r = r + 1;
        R(r,j) = rjj;
        Q(:, r) = ap/rjj;
    end
end