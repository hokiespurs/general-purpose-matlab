function [E,N]=ellip2lcc1sp(Ellipdef,Projdef,lat,lon)
% ELLIP2LCC1SP Converts from Ellipsoid to Lambert Conic Conformal (1SP)
%   EPSG Code 9801, as defined in:
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

%% Lambert Conic Conformal (1SP)
% EPSG Dataset coordinate operation method code 9801

%% Values from structure into easier to read variables

% Values from projection structure
lato = Projdef.latOrigin;   % Latitude of Natural Origin
lono = Projdef.lonOrigin;   % Longitude of Natural Origin
ko   = Projdef.scaleFactor; % Scale Factor
EF   = Projdef.falseEast;   % False Easting
NF   = Projdef.falseNorth;  % False Northing

% Values from ellipsoid structure
a = Ellipdef.a;
e2 = Ellipdef.e2;
e = sqrt(e2);

%% Sub Computations
m = cosd(lat)./sqrt(1-e2*sind(lat).^2);
mo = cosd(lato)./sqrt(1-e2*sind(lato).^2);

to = tand(45 - lato/2)./((1 - e.*sind(lato))./(1+e.*sind(lato))).^(e/2);
t  = tand(45 - lat/2)./((1 - e.*sind(lat))./(1+e.*sind(lat))).^(e/2);

n = sind(lato);

F  = mo./(n*to.^n);

r  = a .* F .* t.^n .* ko;
ro = a .* F .* to.^n .* ko;

theta = n * (lon-lono);

%% Final Computation
E = EF + r .* sind(theta);
N = NF + ro - r .* cosd(theta);

k = (r .* n) ./ (a * m); % Scale Factor
ca = (lon-lono).*n;       % Convergence Angle
end