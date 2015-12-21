function [res, from, to] = gridResidual(grid, cost, shift)

if nargin < 3
    shift = zeros(length(grid.from), 1);
end

from = shift(:) + grid.from(:);
to = shift(:) + grid.to(:);
pitch = grid.pitch;

if ~isvector(from) || ~isvector(to)
    error('from and to must be vectors')
end

% Dimensionality of the space
dim = length(from);
if length(to) ~= dim
    error('from and to must have equal lengths')
end

% Build an n by dim matrix with the n points in the grid
sz = zeros(1, dim);
gp = (from(1):pitch:to(1))';
sz(1) = length(gp);
for i = 2:dim
    Xd = from(i):pitch:to(i);
    sz(i) = length(Xd);
    gp = x(gp, Xd');
end
gp = gp';

point = cost.f(gp, cost, 0);
res = reshape(point.y, sz);

% Compute the set cross product of the rows in u and those in v
    function w = x(u, v)
        urep = kron(ones(size(v, 1), 1), u);
        vrep = kron(v, ones(size(u, 1), 1));
        w = [urep, vrep];
    end
end