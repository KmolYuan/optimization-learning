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

pt = [0.3293, 0.3246];
lb = [1e-4, 1e-4];
obj = @(x) 6 * pi * x(1) * x(1) * l + 4 * pi * x(2) * x(2) * sqrt(2) * l;
op1 = optimoptions(@fmincon, 'Algorithm', 'sqp', 'Display', 'iter','MaxIterations',1500,'MaxFunctionEvaluations',1e4);
op2 = optimoptions(@ga, 'Display', 'iter', 'PopulationSize', 100, 'MaxGenerations', 500, 'MutationFcn', {@mutationadaptfeasible, 0.001});

%% Q1
N = 1e2;
x(1:3, 2) = 0;
[x(1, :), fval(1), flag(1), out] = fmincon(obj, pt, [], [], [], [], lb, [], @monte_carlo, op1);
%[x(1, :), fval(1), flag(1), out] = ga(obj, 2, [], [], [], [], lb, [], @monte_carlo, op1);
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
[x(2, :), fval(2), flag(2), out] = fmincon(obj, pt, [], [], [], [], lb, [], @monte_carlo, op1);
% [x(2, :), fval(2), flag(2), out] = ga(obj, 2, [], [], [], [], lb, [], @monte_carlo, op1);
if flag(2) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(2, :), fval(2));
else
    fprintf("Error: %d\n", flag(2));
end
toc;

%% Q3
[x(3, :), fval(3), flag(3), out] = fmincon(obj, pt, [], [], [], [], lb, [], @fosm, op1);
if flag(3) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(3, :), fval(3));
else
    fprintf("Error: %d\n", flag(3));
end
toc;

%% Plot
grid_range = 0:0.001:1;
[X1, X2] = meshgrid(grid_range, grid_range);
figure;
contour(X1, X2, 6 * pi * l .* X1.^2 + 4 * pi * sqrt(2) * l .* X2.^2, 0:10:300, 'ShowText', 'on')
colorbar;
hold on;
for r1 = 0:0.01:1
    for r2 = 0:0.01:1
        [C, ~] = nonlcon([r1, r2]);
        if C(21) > 0
            plot(r1, r2, 'x')
        end
    end
end
% r = [0.3292, 0.3247];
r = x(3, :);
rnd = mvnrnd(r, (r / 10).^2 .* [1, 0; 0, 1], N);
plot(rnd(:, 1), rnd(:, 2), 'o');
xlabel('r1');
ylabel('r2');
title("Objective function");

succeed = 0;
for i = 1:N
    [C, ~] = nonlcon([rnd(i, 1), rnd(i, 2)]);
    if C(21) <= 0
        succeed = succeed + 1;
    end
end
fprintf("%d > 99%", succeed / N);
