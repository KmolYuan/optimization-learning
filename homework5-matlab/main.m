%% Clean
clc; clear; close all; tic;

%% Objective Function
global N g1 g2 g3
N = 1e2;
g1 = @(x1, x2) 20 - x1.^2 .* x2;
g2 = @(x1, x2) 1 - (x1 + x2 - 5).^2 / 30 - (x1 - x2 - 12).^2 / 120;
g3 = @(x1, x2) x1.^2 + 8 * x2 - 75;
obj = @(x) x(1) + x(2);
pt = [4, 4];
op = optimoptions('fmincon', 'Algorithm', 'sqp');

%% Q1
[x, fval(2), flag(1), out] = fmincon(obj, pt, [], [], [], [], [], [], @nonlcon, op);
if flag(1) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval(2));
else
    fprintf("Error: %d\n", flag(1));
end
toc;

%% Q2
N = 1e6;
[x, fval(2), flag(2), out] = fmincon(obj, pt, [], [], [], [], [], [], @nonlcon, op);
if flag(2) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval(2));
else
    fprintf("Error: %d\n", flag(2));
end
toc;

%% Q3
[x, fval(3), flag(3), out] = fmincon(obj, pt, [], [], [], [], [], [], @fosm, op);
if flag(3) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval(3));
else
    fprintf("Error: %d\n", flag(3));
end
toc;

%% Plot
x1 = 0:0.1:100;
figure;
plot(x1, 20 ./ x1.^2);
hold on;
% 1 - (x1 + x2 - 5)^2 / 30 - (x1 - x2 - 12)^2 / 120 = 0
% -x1^2/24 - x1*x2/20 + 8*x1/15 - x2^2/24 + 2*x2/15 - 31/30 = 0
% -x1^2/24 + 8*x1/15 - 31/30 = x1*x2/20 + x2*(5*x2 - 16)/120
% plot(x1, x1);
% hold on;
plot(x1, (x1.^2 - 75) / 8);
