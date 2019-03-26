function [x,y,z]=ellip2cart(Ellipdef,lat,lon,h)
% ELLIP2CART Converts from Ellipsoid(lat,lon,h) to Cartesion(x,y,z) coords
%   *Source: https://gssc.esa.int/navipedia/index.php/Ellipsoidal_and_Cartesian_Coordinates_Conversion
% 
% Inputs:
%   - Ellipdef : Ellipsoid definition structure  *(Ellipdef.a, Ellipdef.b)
%   - lat      : Latitude  (decimal degrees)
%   - lon      : Longitude (decimal degrees)
%   - h        : Ellipsoidal Elevation
% 
% Outputs:
%   - x : ECEF X
%   - y : ECEF Y
%   - z : ECEF Z
% 
% Examples:
%   - Example code goes here
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 15-Mar-2019
% Date Modified : 15-Mar-2019
% Github        : 

%%
a = Ellipdef.a;
b = Ellipdef.b;

%eccentricity
e2 = (a^2-b^2)/a^2;

% radius of curvature in the prime vertical
N = a./sqrt(1-e2*sind(lat).^2);

% Compute ECEF
x = (N + h).*cosd(lat).*cosd(lon);
y = (N + h).*cosd(lat).*sind(lon);
z = ((1-e2).*N+h).*sind(lat);

end