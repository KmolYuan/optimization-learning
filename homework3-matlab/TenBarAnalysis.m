function [l_e, Q, stress] = TenBarAnalysis(r, length, E, F)
% TenBarAnalysis:
% Calculate stresses in each element by given spec. and force of the truss structure. 
% input: radius r (composed of r1, r2), length l, Young's modulus E, and force array F.
% Array F is composed of the external forces applied on each node.
% The elements in F are respectively F1x, F1y, F2x, F2y, F3x, F3y, ...

% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Element Table Construction
% Node Table
n = [2, 1; 2, 0; 1, 1; 1, 0; 0, 1; 0, 0] * length;

% Element Connectivity Table
ec = [3, 5; 1, 3; 4, 6; 2, 4; 3, 4; 1, 2; 4, 5; 3, 6; 2, 3; 1, 4];

% Element table
l_e(1:10, 1) = 0;
l(1:10, 1) = 0;
m(1:10, 1) = 0;
for i = 1:10
    l_e(i) = sqrt(sum((n(ec(i, 2), :) - n(ec(i, 1), :)).^2));
    l(i) = (n(ec(i, 2), 1) - n(ec(i, 1), 1)) / l_e(i);
    m(i) = (n(ec(i, 2), 2) - n(ec(i, 1), 2)) / l_e(i);
end

%% Displacement Calculation (DOF reduced)
A(1:10, 1) = 0;
A(1:6) = pi * r(1) * r(1);
A(7:10) = pi * r(2) * r(2);
K(1:12, 1:12) = 0;
for i = 1:10
    k_tmp(1:12, 1:12) = 0;
    k_small = E * A(i) / l_e(i) * [l(i); m(i)] * [l(i), m(i)];
    ec_i1 = ec(i, 1) * 2;
    ec_i2 = ec(i, 2) * 2;
    k_tmp(ec_i1 - 1:ec_i1, ec_i1 - 1:ec_i1) = k_small;
    k_tmp(ec_i2 - 1:ec_i2, ec_i2 - 1:ec_i2) = k_small;
    k_tmp(ec_i1 - 1:ec_i1, ec_i2 - 1:ec_i2) = -k_small;
    k_tmp(ec_i2 - 1:ec_i2, ec_i1 - 1:ec_i1) = -k_small;
    K = K + k_tmp;
end
Q = [K(1:8, 1:8)^-1 * F(1:8); zeros(4, 1)];

%% Stress Calculation
stress(1:10, 1) = 0;
for i = 1:10
    ec_i1 = ec(i, 1) * 2;
    ec_i2 = ec(i, 2) * 2;
    stress(i) = E / l_e(i) * [-l(i), -m(i), l(i), m(i)] * ...
        [Q(ec_i1 - 1); Q(ec_i1); Q(ec_i2 - 1); Q(ec_i2)];
end

%% Reaction Force on node 5 and node 6 (Unused)
% R = [zeros(8, 1); K(9:12, :) * Q];

end
