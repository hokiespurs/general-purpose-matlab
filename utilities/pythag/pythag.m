function h = pythag(x,y,z)
% PYTHAG Calculate element wise Pythagorean distance in 2d or 3d
% 
% Inputs:
%   - x : [m x n] : x distance of the triangle
%   - y : [m x n] : y distance of the triangle
%   - z : [m x n] : (optional) z distance of the triangle
% 
% Outputs:
%   - h : [m x n] : hypotenuse of the triangle
% 
% Examples:
%   pythag(3,4)
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : hokiespurs@gmail.com
% Date Created  : 08-Feb-2017
% Date Modified : 08-Feb-2017
% Github        : https://github.com/hokiespurs/general-purpose-matlab

if nargin==2
    z = 0;
end

h = sqrt(x.^2+y.^2+z.^2);  

end