function [c, ceq] = nonlcon(x)
%% Variables
global N g1 g2 g3 covx
persistent Pr
if isempty(Pr)
    Pr = @(a) sum(a, 'all') / N;
end
rnd = mvnrnd(x, covx, N);
x1 = rnd(:, 1);
x2 = rnd(:, 2);

%% Inequality Constraints
c(1) = Pr(g1(x1, x2) > 0) - 0.0013;
c(2) = Pr(g2(x1, x2) > 0) - 0.0013;
c(3) = Pr(g3(x1, x2) > 0) - 0.0013;

%% Equality Constraints
ceq = [];

end
