function [C, Ceq] = nonlcon(x)
global F k t mu tao atm
L = x(1);
d1 = x(2);
d2 = x(3);
l = L - k;
v2 = (4 * F / pi - 4 * tao * l - atm * d2^2) / (32 * mu * l);

C(1) = d1 - t;
C(2) = d2 - t;
C(3) = k - L;
C(4) = 5 - v2;
C(5) = 1e-5 - pi * d2^2 * v2 * 0.1;
C(6) = d2 - d1;
Ceq = [];
end
