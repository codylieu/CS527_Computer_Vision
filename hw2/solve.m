function [x, N, W, L, Q, R] = solve(A, b)

[Q, R] = ggs(A, [], []);

[m, n] = size(Q);
[Qn, Rn] = ggs(eye(m), Q, R);
L = Qn(:, n+1:end);


[W, Rw] = ggs(A', [], []);

[r, col] = size(W);
[Qw, Rw] = ggs(eye(r), W, Rw);
N = Qw(:, col+1:end);

Q
b

c = Q'*b;

pivotColumns = [];
for rC = 1:size(R, 2)
    for rR = rC:size(R, 1)
        if abs(R(rR,rC)) > sqrt(eps)
            pivotColumns = [pivotColumns rC];
            break;
        end
    end
end


[Qb, Rb] = ggs(b, Q, R)
if ~isequal(Qb, Q)
    x = []
else
    cR = size(R, 2);
    i = cR;
    x = zeros(i,1);
    while i > 0
        if ismember(i,pivotColumns)
            x(i) = c(i);
            for j = i+1:cR
                x(i) = x(i) - x(j)*R(i, j);
            end
            x(i) = x(i)/R(i, i);
        else
            x(i) = 0;
        end
        i = i-1;
    end
end

end