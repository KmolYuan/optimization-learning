function [c, ceq] = fosm(x)
syms x1 x2
persistent g1 g2 g3 g1p1 g1p2 g2p1 g2p2 g3p1 g3p2
if isempty(g1)
    g1 = @(x1, x2) 20 - x1^2 * x2;
    g2 = @(x1, x2) 1 - (x1 + x2 - 5)^2 / 30 - (x1 - x2 - 12)^2 / 120;
    g3 = @(x1, x2) x1^2 + 8 * x2 - 75;
    g1p1 = diff(g1, x1);
    g1p2 = diff(g1, x2);
    g2p1 = diff(g2, x1);
    g2p2 = diff(g2, x2);
    g3p1 = diff(g3, x1);
    g3p2 = diff(g3, x2);
end

sg_2 = 0.3 * 0.3;
mu_g(1) = g1(x(1), x(2));
mu_g(2) = g2(x(1), x(2));
mu_g(3) = g3(x(1), x(2));

%% g1
% -2 * x(1) * x(2)
% -x(1)^2
sigma_g(1) = sqrt(subs(g1p1, [x1, x2], [x(1), x(2)])^2 * sg_2 + (-x(1)^2)^2 * sg_2);

%% g2
% 8 / 15 - x(2) / 20 - x(1) / 12
% 2 / 15 - x(2) / 12 - x(1) / 20
sigma_g(2) = sqrt((8 / 15 - x(2) / 20 - x(1) / 12)^2 * sg_2 + (2 / 15 - x(2) / 12 - x(1) / 20)^2 * sg_2);

%% g3
% 2 * x(1)
% 8
sigma_g(3) = sqrt((2 * x(1))^2 * sg_2 + 8^2 * sg_2);

%% Inequality Constraints
c(1:3) = 1 - normcdf(-mu_g(1:3) ./ sigma_g(1:3)) - 0.0013;

%% Equality Constraints
ceq = [];

end
