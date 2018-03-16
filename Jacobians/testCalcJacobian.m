%% Test calcJacobian
% Constants
x = [1 2 4];

%%
syms y x1 x2 x3
f = sin(x1) * exp(x2) * x3*x3;
fun = @(x) sin(x(1)) * exp(x(2)) * x(3)*x(3);

syms trueJ
trueJeqn(1) = diff(f,x1);
trueJeqn(2) = diff(f,x2);
trueJeqn(3) = diff(f,x3);

trueJfun = symfun(trueJeqn,[x1 x2 x3]);

trueY = fun(x);
trueJ = eval(trueJfun(x(1),x(2),x(3)));

[calcJ1, calcY1] = calcJacobian(fun,x); % Default: Complex Step Diff
[calcJ2, calcY2] = calcJacobian(fun,x,'method','cd'); % Default: Central Difference

fprintf(' Method Errors\n');
fprintf(' %20s | %10g | %10g | %10g |\n','Complex Step Diff',calcJ1-trueJ);
fprintf(' %20s | %10g | %10g | %10g |\n','Central Difference',calcJ2-trueJ);