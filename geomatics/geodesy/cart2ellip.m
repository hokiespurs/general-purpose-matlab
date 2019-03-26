function [lat,lon,h]=cart2ellip(Ellipdef,x,y,z,thresh)
% CART2ELLIP Converts from Cartesian(x,y,z)to Ellipsoid(lat,lon,h) coords
%   Ellipsoid coordinates are solved iteratively until change in ellipsoid
%   height(h) is less than the thresh [default=0.00001].
%   *Source: https://gssc.esa.int/navipedia/index.php/Ellipsoidal_and_Cartesian_Coordinates_Conversion
% 
% Inputs:
%   - Ellipdef : Ellipsoid definition structure  *(Ellipdef.a, Ellipdef.b)
%   - x        : Cartesian x
%   - y        : Cartesian y
%   - z        : Cartesian z
% 
% Optional Inputs:
%   - thresh   : (1e-10,1e-5) lat threshold and elevation threshhold 
%
% Outputs:
%   - lat : Latitude  (decimal degrees)
%   - lon : Longitude (decimal degrees)
%   - h   : Ellipsoidal Elevation
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

%% Parse Inputs
if nargin<5
   thresh = [1e-16 1e-6];
end
%%
a = Ellipdef.a;
b = Ellipdef.b;

p = sqrt(x.^2+y.^2);

% eccentricity
e2 = (a^2-b^2)/a^2;

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