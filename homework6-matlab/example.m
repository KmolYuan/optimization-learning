function [g, h] = example(r)
global l F E sigma_y
r1 = r(1);
r2 = r(2);
F4 = -1e7;
delta_r1 = 0.1 * r1;
delta_r2 = 0.1 * r2;
delta_F4 = 0.1 * F4;

    function [length_e, Q, stress, r_d] = FEA(x, f4)
        F_ = F;
        F_(4) = f4;
        [length_e, Q, stress] = TenBarAnalysis(x, l, E, F_);
        stress = abs(stress);
        r_d(1:6) = x(1);
        r_d(7:10) = x(2);
    end

dt = 1e-4;

[length_e, Q, stress, r_d] = FEA(r, F4);
dis_max = 0.02;
I = pi / 4 * r_d.^4;
Fn = pi * r.^2 .* stress;

r1_r1 = r1 + dt;
r_r1 = [r1_r1, r2];
[length_e_r1, Q_r1, stress_r1, r_d_r1] = FEA(r_r1, F4);
I_r1 = pi / 4 * r_d_r1.^4;
Fn_r1 = pi * r_r1.^2 .* stress;

r2_r2 = r2 + dt;
r_r2 = [r1, r2_r2];
[length_e_r2, Q_r2, stress_r2, r_d_r2] = FEA(r_r2, F4);
I_r2 = pi / 4 * r_d_r2.^4;
Fn_r2 = pi * r_r2.^2 .* stress;

r2_F4 = r2 + dt;
[length_e_F4, Q_F4, stress_F4, r_d_F4] = FEA(r, r2_F4);
I_F4 = pi / 4 * r_d_F4.^4;
Fn_F4 = pi * r.^2 .* stress;

g_1 = zeros(10, 1);
mu_1 = zeros(10, 1);
mu_1_r1 = zeros(10, 1);
mu_1_r2 = zeros(10, 1);
mu_1_F4 = zeros(10, 1);
a1_1 = zeros(10, 1);
a2_1 = zeros(10, 1);
a3_1 = zeros(10, 1);
sigma_1 = zeros(10, 1);

g_2 = zeros(10, 1);
mu_2 = zeros(10, 1);
mu_2_r1 = zeros(10, 1);
mu_2_r2 = zeros(10, 1);
mu_2_F4 = zeros(10, 1);
a1_2 = zeros(10, 1);
a2_2 = zeros(10, 1);
a3_2 = zeros(10, 1);
sigma_2 = zeros(10, 1);

for k = 1:10
    mu_1(k) = -Fn(k) - (pi^2 * E .* I(k) ./ length_e(k).^2);
    mu_1_r1(k) = -Fn_r1(k) - (pi^2 * E .* I_r1(k) ./ length_e_r1(k).^2);
    mu_1_r2(k) = -Fn_r2(k) - (pi^2 * E .* I_r2(k) ./ length_e_r2(k).^2);
    mu_1_F4(k) = -Fn_F4(k) - (pi^2 * E .* I_F4(k) ./ length_e_F4(k).^2);
    a1_1(k) = (mu_1_r1(k) - mu_1(k)) / dt;
    a2_1(k) = (mu_1_r2(k) - mu_1(k)) / dt;
    a3_1(k) = (mu_1_F4(k) - mu_1(k)) / dt;
    
    sigma_1(k) = sqrt(a1_1(k)^2 * delta_r1^2 +...
                      a2_1(k)^2 * delta_r2^2 +...
                      a3_1(k)^2 * delta_F4^2);
    g_1(k) = 1 - normcdf(-mu_1(k) / sigma_1(k)) - 0.01;

    mu_2(k) = stress(k) - sigma_y;
    mu_2_r1(k) = stress_r1(k) - sigma_y;
    mu_2_r2(k) = stress_r2(k) - sigma_y;
    mu_2_F4(k) = stress_F4(k) - sigma_y;
    a1_2(k) = (mu_2_r1(k) - mu_2(k)) / dt;
    a2_2(k) = (mu_2_r2(k) - mu_2(k)) / dt;
    a3_2(k) = (mu_2_F4(k) - mu_2(k)) / dt;

    sigma_2(k) = sqrt(a1_2(k)^2 * delta_r1^2 +...
                      a2_2(k)^2 * delta_r2^2 +...
                      a3_2(k)^2 * delta_F4^2);
    g_2(k) = 1 - normcdf(-mu_2(k) / sigma_2(k)) - 0.01;
end
mu_3 = Q(3)^2 + Q(4)^2 - dis_max^2;
mu_3_r1 = Q_r1(3)^2 + Q_r1(4)^2 - dis_max^2;
mu_3_r2 = Q_r2(3)^2 + Q_r2(4)^2 - dis_max^2;
mu_3_F4 = Q_F4(3)^2 + Q_F4(4)^2 - dis_max^2;
a1_3 = (mu_3_r1 - mu_3) / dt;
a2_3 = (mu_3_r2 - mu_3) / dt;
a3_3 = (mu_3_F4 - mu_3) / dt;
sigma_3 = sqrt(a1_3^2 * delta_r1^2 +...
               a2_3^2 * delta_r2^2 +...
               a3_3^2 * delta_F4^2);
g_3 = 1 - normcdf(-mu_3 / sigma_3) - 0.01;
g = [g_1', g_2', g_3'];
h = [];
end
