function [c, ceq] = nonlcon(x)
%% Variables
persistent stdx covx N Pr
if isempty(stdx)
    stdx = [0.3, 0.3];
    covx = [stdx(1)^2, 0; 0, stdx(2)^2];
    N = 1e6;
    Pr = @(a) sum(a, 'all') / N;
end
rnd = mvnrnd(x, covx, N);
X1 = rnd(:, 1);
X2 = rnd(:, 2);

%% Inequality Constraints
c(1) = Pr(20 - X1.^2 .* X2 > 0) - 0.0013;
c(2) = Pr(1 - (X1 + X2 - 5).^2 ./ 30 - (X1 - X2 - 12).^2 ./ 120 > 0) - 0.0013;
c(3) = Pr(X1.^2 + X2 .* 8 - 75 > 0) - 0.0013;

%% Equality Constraints
ceq = [];

end
