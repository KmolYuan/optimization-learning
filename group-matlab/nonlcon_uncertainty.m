function [C, Ceq] = nonlcon_uncertainty(x)
global N F k t mu tao atm mu_sigma
persistent Pr
if isempty(Pr)
    Pr = @(a) sum(a) / N;
end
rnd = mvnrnd(x, (x * mu_sigma).^2 .* [1, 0, 0; 0, 1, 0; 0, 0, 1], N);
L = rnd(:, 1);
d1 = rnd(:, 2);
d2 = rnd(:, 3);
l = L - k;
v2 = (4 * F / pi - 4 * tao .* l - atm * d2.^2) ./ (32 * mu * l);

C(1) = Pr(d1 - t > 0) - 0.001;
C(2) = Pr(d2 - t > 0) - 0.001;
C(3) = Pr(k - L > 0) - 0.001;
C(4) = Pr(5 - v2 > 0) - 0.001;
C(5) = Pr(1e-5 - pi * d2.^2 .* v2 * 0.1 > 0) - 0.001;
C(6) = Pr(d2 - d1 > 0) - 0.001;

Ceq = [];
end
