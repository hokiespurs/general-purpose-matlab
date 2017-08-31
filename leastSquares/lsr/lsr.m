function [betacoef,V,J,CovB,So2,modelinfo] = lsr(x,y,modelfun,varargin)
% LSR Least Squares Regression For Linear, Nonlinear, Robust, and Total LSR
%   LSR(X,Y,MODELFUN,VARARGIN) performs a least squares regression to
%   estimate the beta coefficients.  The Jacobian and partial derivatives
%   are computed using finite differencing.  This function mimics the
%   performance on NLINFIT without the reliance on the Statistics and 
%   Machine Learning Toolbox.  This function also adds functionality to:
%    o perform linear least squares
%    o detect linearity from modelfun using finite differencing Hessian
%    o perform total least squares
%    o input analytical jacobians
%    o automatically perform chi2 goodness of fit test
%    o disable automatic covariance scaling
%    o add an estimate of the beta coefficients as observation equations
% 
%   * See 'doc/doclsr.pdf' for more a more detailed description   
%   * See 'exampleLsr.m' for more examples
% 
% Inputs:
%   - x              : Predictor variables
%   - y              : Response values
%   - modelfun       : Model function handle @modelfun(betacoef,x)
%   - betacoef0      : Initial regression coefficient values
%
% Optional Parameters:
%   - 'betacoef0'       : Initial regression coefficient values
%   - 'type'            : Type of Regression
%   - 'weights'         : Vector (weights) or Covariance matrix
%   - 'betaCoef0Cov'    : Covariance of beta0 coefficient values
%   - 'JacobianYB'      : Function @(b,x) for Jacobian wrt betacoef
%   - 'JacobianYX'      : Function @(b,x) for Jacobian wrt x
%   - 'scaleCov'        : boolean (default:1) to scale covariance matrix 
%   - 'chi2alpha'       : Alpha values for significance 
%   - 'RobustWgtFun'    : Robust Weight Function
%   - 'Tune'            : Robust Weight Tuning Function
%   - 'RobustThresh'    : Threshold for Robust Iterations
%   - 'RobustMaxIter'   : Maximum iterations in Robust Least Squares
%   - 'maxiter'         : Maximum iterations for Nonlinear
%   - 'verbose'         : True/False print verbose output to screen
%   - 'DerivStep'       : Difference for numerical Jacobian
%   - 'enforceValidCovB': Attempts to iteratively enforce a valid CovB
% 
% Outputs:
%   - betacoef    : Estimated regression coefficients
%   - V           : Residuals
%   - J           : Jacobian with respect to B of the final iteration
%   - CovB        : Estimated Variance Covariance Matrix
%   - So2         : Mean Squared Error (Computed Reference Variance)
%   - modelinfo   : Information about error model in structure
%
% Examples:
%   % Linear Regression
%   b = [2 1];
%   x = rand(10,1)*10;
%   ymxplusb = @(b,x) b(1)*x + b(2);
%   y = ymxplusb(b,x)+randn(10,1)*1;
%   betacoef = lsr(x,y,ymxplusb);
%   figure(1);clf;plot(x,y,'b.');hold on;plot([0 10],ymxplusb(b,[0 10]));
%
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 17-Mar-2017    
% Date Modified : 11-Jun-2017      
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%% Input Parsing/Checks
% Get constants from default parameters
narginchk(3,inf);
nObsEqns = numel(y);
% nObservations = size(x,1);
% nObsEqnPerObservation = nObsEqns/nObservations;
nPredictors = numel(x);
nBetacoef = calcNbetacoef(modelfun,x); %throws error if bad modelfun
ndof = nObsEqns - nBetacoef;

% default values
defaultBetaCoef0     = [];
defaultType          = [];
defaultWeights       = [];
defaultBetaCoef0Cov  = [];
defaultJacobianYB    = [];
defaultJacobianYX    = [];
defaultRobustWgtFun  = [];
defaultTune          = [];
defaultchi2alpha     = 0.05;
defaultScaleCov      = true;
defaultMaxIter       = 100;
defaultVerbose       = false;
defaultDerivstep     = eps^(1/3);
defaultRobustMaxIter = 100;
defaultRobustThresh  = 1e-8;
defaultEnforceCovB   = false;

% expected Values
expectedType = {'ols','wls','gls','lin','linear',...
                'nlin','nonlinear',...
                'total','tls',...
                'robust',... %still do hessian to determine linearity
                'robustlinear',...
                'robustnonlinear'};

% Input checkFunctions
checkX             = @(X) isnumeric(X) && all(~isnan(X(:)));
checkY             = @(X) isnumeric(X) && size(X,2)==1 && all(~isnan(X(:)));
checkModelfun      = @(X) isa(X,'function_handle');
checkBetaCoef0     = @(X) isnumeric(X) && isvector(X) && numel(X)==nBetacoef;
checkType          = @(X) any(validatestring(X, expectedType));
checkWeights       = @(X) longWeightCheck(X,nObsEqns,nPredictors); 
checkBetaCoef0Cov  = @(X) isSquare(X,nBetacoef);
checkJacobianYB    = @(X) isa(X,'function_handle');
checkJacobianYX    = @(X) isa(X,'function_handle'); 
checkRobustWgtFun  = @(X) checkRobust(X,y); 
checkTune          = @(X) isnumeric(X);
checkChi2alpha     = @(X) isnumeric(X) && isscalar(X) && X>0 && X<1;
checkScaleCov      = @(X) islogical(X);
checkMaxIter       = @(X) mod(X,1) == 0 && X>0;
checkVerbose       = @(X) islogical(X);
checkDerivStep     = @(X) isnumeric(X) && isscalar(X) && X>0;
checkRobustMaxIter = @(X) mod(X,1) == 0 && X>0;
checkRobustThresh  = @(X) isnumeric(X) && X>0;
checkEnforceCovB   = @(X) islogical(X);

% parse inputs
p = inputParser;

addRequired(p,'x'                                 ,checkX);
addRequired(p,'y'                                 ,checkY);
addRequired(p,'modelfun'                          ,checkModelfun);

addOptional(p,'betaCoef0'    ,defaultBetaCoef0    ,checkBetaCoef0);

addParameter(p,'type'            ,defaultType         ,checkType);
addParameter(p,'weights'         ,defaultWeights      ,checkWeights);
addParameter(p,'betaCoef0Cov'    ,defaultBetaCoef0Cov ,checkBetaCoef0Cov);
addParameter(p,'JacobianYB'      ,defaultJacobianYB   ,checkJacobianYB);
addParameter(p,'JacobianYX'      ,defaultJacobianYX   ,checkJacobianYX);
addParameter(p,'RobustWgtFun'    ,defaultRobustWgtFun ,checkRobustWgtFun);
addParameter(p,'Tune'            ,defaultTune         ,checkTune);
addParameter(p,'chi2alpha'       ,defaultchi2alpha    ,checkChi2alpha);
addParameter(p,'scaleCov'        ,defaultScaleCov     ,checkScaleCov);
addParameter(p,'maxiter'         ,defaultMaxIter      ,checkMaxIter);
addParameter(p,'verbose'         ,defaultVerbose      ,checkVerbose);
addParameter(p,'DerivStep'       ,defaultDerivstep    ,checkDerivStep);
addParameter(p,'RobustMaxIter'   ,defaultRobustMaxIter,checkRobustMaxIter);
addParameter(p,'RobustThresh'    ,defaultRobustThresh ,checkRobustThresh);
addParameter(p,'enforceValidCovB',defaultEnforceCovB  ,checkEnforceCovB);

parse(p,x,y,modelfun,varargin{:});

% get variables out of structure
betaCoef0 = p.Results.betaCoef0(:);
maxiter = p.Results.maxiter;
isverbose = p.Results.verbose;
scalecov = p.Results.scaleCov;
chi2alpha = p.Results.chi2alpha;
[robustTune, robustWgtFun] = getRobust(p.Results.RobustWgtFun, p.Results.Tune);
robustMaxIter = p.Results.RobustMaxIter;
robustThresh  = p.Results.RobustThresh;

betacoef0cov = p.Results.betaCoef0Cov;
if isempty(p.Results.JacobianYB)
    JybFunction = @(b,x) calcJYB(modelfun,b,x,p.Results.DerivStep);
else
    JybFunction = p.Results.JacobianYB;
end
if isempty(p.Results.JacobianYX)
    JyxFunction = @(b,x) calcJYX(modelfun,b,x,p.Results.DerivStep);
else
    JyxFunction = p.Results.JacobianYX;
end
%% Determine least squares type and do some checks of input values
lstype = getlstype(p.Results.type,modelfun,betaCoef0,x,p);

dolstypechecks(lstype,p);

[Sx, isinputcovariance] = getCovariance(lstype,p.Results.weights,x,y);

if isverbose
    printPreSummary(lstype,p,nBetacoef);
end

%% Make function handle for Specific Least Squares Function Depending
switch lstype
    case 1
        lsrfun = @(x,y) lsrlin(x,y,modelfun,betaCoef0,Sx,betacoef0cov,...
            JybFunction,scalecov,isverbose);
        lstypename = 'linear';
    case 2
        lsrfun = @(x,y) lsrnlin(x,y,modelfun,betaCoef0,Sx,betacoef0cov,...
            JybFunction,[],scalecov,maxiter,isverbose);
        lstypename = 'nonlinear';

    case 3
        lsrfun = @(x,y) lsrrobustlin(x,y,modelfun,betaCoef0,betacoef0cov,...
            JybFunction,scalecov,isverbose,robustWgtFun,robustTune,robustMaxIter,robustThresh);
        lstypename = 'robust linear';

    case 4
        lsrfun = @(x,y) lsrrobustnlin(x,y,modelfun,betaCoef0,...
            JybFunction,robustWgtFun,robustTune,maxiter,isverbose,robustMaxIter,robustThresh);
        lstypename = 'robust nonlinear';

    case 5
        lsrfun = @(x,y) lsrnlin(x,y,modelfun,betaCoef0,Sx,betacoef0cov,...
            JybFunction,JyxFunction,scalecov,maxiter,isverbose);
        lstypename = 'total';

end

%% Compute Least Squares
[betacoef,V,J,CovB,So2,modelinfo] = lsrfun(x,y);
modelinfo.type = lstypename;
if p.Results.enforceValidCovB
    CovB = enforceCovariance(CovB);
end
%% Do Chi2 Test if covariance and linear/nonlinear
if isinputcovariance  
    chi2 = ndof * So2;
%     chi2low  = chi2inv(chi2alpha/2  , ndof); %REMOVE TOOLBOX DEPENDENCY
%     chi2high = chi2inv(1-chi2alpha/2, ndof); %REMOVE TOOLBOX DEPENDENCY
    chi2low  = gammaincinv(chi2alpha/2  , ndof/2)*2;
    chi2high = gammaincinv(1-chi2alpha/2, ndof/2)*2;

    if chi2low<chi2 && chi2<chi2high
       modelinfo.chi2.pass = true;
       passfailstr = 'PASS';
    else
        modelinfo.chi2.pass = false;
        passfailstr = 'FAIL';
    end
    modelinfo.chi2.alpha          = chi2alpha;
    modelinfo.chi2.calculatedchi2 = chi2;
    modelinfo.chi2.chi2low        = chi2low;
    modelinfo.chi2.chi2high       = chi2high;
    modelinfo.chi2.calculatedSo2  = chi2/ndof;
    modelinfo.chi2.So2low         = chi2low/ndof;
    modelinfo.chi2.So2high        = chi2high/ndof;
    if isverbose
        fprintf('\n\tCHI^2 GOODNESS OF FIT TEST (Significance=%.2f, dof=%.0f, So2=%.3f)\n',chi2alpha,ndof,So2);
        fprintf('\t  Ho %.3f == 1\n',So2);
        fprintf('\t  H1 %.3f =/= 1\n',So2);
        fprintf('\t  Statistical Test : (%.3f < %.3f < %.3f)\n',chi2low/ndof,chi2/ndof,chi2high/ndof);
        if scalecov && modelinfo.chi2.pass % scale but it passed test 
            fprintf('\t  **%s**  * Test Passed, consider setting ''scalecov'' == false\n',passfailstr);
        elseif ~scalecov && ~modelinfo.chi2.pass % no scale but didnt pass
            fprintf('\t  **%s**  * Test Failed, consider setting ''scalecov'' == true\n',passfailstr);
        else
            fprintf('\t  **%s**  \n',passfailstr);
        end
    end
end
end

function printPreSummary(lstype,p,nBetacoef)
%% Print output to the screen summarizing least squares regression params
nObsEqns = numel(p.Results.y);
if ~isempty(p.Results.betaCoef0Cov)
    nObsEqns = nObsEqns + size(p.Results.betaCoef0Cov,1);
end
ndof = nObsEqns-nBetacoef; 
hline = repmat('-',1,50);
switch lstype
    case 1
        fprintf('%s\nLINEAR LEAST SQUARES\n%s\n',hline,hline);
    case 2
        fprintf('%s\nNONLINEAR LEAST SQUARES\n%s\n',hline,hline);
    case 3
        fprintf('%s\nROBUST LINEAR LEAST SQUARES\n%s\n',hline,hline);
    case 4
        fprintf('%s\nROBUST NONLINEAR LEAST SQUARES\n%s\n',hline,hline);
    case 5
        fprintf('%s\nTOTAL LEAST SQUARES\n%s\n',hline,hline);
end

fprintf('\t # of Observation Equations               : %.0f\n',nObsEqns);
fprintf('\t # of Observations                        : %.0f\n',size(p.Results.x,1));
fprintf('\t # of Predictor Variables Per Observation : %.0f\n',size(p.Results.x,2));
fprintf('\t # of Beta Coefficients                   : %.0f\n',nBetacoef);
fprintf('\t # of Degrees of Freedom                  : %.0f\n',ndof);

end

function [betacoef,V,J,CovB,So2,ErrorModelInfo] = lsrrobustlin(x,y,...
    modelfun,betaCoef0,betacoef0cov,JybFunction,scalecov,isverbose,...
    robustWgtFun,robustTune,robustMaxIter,robustThresh)
%% Calculate Robust Linear Least Squares
if isverbose
    n = calcNbetacoef(modelfun,x);  % number of unknowns
    fprintf('\niter :        So2        ');
    fprintf('         betacoef(%.0f)',1:n);
    fprintf('\n');
end
%initialize while loop
dSo2 = 1;
lastSo2 = inf;
iter = 0;

W = ones(numel(y),1);

while iter<robustMaxIter && abs(dSo2)>robustThresh
    Sx = spdiag(1./W);
    [betacoef,~,J,CovB,So2,ErrorModelInfo] = lsrlin(x,y,modelfun,...
    betaCoef0,Sx,betacoef0cov,JybFunction,scalecov,false);
    dSo2 = lastSo2-So2;
    lastSo2 = So2;
    iter = iter+1;
      
    V = modelfun(betacoef,x)-y; %unweighted V

    %leverage and hat in robust least squares according to matlab
    % Weights points low that are outliers in the x dimension
    % https://www.mathworks.com/help/stats/robustfit.html
    % https://www.mathworks.com/help/stats/hat-matrix-and-leverage.html
    H = J/(J.'*J)*J.'; %Hat Matrix
    h = diag(H); %leverage
    
    Vadj = V./sqrt(1-h);
    
    SigmaR = sigmaMedianEstimate(Vadj,size(J,2));
    
    Rnormalized = Vadj./(robustTune * SigmaR);
    W = robustWgtFun(Rnormalized);
    W(W<=eps)=eps;
    if isverbose
        fprintf('%3.0f : ',iter);
        fprintf('%20.10f', So2);
        fprintf('%20.10f', betacoef);
        fprintf('\n');
    end
end
CovB = So2 .* inv(J'*J); %unweighted covariance
% warning('When performing Robust Least Squares, So2 and CovB do not match the output from matlabs nlinfit and robustfit');

ErrorModelInfo.Robust.RobustWgtFun = robustWgtFun;
ErrorModelInfo.Robust.Tune = robustTune;
ErrorModelInfo.Robust.RobustMaxIter = robustMaxIter;
ErrorModelInfo.Robust.RobustThresh = robustThresh;
ErrorModelInfo.Robust.niter = iter;

end

function SigmaR = sigmaMedianEstimate(V,nX)
% estimate sigma using the median of the residuals
% numel(V)-nX = dof
Rsort = sort(abs(V));
    SigmaR = median(Rsort(max(1,nX):end)) / 0.6745;
    
    if SigmaR < 1e-6
        SigmaR = 1e-6;
    end
    
end

function [betacoef,V,J,CovB,So2,ErrorModelInfo] = lsrrobustnlin(x,y,modelfun,betaCoef0,...
            JybFunction,robustWgtFun,robustTune,maxiter,isverbose,robustMaxIter,robustThresh)
%% Calculate Robust Nonlinear Least Squares
scalecov = true;
JyxFunction = [];
betacoef0cov = [];

if isverbose
    n = calcNbetacoef(modelfun,x);  % number of unknowns
    fprintf('\niter :        So2        ');
    fprintf('         betacoef(%.0f)',1:n);
    fprintf('\n');
end
%initialize while loop
dSo2 = 1;
lastSo2 = inf;
iter = 0;
W = ones(numel(y),1);
while iter<robustMaxIter && abs(dSo2)>robustThresh
    Sx = spdiag(1./W);
    [betacoef,~,J,CovB,So2,ErrorModelInfo] = lsrnlin(x,y,modelfun,betaCoef0,Sx,betacoef0cov,...
            JybFunction,JyxFunction,scalecov,maxiter,false);
    dSo2 = lastSo2-So2;
    lastSo2 = So2;
    iter = iter+1;
      
    V = y - modelfun(betacoef,x); %unweighted V

    %leverage and hat in robust least squares according to matlab
    % Weights points low that are outliers in the x dimension
    % https://www.mathworks.com/help/stats/robustfit.html
    % https://www.mathworks.com/help/stats/hat-matrix-and-leverage.html
    H = J/(J.'*J)*J.'; %Hat Matrix
    h = diag(H); %leverage
    
    Vadj = V./sqrt(1-h);
    
    SigmaR = sigmaMedianEstimate(Vadj,size(J,2));
    
    Rnormalized = Vadj./(robustTune * SigmaR);
    W = robustWgtFun(Rnormalized);
    W(W<=eps)=eps;
    if isverbose
        fprintf('%3.0f : ',iter);
        fprintf('%20.10f', So2);
        fprintf('%20.10f', betacoef);
        fprintf('\n');
    end
end
CovB = So2 .* inv(J'*J); %unweighted covariance
% warning('When performing Robust Least Squares, So2 and CovB do not match the output from matlabs nlinfit and robustfit');
ErrorModelInfo.Robust.RobustWgtFun = robustWgtFun;
ErrorModelInfo.Robust.Tune = robustTune;
ErrorModelInfo.Robust.RobustMaxIter = robustMaxIter;
ErrorModelInfo.Robust.RobustThresh = robustThresh;
ErrorModelInfo.Robust.niter = iter;

end

function [betacoef,V,J,CovB,So2,ErrorModelInfo] = lsrnlin(x,y,modelfun,betaCoef0,Sx,betacoef0cov,...
            JybFunction,JyxFunction,scalecov,maxiter,isverbose)
%% Calculate Nonlinear and Total Least Squares
    m = numel(y);                   % number of observations
    if ~isempty(betacoef0cov)    % account for using beta0 as observations
       m = m + size(betacoef0cov,1); 
    end
    n = calcNbetacoef(modelfun,x);  % number of unknowns
    dof = m-n;                      % degrees of freedom

    if isempty(JyxFunction)
        istls = false;
    else
        istls = true;
    end

    if isverbose
        fprintf('\niter :        So2        ');
        fprintf('         betacoef(%.0f)',1:n);
        fprintf('\n');
    end

    %initialize while loop parameters
    So2 = inf;
    dSo2 = 1;
    iter = 0;
    betacoef = betaCoef0;                  % set first guess at unknowns
    while dSo2>0 && iter<maxiter %loop until So2 increases or exceed maxiter iterations
            J = JybFunction(betacoef,x);
            K = calcK(modelfun,betacoef,x,y);
            if istls
                B = JyxFunction(betacoef,x);
                W = inv(B*Sx*B');            %equivalent weight matrix
            else
                W = inv(Sx);
            end
            
            if ~isempty(betacoef0cov)
                if istls
                    [J,K,W,B]=addBetacoef0TLS(J,K,B,Sx,betaCoef0,betacoef0cov,betacoef);
                else
                    [J,K,W]=addBetacoef0Nlin(J,K,Sx,betaCoef0,betacoef0cov,betacoef);
                end
            end
        
        dbetacoef = (J'*W*J)\J'*W*K;       % Loop Delta Estimate
        betacoef = betacoef + dbetacoef;   % Loop Estimate
        V = K;                             % Residuals
        dSo2 = So2 - V'*W*V/dof;           % Change in Reference Variance
        So2 = (V'*W*V)/dof;                % Reference Variance
        iter = iter + 1;
        % print status to screen
        if isverbose
            fprintf('%3.0f : ',iter);
            fprintf('%20.10f', So2);
            fprintf('%20.10f', betacoef);
            fprintf('\n');
        end        
    end
    if istls
        if ~isempty(betacoef0cov)
            covX = blkdiag(Sx,betacoef0cov);
        else
            covX = Sx;
        end
       Vobs = covX * B' * W * V;
       ErrorModelInfo.Vobs = Vobs;
    end
    Q = inv(J'*W*J);              % cofactor
    if scalecov                   % option to not scale covariance
       CovB = So2 * Q; %#ok<MINV> So2 is a scalar
    else
       CovB = Q;
    end
    stdB = sqrt(diag(CovB));        % std of solved unknowns
    Lhat = J * betacoef;          % predicted L values
    RMSE = sqrt(V'*V/m);          % RMSE
    % handle output variables
    V = sqrt(W)*V; %report weighted residuals
    So2 = So2;

    ErrorModelInfo.m = m;
    ErrorModelInfo.n = n;
    ErrorModelInfo.dof = dof;
    ErrorModelInfo.niter = iter;
    ErrorModelInfo.betacoef = betacoef;
    ErrorModelInfo.V = V;
    ErrorModelInfo.R = V;
    ErrorModelInfo.So2 = So2;
    ErrorModelInfo.Q = Q;
    ErrorModelInfo.CovB = CovB;
    ErrorModelInfo.isCovBscaled = scalecov;
    ErrorModelInfo.stdB = stdB;
    ErrorModelInfo.r2 = NaN; %no r2 for nonlinear
    ErrorModelInfo.RMSE = RMSE;        
        
end

function [J,K,W,B]=addBetacoef0TLS(J,K,B,covX,betacoef0,betacoefcov,betacoef)
%adds beta coefficient 
Jadd = eye(numel(betacoef0));
J = [J; Jadd];

K = [K; betacoef0-betacoef];

B = blkdiag(B,-eye(numel(betacoef0)));

covX = blkdiag(covX,betacoefcov);

W = inv(B*covX*B');

end

function [J,K,W]=addBetacoef0Nlin(J,K,covY,betacoef0,betacoefcov,betacoef)
Jadd = eye(numel(betacoef0));
J = [J; Jadd];

K = [K; betacoef0-betacoef];

covY = blkdiag(covY,betacoefcov);

W = inv(covY);

end

function [betacoef,V,J,CovB,So2,ErrorModelInfo] = lsrlin(x,y,modelfun,...
    betaCoef0,Sx,betacoef0cov,JybFunction,scalecov,isverbose)
%% Calculate linear least squares
nBetacoef = calcNbetacoef(modelfun,x);
A = JybFunction(zeros(nBetacoef,1),x);
L = y;

if ~isempty(betacoef0cov) %add betacoef0 as observation equations
    L(end+1:end+nBetacoef)=betaCoef0;
    A = [A;eye(nBetacoef)];
    Sx = blkdiag(Sx,betacoef0cov);
end

%do least squares calculation
% W = inv(Sx);
m = numel(y);                   % number of observations
if ~isempty(betacoef0cov)    % account for using beta0 as observations
    m = m + size(betacoef0cov,1);
end
n = calcNbetacoef(modelfun,x);  % number of unknowns
dof = m-n;                      % degrees of freedom
X = (A'/Sx*A)\A'/Sx*L;          % unknowns (A'WA)^-1WL
V = A * X - L;                  % residuals
So2 = V'/Sx*V/dof;              % Reference Variance V'WV/dof
Q = inv(A'/Sx*A);               % cofactor
if scalecov                     % option to not scale covariance
   CovB = So2 * Q;%#ok<MINV> So2 is a scalar
else
   CovB = Q;
end
stdB = sqrt(diag(CovB));          % std of solved unknowns
Lhat = A * X;                   % predicted L values
r2 = var(Lhat)/var(L);          % V^2 Skill
RMSE = sqrt(V'*V/m);            % RMSE

%assemble output variables and structure
betacoef = X;
V = sqrt(inv(Sx))*V; %report weighted residuals
J = A;

ErrorModelInfo.m=m;
ErrorModelInfo.n=n;
ErrorModelInfo.dof=dof;
ErrorModelInfo.betacoef=X;
ErrorModelInfo.V=V;
ErrorModelInfo.R = V;
ErrorModelInfo.So2=So2;
ErrorModelInfo.Q=Q;
ErrorModelInfo.CovB=CovB;
ErrorModelInfo.isCovBscaled = scalecov;
ErrorModelInfo.stdB=stdB;
ErrorModelInfo.r2=r2;
ErrorModelInfo.RMSE=RMSE;         

% print info to screen if verbose
if isverbose
    fprintf('        So2        '); %
    fprintf('         betacoef(%.0f)',1:nBetacoef);
    fprintf('\n');
    fprintf('%20.10f', So2);
    fprintf('%20.10f', betacoef);
    fprintf('\n');
end
end

function dolstypechecks(lstype,p)
%% throw a bunch of errors/warnings depending on the parameters input
% see flowchart for summary of this
%determine input variables
indsused = true(numel(p.Parameters),1);
for i=1:numel(p.UsingDefaults)
    indunused = strcmp(p.UsingDefaults{i},p.Parameters);
    indsused(indunused)=false;
end
inputParams = p.Parameters(indsused);

switch lstype
    case 1 % linear
        requiredFields = {'x'}; %error would have been thrown earlier if bad
        illegalFields = {'JacobianYX','Tune','maxiter'};
        typename = 'linear';
    case 2 % nonlinear
        requiredFields = {'betaCoef0'};
        illegalFields = {'JacobianYX','Tune'};
        typename = 'nonlinear';
    case 3 % robust linear
        requiredFields = {'RobustWgtFun'}; %error would have been thrown earlier if bad
        illegalFields = {'weights','betaCoef0Cov',...
                         'JacobianYX','chi2alpha','scaleCov','maxiter'};
        typename = 'robust linear';
    case 4 % robust nonlinear
        requiredFields = {'betaCoef0','RobustWgtFun'};
        illegalFields = {'weights','betaCoef0Cov','JacobianYX',...
                         'chi2alpha','scaleCov'};
        typename = 'robust nonlinear';
    case 5 % total least squares
        requiredFields = {'betaCoef0'};
        illegalFields = {'Tune'};
        typename = 'total least squares';
end
for i=1:numel(requiredFields) %% loop through all parameters NOT input
    % throw errors
    if ~any(strcmp(requiredFields{i},inputParams))
        strerr = sprintf('%s,',requiredFields{:});
        error('Missing at least one of the required parametersfor %s: %s\n',...
            typename,strerr);
    end
end
for i=1:numel(illegalFields)
    if any(strcmp(illegalFields{i},inputParams))
        strerr = sprintf('%s,',illegalFields{:});
        error('Included at least one illegal parameter for %s: %s\n',...
            typename,strerr);
    end
end
%ensure the model is actually linear
if any(lstype == [1 3])
    nBetacoef = calcNbetacoef(p.Results.modelfun,p.Results.x);
    testbetacoef0 = zeros(nBetacoef,1);
    h = p.Results.DerivStep;
    isLinear = isModelLinear(p.Results.modelfun,testbetacoef0,p.Results.x,h);
    if ~isLinear
        if isempty(p.Results.type) %user didnt explicitly say what type
            error('betacoef0 must be input for a nonlinear model function');
        else
            warning('modelfun doesnt appear to be linear, nonlinear regression is highly recommended');
        end
    end
end
    % throw warnings
    [~, isinputcovariance] = getCovariance([],p.Results.weights,[],[]);
    if any(lstype == [1 2 5])
        if ~isinputcovariance && any(strcmp('chi2alpha',inputParams))
            warning('chi2alpha is meaningless without input covariance');
        elseif ~isinputcovariance && any(strcmp('betaCoef0Cov',inputParams))
            warning('betaCoef0Cov is meaningless without input covariance');
        end
    end
    if any(lstype == [1 3]) && ~any(strcmp('betaCoef0Cov',inputParams)) && any(strcmp('beta0',inputParams))
        warning('For linear systems, beta0 does nothing unless betaCoef0Cov is input');
    end
end

function lsrtype = getlstype(inputtype,modelfun,betaCoef0,x,p)
%% Determine the type of least squares
% lstype 
% 1: linear
% 2: nonlinear
% 3: robust linear
% 4: robust nonlinear
% 5: total
isRobust = ~any(strcmp(p.UsingDefaults,'RobustWgtFun'));
h = p.Results.DerivStep;
if isempty(inputtype) % either linear or nonlinear
    if isempty(betaCoef0) || isModelLinear(modelfun,betaCoef0,x,h)
        if isRobust
            lsrtype = 3;
        else 
            lsrtype = 1;
        end
    else
        if isRobust
            lsrtype = 4;
        else 
            lsrtype = 2;
        end
    end
elseif any(strcmp(inputtype,{'ols','wls','gls','lin','linear'}))
    lsrtype = 1;
elseif any(strcmp(inputtype,{'nlin','nonlinear'}))
    lsrtype = 2;    
elseif any(strcmp(inputtype,{'total','tls'}))
    lsrtype = 5;
elseif any(strcmp(inputtype,{'robust'})) %nonlinear and linear robust 
    if isempty(betaCoef0) || isModelLinear(modelfun,betaCoef0,x,h)
        lsrtype = 3; %assume no beta0 means linear
    else
        lsrtype = 4;
    end
elseif any(strcmp(inputtype,{'robustlinear'}))
    lsrtype = 3;
elseif any(strcmp(inputtype,{'robustnonlinear'}))
    lsrtype = 4;
else
    error('Unable to determine the type of least squares');
end

end

function nBetacoef = calcNbetacoef(modelfun,x)
%% Try catch loop until the number of beta parameters doesnt throw an error
for iTestBeta=1:100 %loop and test different nBetacoef and see what works
    try
        modelfun(zeros(iTestBeta,1),x(1,:));
        nBetacoef = iTestBeta;
        break;
    catch
        % keep looping until modelfun doesnt throw an error
        % maybe I shouldnt have tried to force linear into this function
    end
end
if nBetacoef ==100
    error('Unable to determine the number of beta coefficients');
end
end

function Y = spdiag(X)
% make a sparse matrix on the diagonal using vector X
n = numel(X);
Y = sparse(1:n,1:n,X);
end

function hx = bumphdiag(x,n)
    % pad a matrix with 0s while shifting n rows at a time over on blkdiag
    % This is useful when doing partial derivatives wrt predictor variables
    %
    % ie, with n=1
    %  1 2 3       1 2 3 0 0 0 0 0 0 0 0 0
    %  4 5 6  ->   0 0 0 4 5 6 0 0 0 0 0 0
    %  7 8 9       0 0 0 0 0 0 7 8 9 0 0 0
    %  2 4 6       0 0 0 0 0 0 0 0 0 2 4 6
    %
    % ie, with n=2
    %  1 2 3       1 2 3 0 0 0
    %  4 5 6  ->   4 5 6 0 0 0
    %  7 8 9       0 0 0 7 8 9
    %  2 4 6       0 0 0 2 4 6
    %
    [M,N]=size(x);
    irow = kron((1:M)',ones(1,N));
    icol = nan(N,M/n);
    icol(:) = 1:numel(icol);
    icol = kron(icol.',ones(n,1));
    hx = sparse(irow,icol,x);
end
%% IsValid Functions
function isLinear = isModelLinear(modelfun,betacoef,x,h)
%% Compute the Numerical Hessian to determine linearity of modelfun
% note, hessian is not shaped correctly, this just looks for any slope so
% its ok
%check for each point
h = 1; % big jump helped to determine nonlinearity
for i=1:size(x,1)
    Jfun = @(bn)(modelfun(bn,x(i,:)));
    J = @(b) (calcPartials(Jfun,b,h));
    H = calcPartials(J,betacoef',h); %calculate hessian
    isLinear = ~any(H(:));
    if ~isLinear
       break; 
    end
end
end

function isvalid = isSquare(X,ndim)
% check to make sure a matrix is square
if nargin==1
    isvalid = size(X,1)==size(X,2);   
else
    isvalid = size(X,1)==size(X,2) && size(X,1)==ndim;
end
end

%% Enforce Covariance Matrix Validity
function Y=enforceCovariance(X)
count = 0;
while count<100 && (~issymmetric(X) || ~calcIsPSD(X))
% make sure positive semi definite
X = enforcePositiveDefinite(X);
% make sure symmetric
X = enforceSymmetric(X);
count = count+1;
end
if count == 100
   warning('Couldnt make covariance matrix valid'); 
end
Y = X;
end

function Y = enforceSymmetric(X)
Y=X;
for i=1:size(X,1)
   for j = 1:size(X,1)
      Y(j,i)= (X(i,j)+X(j,i))/2;
      Y(i,j)= Y(j,i);
   end
end
end

function isPSD = calcIsPSD(C)
[~,D]=eig(C);

eigenvals = diag(D);

isPSD = ~sum(eigenvals<0)>0;
end

function Y = enforcePositiveDefinite(X)
[V,D]=eig(X);

d=diag(D);
d(d<=0)=eps;

Y= V*diag(d)*V';

end

function [robustTune, robustWgtFun, isvalid] = getRobust(weightfun, tune)
%% the weightfunction can be either a string of a function
% determine which and make sure its valid
% return the tune and weightfun

robustTune = tune;
robustWgtFun = weightfun;

inputWgtFun = weightfun;
if ischar(inputWgtFun)
    isvalid = true;
    switch inputWgtFun
        case 'andrews'
            robustWgtFun = @(x) (abs(x)<pi) .* sin(x)./x;
            defaultTune = 1.339;
        case 'bisquare'
            robustWgtFun = @(x) (abs(x)<1) .* (1-x.^2).^2;
            defaultTune = 4.685;
        case 'cauchy'
            robustWgtFun = @(x) 1./(1+x.^2);
            defaultTune = 2.385;
        case 'fair'
            robustWgtFun = @(x) 1./(1+abs(x));
            defaultTune = 1.400;
        case 'huber'
            robustWgtFun = @(x) 1./(max(1,abs(x)));
            defaultTune = 1.345;
        case 'logistic'
            robustWgtFun = @(x) tanh(x)./x;
            defaultTune = 1.205;
        case 'talwar'
            robustWgtFun = @(x) double(abs(x)<1);
            defaultTune = 2.795;
        case 'welsch'
            robustWgtFun = @(x) exp(-1*x.^2);
            defaultTune = 2.985;
        otherwise
            isvalid = false; %don't know this function
    end
    if isempty(robustTune)
        robustTune = defaultTune;
    end
elseif ~isempty(weightfun)
 %user explicitly input a robust weight function
    robustWgtFun = inputWgtFun;
    if isempty(robustTune)
       error('User Input robustWgtFun must have a ''Tune'' Value input'); 
    end
end

end

function isvalid = checkRobust(X,y)
% if its a string, ensure its an expected value
% if its a function handle, ensure it works
if ischar(X)
    [~,~,isvalid]=getRobust(X,1); % call getRobust to see if its valid
elseif isa(X,'function_handle')
    try
        isvalid = true;
        X(y);
    catch
        isvalid = false;
    end
else
    isvalid = false;
end
end

function isvalid = longWeightCheck(weights,nObsEqns,nPredictors)
% determine if the weights input is valid
% can either be a vector of weights, or a covariance matrix
% the covariance matrix isn't rigorously tested for symmetrical and
% positive semi definite because sometimes the covariance matrix is only
% off by really small numbers due to rounding errors, and it was becoming
% too much of a headache

if isvector(weights) %matrix is weights
    Sx = diag(1./weights);
else %matrix is covariance
    Sx = weights;
end

isvalid = false;

if isSquare(Sx,nObsEqns) || isSquare(Sx,nPredictors)
    isvalid = true;
end

end

function [Sx, isinputcovariance] = getCovariance(lstype,weights,x,y)
% return a covariance depending on the type of input
% vector is "weights", where covariance is inverse of those on the diagonal
% matrix is assumed to be a covariance
nEqn = numel(y);
nVars = numel(x);
if isempty(weights)
    if lstype == 5 % total least squares
        Sx = speye(nVars);
    else
        Sx = speye(nEqn);
    end
    isinputcovariance = false;
elseif isvector(weights) %matrix is weights
    Sx = diag(1./weights);
    isinputcovariance = false;
else %matrix is covariance
    Sx = weights;
    isinputcovariance = true;
end

end

%% Numerical Partial Derivatives
function Jyb = calcJYB(modelfun,b,x,h)
%% Numerically calculate the Jacobian for modelfun(b,x) wrt b
% h (optional) is the delta for calculating the central finite difference.

if nargin==3
    h=eps^(1/3); % optimal for central difference (source: internet)
end

Jybfun = @(bn)(modelfun(bn,x));
Jyb = calcPartials(Jybfun,b',h);

end

function Jyx = calcJYX(modelfun,b,x,h)
%% Numerically calculate the Jacobian for modelfun(b,x) wrt x
% h (optional) is the delta for calculating the central finite difference.

if nargin==3
    h=eps^(1/3); % optimal for central difference (source: internet)
end

JYXfun = @(xn)(modelfun(b,xn));
Jyx = calcPartials(JYXfun,x,h);

nEqn = size(modelfun(b,x),1)/size(x,1);

Jyx = bumphdiag(Jyx,nEqn);
end

function dfdxn = calcPartials(f,x,h)
% f      : model as a function of one vector @f(x)
% xi     : values of x to evaluate partial at
% n      : which partial to calculate
% h      : what step increment for finite differencing
%
% dfdxn  : partial f wrt x_n
nObservations = numel(f(x));

% [nEqnPerObs, nVals] = size(f(x));

nVariables = size(x,2);
dfdxn= nan(nObservations,nVariables);
for i=1:nVariables
    %central derivative
    ix1 = x;
    ix1(:,i)=ix1(:,i)-h/2;
    
    ix2 = x;
    ix2(:,i)=ix2(:,i)+h/2;
    %evaluate slope
    slope = (f(ix2)-f(ix1))/h;
    dfdxn(:,i) = slope(:); %(:) helps for weirdly shaped Hessians
end

end

function K = calcK(modelfun,betacoef,x,y)
% calculate the K matrix for each iteration
K = y - modelfun(betacoef,x);

end
