%% Optimization Homework
% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Cleanup
clear; clc;

%% Optimization
% Tested a lot of cases
global disable
disable = 0;
test_init = [1, 20.5, 30.6];
for n = 1:numel(test_init)
    test_case(test_init(n));
end
% Test disabled constraints
best = test_case(test_init(1));
for disable = 1:21
    test_case(1);
    fprintf("(Disabled: g%d)\n", disable);
end

%% Plot
disable = 0;
l = 9.14;
x1 = linspace(0, 1, 1000);
x2 = linspace(0, 1, 1000);
[X1, X2] = meshgrid(x1, x2);
fx = 6 * pi * l.*X1.*X1 + 4 * pi * sqrt(2) * l.*X2.*X2;
figure
contour(X1, X2, fx, 0:10:300, 'ShowText', 'on')
colorbar
colormap jet
hold on
for r1 = 0:0.01:1
    for r2 = 0:0.01:1
        [C, Ceq] = nonlcon([r1, r2]);
        if C(21) > 0
            plot(r1, r2, 'x')
        end
    end
end
plot(best(1), best(2), 'o')
xlabel('r1')
ylabel('r2')
title("Objective function")

function x = test_case(i)
% Test the case x1=x2 in this function.

%% Constants
persistent l rho obj ub lb op
if isempty(l)
    l = 9.14;  % unit: m
    rho = 7860;  % unit: kg / m^3
    % f = 6 * pi * x(1) ^ 2 * l + 4 * pi * x(2) ^ 2 * sqrt(2) * l
    obj = @(x) 2 * l * (3 * pi * x(1) * x(1) + 2 * pi * x(2) * x(2) * sqrt(2));
    ub = [100, 100];
    lb = [0, 0];
    op = optimoptions('fmincon', 'Algorithm', 'sqp');
end

%% Function Body
init = [i, i];
[x, fval, flag, out] = fmincon(obj, init, [], [], [], [], lb, ub, @nonlcon, op);
fprintf("[%.1f, %.1f]\n", init);
if flag == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval);
    fprintf("min weight: %.10f kg\n", fval * rho);
else
    fprintf("Error: %d\n", flag);
end

end
