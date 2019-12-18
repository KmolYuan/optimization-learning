%% Clean
clc; clear; close all; tic;

%% Objective Function
global N l
l = 9.14;  % unit: m

pt = [5, 5];
obj = @(x) 6 * pi * x(1) * x(1) * l + 4 * pi * x(2) * x(2) * sqrt(2) * l;
op = optimoptions('fmincon', 'Algorithm', 'sqp');

%% Q1
N = 1e2;
x(1:3, 2) = 0;
[x(1, :), fval(1), flag(1), out] = fmincon(obj, pt, [], [], [], [], [], [], @nonlcon, op);
if flag(1) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(1, :), fval(2));
else
    fprintf("Error: %d\n", flag(1));
end
toc;

%% Q2
N = 1e6;
[x(2, :), fval(2), flag(2), out] = fmincon(obj, pt, [], [], [], [], [], [], @nonlcon, op);
if flag(2) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(2, :), fval(2));
else
    fprintf("Error: %d\n", flag(2));
end
toc;

%% Q3
% [x(3, :), fval(3), flag(3), out] = fmincon(obj, pt, [], [], [], [], [], [], @fosm, op);
% if flag(3) == 1
%     fprintf("algorithm: %s\n", out.algorithm);
%     fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
%     fprintf("f(%.10f, %.10f) = %.10f\n", x(3, :), fval(3));
% else
%     fprintf("Error: %d\n", flag(3));
% end
% toc;