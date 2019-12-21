function [C, Ceq] = nonlcon(x)
% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Constants
global N l F E Pf sigma_y
g(1:21, 1) = 0;
for i = 1:N
    x1 = normrnd(x(1), x(1) / 10);
    x2 = normrnd(x(2), x(2) / 10);
    Frnd(1:12, 1) = 0;
    Frnd(4) = normrnd(F(4), abs(F(4)) / 10);
    [l_e, Q, stress] = TenBarAnalysis([x1, x2], l, E, Frnd);
    stress = abs(stress);

    % abs(stress(i)) * pi * x1 ^ 2 - pi ^ 3 * E * x1 ^ 4 / (4 * l_e ^ 2) <= 0
    g(1:6) = g(1:6) + (pi * x1 * x1 * (stress(1:6) - Pf * x1 * x1 * l_e(1:6).^-2) > 0);
    % abs(stress(i)) * pi * x2 ^ 2 - pi ^ 3 * E * x2 ^ 4 / (4 * l_e ^ 2) <= 0
    g(7:10) = g(7:10) + (pi * x2 * x2 * (stress(7:10) - Pf * x2 * x2 * l_e(7:10).^-2) > 0);
    % abs(stress(i)) - sigma_y <= 0
    g(11:20) = g(11:20) + (stress(1:10) - sigma_y > 0);
    % delta2 - 0.02 <= 0
    g(21) = g(21) + (hypot(Q(3), Q(4)) - 0.02 > 0);
end

%% Inequality Constraints
C = g / N - 0.0013;

%% Equality Constraints
Ceq = [];
end
