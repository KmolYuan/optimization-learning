function [C, Ceq] = nonlcon(x)
% this is where ten-bar analysis file should be
% c has 21 element, 10 tensile stress, 10 buckling, 1 for displacement

%% Constants
persistent vf F E l sigma_y
if isempty(vf)
    vf = 4;  % vector index
    F(1:12, 1) = 0;  % unit: N
    F(vf) = -1e7;
    E = 200e9;  % unit: Pa
    l = 9.14;  % unit: m
    sigma_y = 250e6;  % unit: Pa
end

%% Stress
[Q, stress] = TenBarAnalysis(x, l, E, F);

%% Inequality Constraints
C(1:21) = 0;
% F(i) - pi ^ 3 * E * x(1) ^ 2 / (4 * l ^ 2) <= 0
for i = 1:6
    C(i) = F(i) - pi * pi * pi * E * x(1) * x(1) / (4 * l * l);
end
% F(i) - pi ^ 3 * E * x(2) ^ 2 / (4 * (sqrt(2) * l)^2) <= 0
for i = 7:10
    C(i) = F(i) - pi * pi * pi * E * x(2) * x(2) / (4 * 2 * l * l);
end
% stress(i) - sigma_y <= 0
for i = 1:10
    C(i + 10) = stress(i) - sigma_y;
end
% delta2 - 2 <= 0
C(21) = Q(vf) - 2;

%% Equality Constraints
Ceq = [];

end
