%% Clean
clc; clear; tic;

%% Objective Function
global N
N = 1e2;
obj = @(x) x(1) + x(2);
op = optimoptions('fmincon', 'Algorithm', 'sqp');

%% Q1
[x, fval, flag, out] = fmincon(obj, [4, 4], [], [], [], [], [], [], @nonlcon, op);
if flag == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval);
else
    fprintf("Error: %d\n", flag);
end
toc;

%% Q2
N = 1e6;
[x, fval, flag, out] = fmincon(obj, [4, 4], [], [], [], [], [], [], @nonlcon, op);
if flag == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval);
else
    fprintf("Error: %d\n", flag);
end
toc;

%% Q3
[x, fval, flag, out] = fmincon(obj, [4, 4], [], [], [], [], [], [], @fosm, op);
if flag == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval);
else
    fprintf("Error: %d\n", flag);
end
toc;
