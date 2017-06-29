function y = changeScale(x,LIMX,LIMY)
% CHANGESCALE converts x from LIMX scale to LIMY scale
%   This function is used to linearly stretch data to a new scale
% 
% Inputs:
%   - x    : values to be converted to indices
%   - LIMX : limits of x
%   - LIMY : limits of y
% 
% Outputs:
%   - y    : values converted to from LIMX scale to LIMY scale
% 
% Examples:
%   x = rand(10,1);
%   y = changeScale(x,[0 1],[0 10])
%   [x y]
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 26-Mar-2016    
% Date Modified : 11-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%% Stretch Using y = mx + b
if nargin==2
   LIMY=LIMX;
   LIMX=[min(x(:)) max(x(:))];
end

m = abs(diff(LIMY))/abs(diff(LIMX));

b = LIMY(1) - LIMX(1)*m;

y = m.*x + b;


end