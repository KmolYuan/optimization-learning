function [c, ceq] = fosm(x)
global g1 g2 g3
persistent sg_2 g1p g2p g3p
if isempty(sg_2)
    sg_2 = 0.3 * 0.3;
    g1p = [diff(g1, sym('x1')), diff(g1, sym('x2'))];
    g2p = [diff(g2, sym('x1')), diff(g2, sym('x2'))];
    g3p = [diff(g3, sym('x1')), diff(g3, sym('x2'))];
end
Sub = @(func) double(subs(func, [sym('x1'), sym('x2')], [x(1), x(2)]));
sigma = @(patial) sqrt(Sub(patial(1))^2 * sg_2 + Sub(patial(2))^2 * sg_2);

mu_g(1) = g1(x(1), x(2));
mu_g(2) = g2(x(1), x(2));
mu_g(3) = g3(x(1), x(2));

sigma_g(1) = sigma(g1p);
sigma_g(2) = sigma(g2p);
sigma_g(3) = sigma(g3p);

%% Inequality Constraints
c(1:3) = 1 - normcdf(-mu_g(1:3) ./ sigma_g(1:3)) - 0.0013;

%% Equality Constraints
ceq = [];

end
