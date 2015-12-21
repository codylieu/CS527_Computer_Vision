function [Train, Test] = readData(d, winSize)

if nargin < 2 || isempty(winSize)
    winSize = [128 64];
end

dataDir = fullfile(d, 'INRIAPerson');

posTrainDir = fullfile(dataDir, '96X160H96', 'Train', 'pos');
negTrainDir = fullfile(dataDir, 'Train', 'neg');

posTestDir = fullfile(dataDir, '70X134H96', 'Test', 'pos');
negTestDir = fullfile(dataDir, 'Test', 'neg');

Train = readSet(posTrainDir, negTrainDir, winSize);
Test = readSet(posTestDir, negTestDir, winSize);


    function S = readSet(posDir, negDir, winSize)
        
        fprintf('Reading data from directory %s\n', posDir);
        localTimer = tic;
                
        [Xp, yp] = setHOG(posDir, '+', 0, winSize);
        
        % Reset the random number generator so we get repeatable samples
        fprintf('Reading data from directory %s\n', negDir);
        rng(0);
        [Xn, yn] = setHOG(negDir, '-', 10, winSize);
        
        S.X = [Xp; Xn];
        S.y = [yp; yn];
        S.labelMap = {'+', '-'};
        
        time = toc(localTimer);
        fprintf('Took %.2f seconds overall\n', time);
        
        function [X, y] = setHOG(d, type, random, winSize)
            if type == '+'
                word = 'positive';
                label = 1;
            else
                word = 'negative';
                label = 2;
            end
            fprintf('Computing HOG features for %s samples\n', word);
            list = dir(d);
            list = list(~[list.isdir]);
            n = length(list);
            progress('start')
            for k = 1:n
                progress(k, n, 100);
                x = imgHOG(fullfile(d, list(k).name), winSize, random);
                if k == 1
                    rows = size(x, 1);
                    X = zeros(n * rows, size(x, 2));
                    rs = 1;
                    re = rows;
                end
                X(rs:re, :) = x;
                rs = rs + rows;
                re = re + rows;
            end
            progress('stop')
            y = label * ones(size(X, 1), 1);
        end
    end

    function progress(k, n, step)
        
        if nargin < 3
            step = 1;
        end
        
        max_length = 80;
        
        persistent total_length
        
        if nargin == 1 && ischar(k)
            if strcmpi(k, 'start') || strcmpi(k, 'begin')
                total_length = 0;
            elseif strcmpi(k, 'stop') || strcmpi(k, 'end') || strcmpi(k, 'finish')
                fprintf(1, '\n');
            end
        elseif nargin >= 2 && isnumeric(k) && isnumeric(n)
            remainder = n - k;
            if mod(remainder, step) == 0
                str = sprintf('%d ', remainder);
                
                string_length = length(str);
                total_length = total_length + string_length;
                if total_length > max_length
                    total_length = string_length;
                    fprintf(1, '\n');
                end
                
                fprintf(1, str);
            end
        else
            error('Usage: progress(''start'') | progress(''stop'') | progress(k, n) | progress(k, n, step)')
        end
    end
end