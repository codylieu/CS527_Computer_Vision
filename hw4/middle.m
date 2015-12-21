function c = middle(x, n)
tail = (size(x, 1) - n) / 2;
assert(round(tail) == tail, 'unexpected tail length');
c = x(tail + (1:n), :);