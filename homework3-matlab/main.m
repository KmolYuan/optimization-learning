%% Optimization Homework
% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Cleanup
clear; clc;

%% Optimization
% Test 11 cases
global disable
disable = 0;
test_init = [-1, 0, 1, 2, 3, 10, 100, 8, 9, 10, 11, 12, 10];
for n = 1:numel(test_init)
    test_case(test_init(n));
end
% Test disabled constraints
for disable = 1:21
    test_case(10);
    fprintf("(Disabled: g%d)\n", disable);
end

function test_case(i)
% Test the case x1=x2 in this function.

%% Constants
persistent l rho obj ub lb
if isempty(l)
    l = 9.14;  % unit: m
    rho = 7860;  % unit: kg / m^3
    % f = 6 * pi * x(1) ^ 2 * l + 4 * pi * x(2) ^ 2 * sqrt(2) * l
    obj = @(x) 2 * l * (3 * pi * x(1) * x(1) + 2 * pi * x(2) * x(2) * sqrt(2));
    ub = [100, 100];
    lb = [0, 0];
end

%% Function Body
init = [i, i];
[x, fval, flag, out] = fmincon(obj, init, [], [], [], [], lb, ub, @nonlcon, optimset);
fprintf("[%d, %d]\n", init);
if flag == 1
    fprintf("algorithm: %s\n", out.algorithm);
    fprintf("(iter: %d, step: %i)\n", out.iterations, out.stepsize);
    fprintf("f(%.10f, %.10f) = %.10f\n", x, fval);
    fprintf("min wieght: %.10f kg\n", fval * rho);
else
    fprintf("Error: %d\n", flag);
end

end
