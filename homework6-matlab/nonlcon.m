function [C, Ceq] = nonlcon(x)
% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Constants
global N l F E Pf sigma_y
persistent Pr
if isempty(Pr)
    Pr = @(a) sum(a) / N;
end

g(1:21, 1:N) = 0;
for i = 1:N
    x1 = normrnd(x(1), x(1) / 10);
    x2 = normrnd(x(2), x(2) / 10);
    Frnd(1:12, 1) = 0;
    Frnd(4) = normrnd(F(4), abs(F(4)) / 10);

    %% Displacement and Stress
    [l_e, Q, stress] = TenBarAnalysis([x1, x2], l, E, Frnd);
    stress = abs(stress);

    % abs(stress(i)) * pi * x1 ^ 2 - pi ^ 3 * E * x1 ^ 4 / (4 * l_e ^ 2) <= 0
    g(i, 1:6) = pi * x1 * x1 * (stress(1:6) - Pf * x1 * x1 * l_e(1:6).^-2);
    % abs(stress(i)) * pi * x2 ^ 2 - pi ^ 3 * E * x2 ^ 4 / (4 * l_e ^ 2) <= 0
    g(i, 7:10) = pi * x2 * x2 * (stress(7:10) - Pf * x2 * x2 * l_e(7:10).^-2);
    % abs(stress(i)) - sigma_y <= 0
    g(i, 11:20) = stress(1:10) - sigma_y;
    % delta2 - 0.02 <= 0
    g(i, 21) = hypot(Q(3), Q(4)) - 0.02;
end

%% Inequality Constraints
C(1:6) = Pr(g(:, 1:6) > 0) - 0.0013;
C(7:10) = Pr(g(:, 7:10) > 0) - 0.0013;
C(11:20) = Pr(g(:, 11:20) > 0) - 0.0013;
C(21) = Pr(g(:, 21) > 0) - 0.0013;

%% Equality Constraints
Ceq = [];
end
