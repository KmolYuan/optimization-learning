function val = objective(x)
L = x(1);

global rho k h1 h2 t c
l = L - k;
w = l + c;
val = -rho * t * (k * h1 + 0.5 * h2 * (w + l));
end
