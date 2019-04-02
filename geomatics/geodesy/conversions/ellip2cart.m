function [x,y,z]=ellip2cart(Ellipdef,lat,lon,h)
% ELLIP2CART Converts from Ellipsoid(lat,lon,h) to Cartesion(x,y,z) coords
%   specifically, geocentric cartesian
% 
%   *Source: "EPSG Geomatics Guidance Note 7, part 2"
%            "Coordinate Conversions & Transformations including Formulas"
%
%      http://www.epsg.org/Portals/0/373-07-2.pdf?ver=2019-03-08-165437-017
% 
% Inputs:
%   - Ellipdef : Ellipsoid definition structure  *(Ellipdef.a, Ellipdef.e2)
%   - lat      : Latitude  (decimal degrees)
%   - lon      : Longitude (decimal degrees)
%   - h        : Ellipsoidal height
% 
% Outputs:
%   - x : Geocentric x
%   - y : Geocentric y
%   - z : Geocentric z
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
% Date Created  : 15-Mar-2019
% Date Modified : 27-Mar-2019
% Github        : https://github.com/hokiespurs/general-purpose-matlab/tree/master/geomatics/geodesy

%%
% Read Ellipsoid Parameters
a = Ellipdef.a;
e2 = Ellipdef.e2;

% prime vertical radius of curvature
v = a./sqrt(1-e2*sind(lat).^2);

% Compute ECEF
x = (v + h).*cosd(lat).*cosd(lon);
y = (v + h).*cosd(lat).*sind(lon);
z = ((1-e2).*v+h).*sind(lat);

end