function tests(solve)

% Reset the random number generator so we get repeatable samples
rng(0);

parm = [2 2 1 0; 2 2 2 1; 3 2 2 1; 3 2 1 1; 2 3 1 0; 2 3 2 1];

format = '%.2f';

fp = fopen('tests.tex', 'w');
fprintf(fp, '\\newpage\n');
fprintf(fp, '\\footnotesize{\n');

tc = 0;
for kk = 1:size(parm, 1)
    tc = tc + 1;
    [AA, bb] = testCase(parm(kk, :));
    outputTest(tc, AA, bb, solve, fp, format);
end
fprintf(fp, '}');
fclose(fp);

    function [A, b] = testCase(p)
        m = p(1);
        n = p(2);
        r = p(3);
        sol = p(4);
        [Q, ~, ~] = svd(rand(m), 0);
        L = Q(:, (r+1):end);
        Q = Q(:, 1:r);
        R = rand(r, n);
        A = Q*R;
        b = Q * rand(r, 1);
        if ~sol
            b = b + L * (rand(m-r, 1) + 1);
        end
    end

    function outputTest(tc, A, b, solve, fp, format)
        ok = true;
        dimOk = true;
        normOk = true;
        try
            [x, N, W, L, Q, R] = solve(A, b);
        catch
            ok = false;
            A, b %#ok<*NOPRT>
            warning('Your solve function failed with the inputs above');
            fprintf('and for the following call: [x, N, W, L, Q, R] = solve(A, b);\n');
        end
        if ok
            if dimensionsOk(A, b, x, R, N, W, L, Q, tc)
                if ~isempty(x)
                    x = W * W' * x;     % Project to the rowspace to make answer unique
                end
            else
                dimOk = false;
            end
            
            % Limp ahead with product checks even if some dimensions are bad
            check(sprintf('Case %d: A*x is not equal to b', tc), A, x, b);
            check(sprintf('Case %d: Wrong product N''*W', tc), N', W);
            check(sprintf('Case %d: Wrong product L''*Q', tc), L', Q);
            check(sprintf('Case %d: Wrong product Q*R', tc), Q, R, A);
            
            fprintf(fp, 'Test case %d: A has rank %d. ', tc, rank(A));
            
           printOutcome(fp, 'Product', normOk, ' ');
           printOutcome(fp, 'Dimension', dimOk, '\n');

            latexSolution(A, b, x, R, N, W, L, Q, fp, format);
        else
            warning('Omitting the associated outputs from the printout');
            fprintf(fp, 'Test case %d: Execution of \\texttt{solve} failed.\n\n', tc);
            fprintf(fp, '\\hrulefill\n\n'); 
        end
        
        function printOutcome(fp, type, ok, ending)
            if ok
                outcome = 'passed';
            else
                outcome = '\textbf{FAILED}';
            end
            fprintf(fp, '%s checks %s.', type, outcome);
            switch ending
                case ' '
                    fprintf(fp, ' ');
                case '\n'
                    fprintf(fp, '\n');
            end
        end
        
        function check(msg, A, B, C)
            go = ~isempty(A) && ~isempty(B);
            if nargin == 4
                go = go && ~isempty(C);
            end
            if go
                try
                    if nargin == 3
                        nOk = productOk(A, B);
                    else
                        nOk = productOk(A, B, C);
                    end
                    if ~nOk
                        normOk = false;
                        warning(msg);
                    end
                catch
                    dimOk = false;
                end
            end
        end
        
        function answer = productOk(A, B, C)
            if nargin == 3
                n = norm(A * B - C);
            else
                n = norm(A * B);
            end
            answer = n < eps ^(1/4);
        end
        
        function dOk = dimensionsOk(A, b, x, R, N, W, L, Q, tc)
            dOk = true;
            if isempty(A), dOk = false; end
            [m, n] = size(A);
            r = size(Q, 2);
            if ~isempty(x)
                if badSize(x, n, 1, 'x', tc), dOk = false; end
            end
            if badSize(b, m, 1, 'b', tc), dOk = false; end
            if badSize(R, r, n, 'R', tc), dOk = false; end
            if badSize(N, n, n-r, 'N', tc), dOk = false; end
            if badSize(W, n, r, 'W', tc), dOk = false; end
            if badSize(L, m, m-r, 'L', tc), dOk = false; end
            if badSize(Q, m, r, 'Q', tc), dOk = false; end
            
            function bad = badSize(A, m, n, name, tc)
                if m == 0 || n == 0
                    bad = ~isempty(A);
                else
                    bad = any(size(A) ~= [m, n]);
                end
                if bad
                    warning('%s in test case %d has inconsistent dimensions', ...
                        name, tc);
                end
            end
        end
    end

    function latexSolution(A, b, x, R, N, W, L, Q, fp, format)
        fprintf(fp, '\\[\n\\begin{array}{*{4}{c}}\n');
        latexRow({A, b, x, R}, {'A', '\mathbf{b}', '\mathbf{x}', 'R'}, fp, format);
        fprintf(fp, '\\\\\\mbox{}\\\\\n');
        latexRow({N, W, L, Q}, {'N', 'W', 'L', 'Q'}, fp, format);
        fprintf(fp, '\\end{array}\n\\]\n');
        fprintf(fp, '\\hrulefill\n\n');
    end

    function latexRow(A, name, fp, format)
        n = length(A);
        for k = 1:n
            latexArray(A{k}, name{k}, fp, format);
            if k < n
                fprintf(fp, '\\;, & \n');
            else
                fprintf(fp, '\\\\\n');
            end
        end
    end

    function latexArray(A, matrixname, fp, format)
        if isempty(A)
            fprintf(fp, '%s = []', matrixname);
        else
            [rows, cols] = size(A);
            fprintf(fp, '%s = \\left[\\begin{array}{*{%d}c}\n', matrixname, cols);
            for i = 1:rows
                fprintf(fp, '\t');
                for j = 1:cols
                    fprintf(fp, format, A(i, j));
                    if j < cols
                        fprintf(fp, ' & ');
                    elseif i < rows
                        fprintf(fp, '\\\\\n');
                    else
                        fprintf(fp, '\n');
                    end
                end
            end
            fprintf(fp, '\\end{array}\\right]\n');
        end
    end
end