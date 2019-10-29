%% Clean
clc; clear;

%% Constants
l = 9.14;  % unit: m
rho = 7860;  % unit: kg / m^3

%% Optimization
% f = 6 * pi * x(1) ^ 2 * l + 4 * pi * x(2) ^ 2 * sqrt(2) * l
obj = @(x) 2 * l * (3 * pi * x(1) * x(1) + 2 * pi * x(2) * x(2) * sqrt(2));
init = [1, 1];
[x, fval, flag, out] = fmincon(obj, init, [], [], [], [], [0, 0], [100, 100], @nonlcon, optimset);
if flag == 1
    fprintf("%s (iter: %i, step: %i)\n", out.algorithm, out.iterations, out.stepsize);
    fprintf("f(%.6f, %.6f) = %.6f\n", x, fval);
    fprintf("min wieght: %.6f kg\n", fval * rho);
else
    fprintf("Error: %i\n", flag);
end
