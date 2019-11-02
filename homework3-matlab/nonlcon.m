function [C, Ceq] = nonlcon(x)
% this is where ten-bar analysis file should be
% c has 21 element, 10 tensile stress, 10 buckling, 1 for displacement

% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Constants
persistent vf F E l Pf sigma_y
if isempty(vf)
    vf = 4;  % vector index
    F(1:12, 1) = 0;  % unit: N
    F(vf) = -1e7;
    E = 200e9;  % unit: Pa
    l = 9.14;  % unit: m
    Pf = pi * pi * pi * E / (8 * l * l);  % P factor unit: N
    sigma_y = 250e6;  % unit: Pa
end

%% Stress
[Q, stress] = TenBarAnalysis(x, l, E, F);

%% Inequality Constraints
C(1:21) = 0;
P1 = x(1) * x(1) * Pf * 2;
P2 = x(2) * x(2) * Pf;
% F(i) - pi ^ 3 * E * x(1) ^ 2 / (4 * l ^ 2) <= 0
C(1:6) = F(1:6) - P1;
% F(i) - pi ^ 3 * E * x(2) ^ 2 / (4 * (sqrt(2) * l)^2) <= 0
C(7:10) = F(7:10) - P2;
% stress(i) - sigma_y <= 0
C(11:20) = stress(1:10) - sigma_y;
% delta2 - 2 <= 0
C(21) = Q(vf) - 2;

%% Disabled Inequality Constraint
global disable
if disable ~= 0
    C(disable) = [];
end

%% Equality Constraints
Ceq = [];

end
