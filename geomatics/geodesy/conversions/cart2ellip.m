function [lat,lon,h]=cart2ellip(Ellipdef,x,y,z,thresh)
% CART2ELLIP Converts from Cartesian(x,y,z)to Ellipsoid(lat,lon,h) coords
%   specifically, geocentric cartesian
%   Ellipsoid coordinates are solved iteratively until change in lat/lon 
%   and ellipsoid height is less than the thresh [1e-16 1e-6].
% 
%   *Source: "EPSG Geomatics Guidance Note 7, part 2"
%            "Coordinate Conversions & Transformations including Formulas"
%
%      http://www.epsg.org/Portals/0/373-07-2.pdf?ver=2019-03-08-165437-017
% 
% Inputs:
%   - Ellipdef : Ellipsoid definition structure  *(Ellipdef.a, Ellipdef.b)
%   - x        : Geocentric x
%   - y        : Geocentric y
%   - z        : Geocentric z
% 
% Optional Inputs:
%   - thresh   : (1e-16,1e-6) lat threshold and elevation threshhold 
%
% Outputs:
%   - lat : Latitude  (decimal degrees)
%   - lon : Longitude (decimal degrees)
%   - h   : Ellipsoidal Elevation
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

%% Parse Inputs
if nargin<5
   thresh = [1e-16 1e-6];
end
%%
% Read Ellipsoid Parameters
a = Ellipdef.a;
e2 = Ellipdef.e2;

p = sqrt(x.^2+y.^2);

% longitude computed directly
lon  = atan2d(y,x);

%% solve iteratively until "thresh" is satisfied for h
% initial parameters
lat0 = atan2d(z,((1-e2).*p));
N = a./sqrt(1-e2*sind(lat0).^2); % radius of curvature in the prime vertical
h0 = p./cosd(lat0) - N;

keeplooping = true;
while(keeplooping)
    % compute new N
    N = a./sqrt(1-e2*sind(lat0).^2); % radius of curvature in the prime vertical
   
    % compute new latitude
    num = z;
    den = (1-e2*(N./(N+h0))).*p;
    lat = atan2d(num,den);

    dlat = lat-lat0;
    lat0=lat;
    
    % compute new h
    h = p./cosd(lat0) - N;
    
    dh = h-h0;
    h0 = h;
    
    % compute loop criteria
    keeplooping = any(abs(dlat(:))>thresh(1)) || any(abs(dh(:))>thresh(2));
end