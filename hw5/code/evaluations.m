function n = evaluations(state)

n = cellfun(@len, state);
n = sum(n(:));

    function L = len(i)
        if isempty(i)
            L = 0;
        else
            L = length(i.history);
        end
    end

end