function e = err(tau, S)

numWrong = 0;
n = size(S.X, 1);
for i = 1:n
    y = treeClassify(S.X(i, :), tau);
    if y ~= S.y(i)
        numWrong = numWrong + 1;
    end
end

e = numWrong / n;

end