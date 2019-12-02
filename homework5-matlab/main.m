%% Clean
clc; clear; tic;

%% Optimization
obj = @(x) x(1) + x(2);
op = optimoptions('fmincon', 'Algorithm', 'sqp');
[x, fval, flag, out] = fmincon(obj, [0, 0], [], [], [], [], [], [], @fosm, op);
% [x, fval, flag, out] = ga(obj, 2, [], [], [], [], [], [], @fosm);

%% Result
if flag == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval);
else
    fprintf("Error: %d\n", flag);
end
toc;
