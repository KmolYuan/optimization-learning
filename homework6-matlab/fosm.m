function [C, Ceq] = fosm(x)
% Class: ME7129 Optimization in Engineering, National Taiwan University.
% Student: Yuan Chang

%% Constants
global l F E Pf sigma_y
persistent dx
if isempty(dx)
    dx = 1e-6;
end

    function [l_e, Q, stress] = FEA(x, f4)
        Fn = F;
        Fn(4) = f4;
        [l_e, Q, stress] = TenBarAnalysis(x, l, E, Fn);
        stress = abs(stress);
    end

    function c = g1(x, f4)
        % Constraint 1-6
        [l_e, ~, stress] = FEA(x, f4);
        c = pi * x(1) * x(1) * (stress(1:6) - x(1) * x(1) * Pf * l_e(1:6).^-2);
    end

    function c = g2(x, f4)
        % Constraint 7-10
        [l_e, ~, stress] = FEA(x, f4);
        c = pi * x(2) * x(2) * (stress(7:10) - x(2) * x(2) * Pf * l_e(7:10).^-2);
    end

    function c = g3(x, f4)
        % Constraint 11-20
        [~, ~, stress] = FEA(x, f4);
        c = stress(1:10) - sigma_y;
    end

    function c = g4(x, f4)
        % Constraint 21
        [~, Q, ~] = FEA(x, f4);
        c = Q(3)^2 + Q(4)^2 - 0.02^2;
    end

%% Inequality Constraints
sig = (x / 10).^2;
sig(3) = (F(4) / 10)^2;
patial = @(g, px, f4) (g(px, f4) - g(x, F(4))) / dx;
sigma_f = @(g) sqrt(patial(g, [x(1) + dx, x(2)], F(4)).^2 * sig(1) +...
                    patial(g, [x(1), x(2) + dx], F(4)).^2 * sig(2) +...
                    patial(g, x, F(4) + dx).^2 * sig(3));
mu_g(1:6) = g1(x, F(4));
mu_g(7:10) = g2(x, F(4));
mu_g(11:20) = g3(x, F(4));
mu_g(21) = g4(x, F(4));
sigma_g(1:6) = sigma_f(@g1);
sigma_g(7:10) = sigma_f(@g2);
sigma_g(11:20) = sigma_f(@g3);
sigma_g(21) = sigma_f(@g4);
C = 1 - normcdf(-mu_g ./ sigma_g) - 0.001;

%% Equality Constraints
Ceq = [];
end
