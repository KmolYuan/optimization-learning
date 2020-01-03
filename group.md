\section*{\center Final Report \break Dimensional Optimization Design of Water Gun}

Class: ME7129 Optimization in Engineering, National Taiwan University.

Student: Yuan Chang 張元, 吳聖麟

Due date: 2020-01-07

This PDF is generated from Markdown[@group-md], scripting in Matlab[@group-ml].

# Executive Summary

# Introduction

# Problem Formulation

# Optimization Results and Validation

# Uncertainty Analysis

# Matlab Programming

The Matlab source code are provided that the situations can be reproduced.

**Main Script**: main.m

The main script defines all constants and execute "fmincon" function.

```matlab
clc; clear; close all;

%% Constants
global N rho F k h1 h2 h3 t mu tao atm c mu_sigma success_rate
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
mu_sigma = 5;  % mu / sigma
success_rate = 1e-3;  % success rate

x = [4.5, 0.01, 0.01];
lb = 1e-6 * [1, 1, 1];
ub = 20 * [1, 1, 1];
op1 = optimoptions(@fmincon, 'Algorithm', 'sqp', 'Display', 'off');
op2 = optimoptions(@ga, 'Display', 'iter', 'PopulationSize', 100, 'MaxGenerations', 500,...
                   'MutationFcn', {@mutationadaptfeasible, 0.001});

%% Main
[x0, fval, flag0] = fmincon(@objective, x, [], [], [], [], lb, ub, @nonlcon, op1);
fprintf('Flag: %i\n', flag0);
fprintf('max f(L=%.10f, d1=%.10f, d2=%.10f) = %.10f\n', x0, -fval);
% f(L=4.5210353141, d1=0.0100000000, d2=0.0035682482) = 10.1782776911
is_feasible(x0);

%% Uncertainty
[x1, fval, flag1] = fmincon(@objective, x, [], [], [], [], lb, ub, @nonlcon_uncertainty, op1);
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
fprintf('Flag: %i\n', flag3);
fprintf('max f(L=%.10f, d1=%.10f, d2=%.10f) = %.10f\n', x3, -fval);
is_feasible(x3);
```

**Objective function**: objective.m

The volume of water gun will calculated here.

```matlab
function val = objective(x)
global rho k h1 h2 t c
L = x(1);
d2 = x(3);
val = -rho * t * (k * h1 + 0.5 * h2 * (2 * (L - k) + c)) -...
      (L - k) * pi * d2^2 / 4;
end
```

**Non-linear constraints**: nonlcon.m

The normal method of non-linear constraints.

```matlab
function [C, Ceq] = nonlcon(x)
global F k t mu tao atm
L = x(1);
d1 = x(2);
d2 = x(3);
l = L - k;
v2 = (4 * F / pi - 4 * tao * l - atm * d2^2) / (32 * mu * l);

C(1) = d1 - t;
C(2) = d2 - t;
C(3) = k - L;
C(4) = 5 - v2;
C(5) = 1e-5 - pi * d2^2 * v2 * 0.05;
C(6) = d2 - d1;
Ceq = [];
end
```

**Monte Carlo method**: nonlcon_uncertainty.m

The Monte Carlo method for three variations $L$, $d_1$ and $d_2$.

```matlab
function [C, Ceq] = nonlcon_uncertainty(x)
global N F k t mu tao atm mu_sigma success_rate
persistent Pr
if isempty(Pr)
    Pr = @(a) sum(a) / N;
end
rnd = mvnrnd(x, (x * mu_sigma).^2 .* [1, 0, 0; 0, 1, 0; 0, 0, 1], N);
L = rnd(:, 1);
d1 = rnd(:, 2);
d2 = rnd(:, 3);
l = L - k;
v2 = (4 * F / pi - 4 * tao .* l - atm * d2.^2) ./ (32 * mu * l);

C(1) = Pr(d1 - t > 0);
C(2) = Pr(d2 - t > 0);
C(3) = Pr(k - L > 0);
C(4) = Pr(5 - v2 > 0);
C(5) = Pr(1e-5 - pi * d2.^2 .* v2 * 0.05 > 0);
C(6) = Pr(d2 - d1 > 0);
C = C - success_rate;

Ceq = [];
end
```

**First Order Second Moment method**: fosm.m

THe FOSM method for three variations $L$, $d_1$ and $d_2$.

The coefficients are same as Monte Carlo method.

```matlab
function [C, Ceq] = fosm(x)
global F k t mu tao atm mu_sigma success_rate
L = x(1);
d1 = x(2);
d2 = x(3);

mu_g(1) = d1 - t;
mu_g(2) = d2 - t;
mu_g(3) = k - L;
mu_g(4) = 5 - (4 * F / pi - 4 * tao * (L - k) - atm * d2^2) / (32 * mu * (L - k));
mu_g(5) = 1e-5 - pi * d2^2 * (4 * F / pi - 4 * tao * (L - k) - atm * d2^2) /...
          (32 * mu * (L - k)) * 0.05;
mu_g(6) = d2 - d1;

sig = (x * mu_sigma).^2;
sigma_g(1) = sig(2);
sigma_g(2) = sig(3);
sigma_g(3) = sig(1);
sigma_g(4) = (-2 * d2 * atm / (32 * mu * (L - k)))^2 * sig(3) +...
             ((-4 * tao * 32 * mu * (L - k) -...
             32 * mu * (4 * F / pi - 4 * tao * (L - k) - atm * d2^2)) /...
             (32 * mu * (L - k))^2)^2 * sig(1);
sigma_g(5) = (0.2 * pi * d2^3 / (32 * mu * (L - k)))^2 * sig(3) +...
             ((-0.2 * tao * pi * d2^2 * 32 * mu * (L - k) -...
             32 * mu * pi * d2^2 * (4 * F / pi - 4 * tao * (L - k) - atm * d2^2)) /...
             (32 * mu * (L - k))^2)^2 * sig(1);
sigma_g(6) = sig(2) + sig(3);
sigma_g = sqrt(sigma_g);

C = 1 - normcdf(-mu_g ./ sigma_g) - success_rate;
Ceq = [];
end
```

**Test feasiblity**: is_feasible.m

A function used to test the variables of results.

```matlab
function is_feasible(x)
[C, ~] = nonlcon(x);
if all(C <= 1e-6)
    fprintf('Feasible\n');
else
    fprintf('Infeasible\n');
end
end
```

# Summary

# Bibliography
