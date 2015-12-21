function [n, labelMap] = numberize(y)

% Determine the number of classes
labelMap = unique(y);
K = length(labelMap);

% If class names are strings, convert them to numbers
if isnumeric(y)
    n = y;
elseif iscell(labelMap) && ischar(labelMap{1})
    n = zeros(size(y));
    for k = 1:K
        n(strcmp(y, labelMap{k})) = k;
    end
else
    error('I only know how to handle numbers and strings')
end