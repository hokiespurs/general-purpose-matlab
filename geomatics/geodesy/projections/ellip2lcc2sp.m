function [E,N]=ellip2lcc2sp(Ellipdef,Projdef,lat,lon)
% ELLIP2LCC2SP Converts from Ellipsoid to Lambert Conic Conformal (2SP)
%   EPSG Code 9802, as defined in:
%   *Source:         "EPSG Geomatics Guidance Note 7, part 2"
%            "Coordinate Conversions & Transformations including Formulas"
%
%      http://www.epsg.org/Portals/0/373-07-2.pdf?ver=2019-03-08-165437-017
% 
% Inputs:
%   - Ellipdef : Structure defining the Ellipsoid 
%   - Projdef  : Structure defining the Projection
%   - lat      : Latitude  (decimal degrees)
%   - lon      : Longitude (decimal degrees)
% 
% Outputs:
%   - E : Easting (m)
%   - N : Northing (m)
% 
% Examples:
%   checkOCRSprojections;
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


%% Lambert Conic Conformal (2SP)
% EPSG Dataset coordinate operation method code 9802

%% Values from structure into easier to read variables

% Values from projection structure
latF = Projdef.falseLat;   % False Origin Latitude
lonF = Projdef.falseLon;   % False Origin Longitude
lat1 = Projdef.LatSP1;     % Latitude of Standard Parallel 1
lat2 = Projdef.LatSP2;     % Latitude of Standard Parallel 2
EF   = Projdef.falseEast;  % False Easting
NF   = Projdef.falseNorth; % False Northing

% Values from ellipsoid structure
a = Ellipdef.a;
e2 = Ellipdef.e2;
e = sqrt(e2);

%% Sub Computations
m = cosd(lat)./sqrt(1-e2*sind(lat).^2);
m1 = cosd(lat1)./sqrt(1-e2*sind(lat1).^2);
m2 = cosd(lat2)./sqrt(1-e2*sind(lat2).^2);

t1 = tand(45 - lat1/2)./((1 - e*sind(lat1))/(1+e*sind(lat1))).^(e/2);
t2 = tand(45 - lat2/2)./((1 - e*sind(lat2))/(1+e*sind(lat2))).^(e/2);
tf = tand(45 - latF/2)./((1 - e*sind(latF))/(1+e*sind(latF))).^(e/2);
t  = tand(45 - lat/2)./((1 - e*sind(lat))/(1+e*sind(lat))).^(e/2);

n = (log(m1)-log(m2))./(log(t1)-log(t2));

F  = m1./(n*t1.^n);

r  = a .* F .* t.^n;
rf = a .* F .* tf.^n;

theta = n * (lon-lonF);

%% Final Computation
E = EF + r * sind(theta);
N = NF + rf - r * cosd(theta);

k = (r .* n) ./ (a * m); % Scale Factor
ca = (lon-lonF)*n;       % Convergence Angle
end