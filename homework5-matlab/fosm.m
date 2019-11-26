function [c, ceq] = fosm(x)
sg_2 = 0.3 * 0.3;
mu_g(1) = 20 - x(1)^2 * x(2);
mu_g(2) = 1 - (x(1) + x(2) - 5)^2 / 30 - (x(1) - x(2) - 12)^2 / 120;
mu_g(3) = x(1)^2 + 8 * x(2) - 75;

%% g1
% -2 * x(1) * x(2)
% -x(1)^2
sigma_g(1) = sqrt((-2 * x(1) * x(2))^2 * sg_2 + (-x(1)^2)^2 * sg_2);

%% g2
% 8 / 15 - x(2) / 20 - x(1) / 12
% 2 / 15 - x(2) / 12 - x(1) / 20
sigma_g(2) = sqrt((8 / 15 - x(2) / 20 - x(1) / 12)^2 * sg_2 + (2 / 15 - x(2) / 12 - x(1) / 20)^2 * sg_2);

%% g3
% 2 * x(1)
% 8
sigma_g(3) = sqrt((2 * x(1))^2 * sg_2 + 8 * 8 * sg_2);

%% Inequality Constraints
c(1:3) = 0;
for i = 1:3
    c(i) = 1 - normcdf(-mu_g(i) / sigma_g(i)) - 0.0013;
end

%% Equality Constraints
ceq = [];

end
