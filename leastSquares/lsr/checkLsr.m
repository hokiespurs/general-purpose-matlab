function checkLsr
THRESH = 1e-8;
%% Check Unweighted Linear Least Squares
% y = ax^2+bx+c
x = [0 1 2 3 4]';
y = [5 1 7 13 24]';
modelfun = @(b,x) b(1)*x.^2 + b(2)*x + b(3); 
[betacoef,~,~,CovB,So2,~] = lsr(x,y,modelfun);

%computed values using matlab
A = [x(:).^2 x(:) ones(size(x(:)))];
L = y(:);
[matlab_betacoef, ~, matlab_So2, matlab_CovB] = lscov(A,L); %same results

%check to make sure function is working correctly
checkVals(betacoef,matlab_betacoef,THRESH);
checkVals(CovB,matlab_CovB,THRESH);
checkVals(So2,matlab_So2,THRESH);

%% Check Weighted Linear Least Squares
% y = ax^2+bx+c
x = [0 1 2 3 4]';
y = [5 1 7 13 24]';
W = [1 10 100 5 1];
modelfun = @(b,x) b(1)*x.^2 + b(2)*x + b(3); 
[betacoef,~,~,CovB,So2,~] = lsr(x,y,modelfun,'weights',W);

% computed values using matlab
A = [x(:).^2 x(:) ones(size(x(:)))];
L = y(:);
[matlab_betacoef, ~, matlab_So2, matlab_CovB] = lscov(A,L,W); %same results

checkVals(betacoef,matlab_betacoef,THRESH);
checkVals(CovB,matlab_CovB,THRESH);
checkVals(So2,matlab_So2,THRESH);

%% Check Weighted Linear Least Squares w/ Beta as Observation 
% y = ax^2+bx+c
x = [0 1 2 3 4]';
y = [5 1 7 13 24]';
Syy = diag([1 1.5 1.3 0.3 0.5]);
betaest = [2 -3 4];
Sbb = diag([0.1 0.1 1]);
modelfun = @(b,x) b(1)*x.^2 + b(2)*x + b(3); 
[betacoef,~,~,CovB,So2,~] = lsr(x,y,modelfun,betaest,'weights',Syy,'betaCoef0Cov',Sbb);

%computed values using matlab
A = [x(:).^2 x(:) ones(size(x(:)))];
L = y(:);
A(end+1:end+3,:)=eye(3);
L(end+1:end+3)=betaest';
W = blkdiag(Syy,Sbb);
[matlab_betacoef, ~, matlab_So2, matlab_CovB] = lscov(A,L,W); %same results

checkVals(betacoef,matlab_betacoef,THRESH);
checkVals(CovB,matlab_CovB,THRESH);
checkVals(So2,matlab_So2,THRESH);

%% Check Nonlinear
THRESHNLIN = 1e-5; % nlinfit exit criteria is 1e-8, lsr gives better residuals
% y = ae^(bx);
x = [0 1 2 3 4]';
y = [5 1 7 13 24]';
modelfun = @(b,x) b(1)*exp(b(2)*x);
beta0 = [1 1]';
[betacoef,V,~,CovB,So2,ErrorModelInfo2] = lsr(x,y,modelfun,beta0);

%computed values using matlab
[betacoef2,V2,~,CovB2,So22,ErrorModelInfo] = nlinfit(x,y,modelfun,beta0);
%check to make sure function is working correctly
checkVals(betacoef,betacoef2,THRESHNLIN);
checkVals(V,V2,THRESHNLIN);
checkVals(CovB,CovB2,THRESHNLIN);
checkVals(So2,So22,THRESHNLIN);

%% Check Weighted Nonlinear
% y = ae^(bx);
x = [0 1 2 3 4]';
y = [5 1 7 13 24]';
W = [1 10 100 5 1]';
modelfun = @(b,x) b(1)*exp(b(2)*x);
beta0 = [1 1]';
[betacoef,V,~,CovB,So2,~] = lsr(x,y,modelfun,beta0,'Weights',W);

%computed values using matlab
[betacoef2,V2,~,CovB2,So22,~] = nlinfit(x,y,modelfun,beta0,'weights',W);
%check to make sure function is working correctly
checkVals(betacoef,betacoef2,THRESHNLIN);
checkVals(V,V2,THRESHNLIN*10); %loose check thresh, lsr is actually better
checkVals(CovB,CovB2,THRESHNLIN*10);
checkVals(So2,So22,THRESHNLIN*10);

%% Check Robust Linear
x = (1:10)';
rng default; % For reproducibility
y = 10 - 2*x + randn(10,1);
y(10) = 0;
modelfun = @(b,x) b(1) + b(2)*x;
beta_ols = lsr(x,y,modelfun);
[betacoef,V,~,CovB,So2,~] = lsr(x,y,modelfun,'RobustWgtFun','bisquare');
[betacoef2, stats] = robustfit(x,y);

checkVals(betacoef,betacoef2,THRESHNLIN);
checkVals(V,-stats.resid,THRESHNLIN*10); %loose check thresh, lsr is actually better
checkVals(CovB./So2,stats.covb/stats.s^2,THRESHNLIN*10); %check unweighted Covariance
% checkVals(So2,So22,THRESHNLIN*10); 
%Unsure how to compute So2 with matlab

%% Check Robust Nonlinear
modelfun = @(b,x)(b(1)+b(2)*exp(-b(3)*x));

rng('default') % for reproducibility
b = [1;3;2];
x = exprnd(2,100,1);
y = modelfun(b,x) + normrnd(0,0.1,100,1);
beta0 = [2;2;2];
[betacoef,V,~,CovB,So2,~] = lsr(x,y,modelfun,beta0,'RobustWgtFun','bisquare');

opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';
[betacoef2,V2,~,CovB2,So22,~] = nlinfit(x,y,modelfun,beta0,opts);

checkVals(betacoef,betacoef2,THRESHNLIN);
checkVals(V,V2,THRESHNLIN*10); %loose check thresh, lsr is actually better
checkVals(CovB./So2,CovB2./So22,THRESHNLIN*10); %check unweighted Covariance
% checkVals(So2,So22,THRESHNLIN*10); 
%Unsure how to compute So2 with matlab

%% Check TLS
x = [10 20 60 40 85]';
y = [0 15 23 25 40]';
S = blkdiag([45 -30;-30 30],[20 -10;-10 70],[80 4;4 4],[40 -13;-13 60],[30 -25;-25 30]);
beta0 =[0.5; 0]; 
modelfun = @(b,x) b(1)*x(:,1)+b(2)-x(:,2);
[betacoef,V,~,CovB,So2,~] = lsr([x y],zeros(size(y)),modelfun,beta0,'Weights',S,'type','tls');

%solve TLS manually
Xo =[0.5; 0]; 
X = Xo;                      % initial unknowns guess

So2 = inf; dSo2 = 1; iter = 0;     % initialize for while loop

m = numel(x);                      % number of observations
n = numel(X);                      % number of unknowns
dof = m-n;                         % degrees of freedom
while dSo2>0 && iter<100 %loop until So2 increases or exceed 100 iteration
    B = kron(eye(numel(y)),[X(1) -1]); %B
    J = [x(:) ones(size(x(:)))];   % Jacobian
    K = -(X(1)*x(:) + X(2) - y(:));% K Matrix
    Weq = inv(B*S*B');
    dX = (J'*Weq*J)\J'*Weq*K;      % Loop Delta Estimate
    X = X + dX;                    % Loop Estimate
    Veq = K;                       % Residuals
    dSo2 = So2 - Veq'*Weq*Veq/dof; % Change in Reference Variance
    So2 = (Veq'*Weq*Veq)/dof;      % Reference Variance
    iter = iter + 1;
end

V = S * B' * Weq * Veq;           % Observation Residuals
Q = inv(J'*Weq*J);                % cofactor
Sx = So2 * Q;                     % covariance of unknowns
Sl = J * Sx * J';                 % covariance of observations
stdX = sqrt(diag(Sx));            % std of solved unknowns
Lhat = J * X;                     % predicted L values
RSo2 = sqrt(Veq'*Veq/m);          % RSo2
betacoef_manual = X;

checkVals(betacoef_manual,betacoef,1e-8);
%%
fprintf('All Tests Passed\n');

end
function checkVals(x,y,thresh)
dx = x-y;
isbad = any(abs(dx(:))>thresh);
if isbad
   error('Check Failed'); 
end
end