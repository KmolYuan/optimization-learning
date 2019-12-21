%% Clean
clc; clear; close all; tic;

%% Objective Function
global N l F E Pf sigma_y
l = 9.14;  % unit: m
F(1:12, 1) = 0;  % unit: N
F(4) = -1e7;
E = 200e9;  % unit: Pa
Pf = pi * pi * E / 4;  % P factor unit: N
sigma_y = 250e6;  % unit: Pa

pt = [0.3366, 0.35];
lb = [1e-6, 1e-6];
ub = [10, 10];
obj = @(x) 6 * pi * x(1) * x(1) * l + 4 * pi * x(2) * x(2) * sqrt(2) * l;
op1 = optimoptions(@ga, 'PopulationSize', 100, 'MaxGenerations', 500, 'MutationFcn', {@mutationadaptfeasible, 0.001});
op2 = optimoptions(@fmincon, 'Algorithm', 'sqp');

%% Q1
N = 1e2;
x(1:3, 2) = 0;
[x(1, :), fval(1), flag(1), out] = fmincon(obj, pt, [], [], [], [], lb, ub, @nonlcon, op2);
%[x(1, :), fval(1), flag(1), out] = ga(obj, 2, [], [], [], [], lb, ub, @nonlcon, op1);
if flag(1) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(1, :), fval(1));
else
    fprintf("Error: %d\n", flag(1));
end
toc;

%% Q2
N = 1e6;
[x(2, :), fval(2), flag(2), out] = fmincon(obj, pt, [], [], [], [], lb, ub, @nonlcon, op2);
% [x(2, :), fval(2), flag(2), out] = ga(obj, 2, [], [], [], [], lb, ub, @nonlcon, op1);
if flag(2) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(2, :), fval(2));
else
    fprintf("Error: %d\n", flag(2));
end
toc;

%% Q3
[x(3, :), fval(3), flag(3), out] = fmincon(obj, pt, [], [], [], [], lb, ub, @fosm, op2);
if flag(3) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(3, :), fval(3));
else
    fprintf("Error: %d\n", flag(3));
end
toc;
