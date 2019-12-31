function is_feasible(x)
[C, ~] = nonlcon(x);
if all(C <= 1e-6)
    fprintf('Feasible\n');
else
    fprintf('Infeasible\n');
end
end
