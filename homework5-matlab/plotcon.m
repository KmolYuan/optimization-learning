%% Clean
clc; clear; close all; tic;

%% Functions
g1 = @(x1, x2) 20 - x1^2 * x2;
g2 = @(x1, x2) 1 - (x1 + x2 - 5)^2 / 30 - (x1 - x2 - 12)^2 / 120;
g3 = @(x1, x2) x1^2 + 8 * x2 - 75;

%% Plot
x1 = linspace(0, 1, 1000);
x2 = linspace(0, 1, 1000);
[X1, X2] = meshgrid(x1, x2);
obj = X1 + X2;
figure;
contour(X1, X2, obj, 0:300, 'ShowText', 'on');
colorbar;
colormap jet;
hold on;
for r1 = 0:100
    for r2 = 0:100
        if g1(r1, r2) <= 0 || g2(r1, r2) <= 0 || g3(r1, r2) <= 0
            plot(r1, r2, 'x');
        end
    end
end
xlabel('r1');
ylabel('r2');
title("Objective function");
