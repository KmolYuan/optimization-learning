function [C, Ceq] = fosm(x)
global F k t mu tao atm mu_sigma
L = x(1);
d1 = x(2);
d2 = x(3);
% a1=1^2
% a2=1^2
% a3=(-1)^2
% a4=((-2*d2*atm)/(32*(mu* (L - k))))^2 + ((-4*tao*(32*mu*(L-k))-32*mu*(4 * F / pi - 4 * tao .* (L - k) - atm * d2.^2))/(32 * mu * (L - k))^2)^2
% a5=((0.2*pi*d2^3)/(32*mu*(L-k)))^2 + ((-0.2*tao*pi*d2^2*(32 * mu * (L - k))-32*mu*pi * d2.^2 .* (4 * F / pi - 4 * tao .* (L - k) - atm * d2.^2))/(32 * mu * (L - k))^2)^2
% a6=(-1)^2
% a7=1^2 + (-1)^2

l = L - k;
v2 = (4 * F / pi - 4 * tao .* 12 .* l - atm * d2.^2) ./ (32 * mu * l);

mu_g(1) = d1 - t;
mu_g(2) = d2 - t;
mu_g(3) = k - L;
mu_g(4) = 5 - v2;
mu_g(5) = 1e-5 - pi * d2^2 * v2 * 0.1;
mu_g(6) = d2 - d1;

sig = (x * mu_sigma).^2;
sigma_g(1) = sig(2);
sigma_g(2) = sig(3);
sigma_g(3) = sig(1);
sigma_g(4) = (-2 * d2 * atm / (32 * mu * l))^2 * sig(3) +...
             ((-4 * tao * 32 * mu * l - 32 * mu * (4 * F / pi - 4 * tao * l - atm * d2^2)) / (32 * mu * l)^2)^2 * sig(1);
sigma_g(5) = (0.2 * pi * d2^3 / (32 * mu * l))^2 * sig(3) +...
             ((-0.2 * tao * pi * d2^2 * 32 * mu * l - 32 * mu * pi * d2^2 * (4 * F / pi - 4 * tao * 12 * l - atm * d2^2)) / (32 * mu * l)^2)^2 * sig(1);
sigma_g(6) = sig(2) + sig(3);
sigma_g = sqrt(sigma_g);

C = 1 - normcdf(-mu_g ./ sigma_g) - 0.001;
Ceq = [];
end
