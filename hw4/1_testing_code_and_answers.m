% 1b
N = 101;
T = 0.05;
f = @(x) exp(x) .* sin(3 * pi * x);
net = approximator(f, T);
x = linspace(0, 1, N);
y = nn(x, net);
clf
plot(x, f(x), 'b')
hold on
plot(x, y, 'r')
xlabel('X')
ylabel('Y')
title('Two-Layer Neural Network with 64 Gains and Biases')
legend('f(x) = exp(x) * sin(3 * pi * x)', 'Two-Layer Approximation with Triangle Function', 'Location', 'northwest')

% 1c
% k = 21 and there were 64 gains and biases
nw = 3k + 1