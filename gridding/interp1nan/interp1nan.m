function yi=interp1nan(x,y,xi)
% INTERP1NAN Inteprolates across Nans
%   Simple code to do a 1d interpolation across nans
% 
% Inputs:
%   - x  : [1 n]: x data
%   - y  : [1 n]: y data
%   - xi : [1 m]: xi to interpolate to
% 
% Outputs:
%   - yi: [1 m]: interpolated y values at each xi
% 
% Examples:
%   x = [1 2 3 4 5];
%   y = [0 nan 3 4 5];
%   xi = [1:5];
%   yi = interp1nan(x,y,xi);
%
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 1-Jan-2015    
% Date Modified : 11-Jun-2017    
% Github        : https://github.com/hokiespurs/general-purpose-matlab  

if sum(~isnan(y))>1
    yi=interp1(x(~isnan(y)),y(~isnan(y)),xi);
else
    yi=nan(size(xi));
end

end