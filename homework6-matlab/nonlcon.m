function [C, Ceq] = nonlcon(x)
% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Constants
global N l F E Pf sigma_y
persistent Pr
if isempty(Pr)
    Pr = @(a) sum(a, 2) / N;
end
rnd = mvnrnd(x, (x / 10).^2 .* [1, 0; 0, 1], N);
x1 = rnd(:, 1)';
x2 = rnd(:, 2)';

% Frnd(1:12, 1) = 0;
% Frnd(4, :) = normrnd(F(4), (F(4) / 10)^2);

%% Displacement and Stress
[l_e, Q, stress] = TenBarAnalysis([x1, x2], l, E, F);
stress = abs(stress);

%% Inequality Constraints
% abs(stress(i)) * pi * x1 ^ 2 - pi ^ 3 * E * x1 ^ 4 / (4 * l_e ^ 2) <= 0
C(1:6) = Pr(pi * x1.^2 .* (stress(1:6) - Pf * x1.^2 .* l_e(1:6).^-2) > 0) - 0.0013;
% abs(stress(i)) * pi * x2 ^ 2 - pi ^ 3 * E * x2 ^ 4 / (4 * l_e ^ 2) <= 0
C(7:10) = Pr(pi * x2.^2 .* (stress(7:10) - Pf * x2.^2 .* l_e(7:10).^-2) > 0) - 0.0013;
% abs(stress(i)) - sigma_y <= 0
C(11:20) = Pr(stress(1:10) - sigma_y > 0) - 0.0013;
% delta2 - 0.02 <= 0
C(21) = Pr(hypot(Q(3), Q(4)) - 0.02 > 0) - 0.0013;

%% Equality Constraints
Ceq = [];
end
