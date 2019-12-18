function [C, Ceq] = nonlcon(x)
% this is where ten-bar analysis file should be
% c has 21 element, 10 tensile stress, 10 buckling, 1 for displacement

% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Constants
global N l
persistent F E Pf sigma_y
if isempty(F)
    F(1:12, 1) = 0;  % unit: N
    F(4) = -1e7;
    E = 200e9;  % unit: Pa
    Pf = pi * pi * E / 4;  % P factor unit: N
    sigma_y = 250e6;  % unit: Pa
end
rnd = mvnrnd(x, covx, N);
x1 = rnd(:, 1);
x2 = rnd(:, 2);

%% Displacement and Stress
[l_e, Q, stress] = TenBarAnalysis(x, l, E, F);

%% Inequality Constraints
C(1:21) = 0;
stress = abs(stress);
% abs(stress(i)) * pi * x1 ^ 2 - pi ^ 3 * E * x1 ^ 4 / (4 * l_e ^ 2) <= 0
C(1:6) = pi * x1 * x1 * (stress(1:6) - x1 * x1 * Pf * l_e(1:6).^-2);
% abs(stress(i)) * pi * x2 ^ 2 - pi ^ 3 * E * x2 ^ 4 / (4 * l_e ^ 2) <= 0
C(7:10) = pi * x2 * x2 * (stress(7:10) - x2 * x2 * Pf * l_e(7:10).^-2);
% abs(stress(i)) - sigma_y <= 0
C(11:20) = stress(1:10) - sigma_y;
% delta2 - 0.02 <= 0
C(21) = hypot(Q(3), Q(4)) - 0.02;

%% Disabled Inequality Constraint
global disable
if disable ~= 0
    C(disable) = [];
end

%% Equality Constraints
Ceq = [];

end
