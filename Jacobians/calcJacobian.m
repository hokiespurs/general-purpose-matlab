function [J, y] = calcJacobian(fun,x,varargin)
% CALCJACOBIAN estimates the Jacobian of a function fun
%   Detailed explanation goes here
%
% Required Inputs: (default)
%	- fun      : function handle 
%	- x        : x point to evaluate Jacobian at
% Optional Inputs: (default)
%	- 'h'      : (eps^(1/3) for cd, 1e-10 for csd) step size 
%	- 'method' : ('csd') 'csd' = complex step difference
%                        'cd'  = central difference 
% 
% Outputs:
%   - J : Jacobian Matrix
%   - y : value for 'y = fun(x)'
% 
% Examples:
%   - n/a
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 16-Mar-2018
% Date Modified : 16-Mar-2018
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%% Function Call
[fun,x,h,method] = parseInputs(fun,x,varargin{:});

if strcmp(method,'csd')
    [y, J] = jacobianComplexStepDiff(fun,x,h);
else
    [y, J] = jacobianCentralDiff(fun,x,h);
end

end

function [fun,x,h,method] = parseInputs(fun,x,varargin)
%%	 Call this function to parse the inputs

% Default Values
default_h       = [];
default_method  = 'csd';

% Check Values
check_fun     = @(x) isa(x,'function_handle');
check_x       = @(x) true;
check_h       = @(x) isnumeric(x) && x>0 && numel(x)==1;
check_method  = @(x) any(strcmp(x,{'csd','cd'}));

% Parser Values
p = inputParser;
% Required Arguments:
addRequired(p, 'fun' , check_fun );
addRequired(p, 'x'   , check_x   );
% Parameter Arguments
addParameter(p, 'h'      , default_h     , check_h      );
addParameter(p, 'method' , default_method, check_method );
% Parse
parse(p,fun,x,varargin{:});
% Convert to variables
fun    = p.Results.('fun');
x      = p.Results.('x');
h      = p.Results.('h');
method = p.Results.('method');
end

function [y, J] = jacobianComplexStepDiff(fun,x,h)
% Jacobian computed via complex step differentiation

y = fun(x);   % evaluate to solve for y = f(x);
n = numel(x); % number of inputs
m = numel(y); % number of outputs

% determine step size
if isempty(h)
   h = 1e-10; % set small step size = 10^-8
   % " The estimate is practically insensitive to small step sizes and, for 
   %   any step size below 10?8, it achieves the accuracy of the function 
   %   evaluation " 
   %      - Martins et al. 2003 'The Complex-Step Derivative Approximation'
end

J = nan(m,n); % preallocate Jacobian

for k=1:n
    xk = x;
    xk(k)=xk(k)+h*1i;
    J(:,k) = imag(fun(xk))/h;
end

end

function [y, J] = jacobianCentralDiff(fun,x,h)
% Jacobian computed via central difference 

y = fun(x);   % evaluate to solve for y = f(x);
n = numel(x); % number of inputs
m = numel(y); % number of outputs

% determine step size
if isempty(h)
   h = eps^(1/3); % "optimal for central difference" - the internet 
end

J = nan(m,n); % preallocate Jacobian

for k=1:n
    x1 = x;
    x1(k) = x1(k)-h/2;
    
    x2 = x;
    x2(k) = x2(k)+h/2;
    
    J(:,k) = (fun(x2)-fun(x1))/h;
end

end