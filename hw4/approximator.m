function net = approximator(f, T)

k = floor(1/T) + 1;
sample = linspace(0, 1, k);
newT = sample(2) - sample(1);

ReLU = @(x) max(0, x);
triangle = @(x) ReLU(x + 1) - 2 .* ReLU(x) + ReLU(x - 1);

reluNet.gain = zeros(k, 1) + 1 ./ newT;
reluNet.bias = transpose(-(0:k-1));
reluNet.h = triangle;

identityNet.gain = f(sample);
identityNet.bias = 0;
identityNet.h = @(x) x;

net(1) = reluNet;
net(2) = identityNet;

end