function done = converged(method, state)

if state.iteration <= 1
    done = false;
else
    % Last step is small?
    done = norm(state.current.x - state.previous.x) <= method.delta;
    
    % Last decrease in cost is small (in relative size) or
    % even negative (i.e., the value goes up)?
    if ~done
        done = state.current.y == 0 || ...
            (state.previous.y - state.current.y) / ...
            state.current.y <= method.epsilon;
    end
    
    % Iteration count exceeded?
    if ~done
        if state.iteration == method.maxIteration
            if method.verbose
                reason = sprintf('%d iterations exceeded', method.maxIteration);
                reason = [reason, sprintf(';\nd [%g, %g], residual %g', ...
                    state.current.x, state.current.y)]; %#ok<*AGROW>
                reason = [reason, sprintf(', residual decrease %g, step %g', ...
                    state.current.y - state.previous.y, ...
                    norm(state.current.x - state.previous.x))];
                fprintf('Search failed for the following reason:\n%s\n', reason);
            end
        end
    end
end