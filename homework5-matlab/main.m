%% Clean
clc; clear;

%% Optimization
obj = @(x) x(1) + x(2);
op = optimoptions('fmincon', 'Algorithm', 'sqp');
[x, fval, flag, out] = fmincon(obj, [0, 0], [], [], [], [], [], [], @fosm, op);

%% Result
if flag == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval);
    fprintf("min weight: %.10f kg\n", fval * rho);
else
    fprintf("Error: %d\n", flag);
end
