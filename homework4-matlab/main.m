clear; clc;

F(1:12, 1) = 0;
F(4) = -1e7;

n = 1e5;
f(1:n, 1:4) = 0;
failed = 0;
for i = 1:n
    r(1) = normrnd(0.2, 0.005);
    r(2) = normrnd(0.3, 0.005);
    E = normrnd(200, 5) * 1e9;
    Y = normrnd(250, 2) * 1e6;
    [l_e, ~, stress] = TenBarAnalysis(r, 9.14, E, F);
    stress = abs(stress);
    g1 = pi * r(1) * r(1) * (stress(1) - r(1) * r(1) * pi * pi * E / 4 * l_e(1)^-2);
    g2 = stress(1) - Y;
    if g1 > 0 || g2 > 0
        failed = failed + 1;
    end
    f(i, 1) = stress(5);
    f(i, 2) = stress(6);
    f(i, 3) = stress(1);
    f(i, 4) = Y;
end
figure;
histogram(f(:, 1), 10, 'FaceColor', 'red');
hold on;
histogram(f(:, 2), 10, 'FaceColor', 'green');
fprintf('failed prob: %f\n', failed / n);
figure;
histogram(f(:, 3), 10, 'FaceColor', 'yellow');
hold on;
histogram(f(:, 4), 10, 'FaceColor', 'blue');
