%% Clean
clc; clear; close all; tic;

%% Objective Function
global N g1 g2 g3 covx
N = 1e2;
g1 = @(x1, x2) 20 - x1.^2 .* x2;
g2 = @(x1, x2) 1 - (x1 + x2 - 5).^2 / 30 - (x1 - x2 - 12).^2 / 120;
g3 = @(x1, x2) x1.^2 + 8 * x2 - 75;
covx = [0.3^2, 0; 0, 0.3^2];

obj = @(x) x(1) + x(2);
pt = [-6.5, 2.1];
op = optimoptions('fmincon', 'Algorithm', 'sqp');

%% Q1
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
[x(3, :), fval(3), flag(3), out] = fmincon(obj, pt, [], [], [], [], [], [], @fosm, op);
if flag(3) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(3, :), fval(3));
else
    fprintf("Error: %d\n", flag(3));
end
toc;

%% Q2 Again
N = 1e6;
[x(2, :), fval(2), flag(2), out] = fmincon(obj, x(3, :), [], [], [], [], [], [], @nonlcon, op);
if flag(2) == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x(2, :), fval(2));
else
    fprintf("Error: %d\n", flag(2));
end
toc;

%% Plot Feasible Domain
figure1 = figure;
ax1 = gca;
grid_range = -10:10;
[x1, x2] = meshgrid(grid_range);
contour(grid_range, grid_range, x1 + x2);
colorbar;
hold on;

[x1, x2] = meshgrid(-10:0.05:10);
g_p = g1(x1, x2) > 0 | g2(x1, x2) > 0 | g3(x1, x2) > 0;
x1(g_p) = NaN;
x2(g_p) = NaN;
plot(x1, x2, 'o');
hold on;
plot(x(3, 1), x(3, 2), 'X');
toc;

%% Plot Guessed Points
figure2 = figure;
ax2 = copyobj(ax1, figure2);
rnd = mvnrnd(x(3, :), covx, N);
plot(rnd(:, 1), rnd(:, 2), 'o');
colorbar;
toc;
