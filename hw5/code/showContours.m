function showContours(f, from, pitch, to, x0, fig)

fmax = max(f(:));
c = logspace(log10(0.1), log10(fmax), 20);
x = from(1):pitch:to(1);
y = from(2):pitch:to(2);

figure(fig)
clf
set(gcf, 'Position', [70 70 1400 1260])
clf
contour(x, y, f, c, 'k')
xlabel('x')
ylabel('y')
hold on
plot(x0(1), x0(2), 'xk');