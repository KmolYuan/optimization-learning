clc; clear;

%% Constance
global N rho F k h1 h2 h3 t mu tao atm c mu_sigma
N = 1e6;
rho = 1e3;
F = 180;  % N
k = 7e-2;  % cm
h1 = 13e-2;  % cm
h2 = 5.5e-2;  % cm
h3 = 4e-2;  % cm
t = 4e-2;  % cm
mu = 0.02;
tao = 12;  % Pa
atm = 101325;  % Pa
c = 2e-2;  % cm
mu_sigma = 0.1;  % mu / sigma

x = [4.5, 0.01, 0.01];
lb = 1e-6 * [1, 1, 1];
ub = 20 * [1, 1, 1];
op1 = optimoptions(@fmincon, 'Algorithm', 'sqp', 'Display', 'off');
op2 = optimoptions(@ga, 'Display', 'iter', 'PopulationSize', 100, 'MaxGenerations', 500, 'MutationFcn', {@mutationadaptfeasible, 0.001});

%% Main
[x0, fval, flag0] = fmincon(@objective, x, [], [], [], [], lb, ub, @nonlcon, op1);
fprintf('Flag: %i\n', flag0);
fprintf('max f(L=%.10f, d1=%.10f, d2=%.10f) = %.10f\n', x0, -fval);
% f(L=4.5210353141, d1=0.0100000000, d2=0.0035682482) = 10.1782776911
is_feasible(x0);

%% Uncertainty
[x1, fval, flag1] = fmincon(@objective, x, [], [], [], [], lb, ub, @nonlcon_uncertainty, op1);
% [x1, fval, flag1] = ga(@objective, 3, [], [], [], [], lb, ub, @nonlcon_uncertainty, op2);
fprintf('Flag: %i\n', flag1);
fprintf('max f(L=%.10f, d1=%.10f, d2=%.10f) = %.10f\n', x1, -fval);
is_feasible(x1);

%% FOSM
[x2, fval, flag2] = fmincon(@objective, x, [], [], [], [], lb, ub, @fosm, op1);
fprintf('Flag: %i\n', flag2);
fprintf('max f(L=%.10f, d1=%.10f, d2=%.10f) = %.10f\n', x2, -fval);
is_feasible(x2);

%% Uncertainty Twice
[x3, fval, flag3] = fmincon(@objective, x2, [], [], [], [], lb, ub, @nonlcon_uncertainty, op1);
% [x1, fval, flag1] = ga(@objective, 3, [], [], [], [], lb, ub, @nonlcon_uncertainty, op2);
fprintf('Flag: %i\n', flag3);
fprintf('max f(L=%.10f, d1=%.10f, d2=%.10f) = %.10f\n', x3, -fval);
is_feasible(x3);
