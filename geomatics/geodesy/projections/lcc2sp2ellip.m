function [lat,lon] = lcc2sp2ellip(Ellipdef,Projdef,E,N)
% LCC2SP2ELLIP Converts from Lambert Conic Conformal(2SP) to Ellipsoid
%   EPSG Code 9802, as defined in:
%   *Source:         "EPSG Geomatics Guidance Note 7, part 2"
%            "Coordinate Conversions & Transformations including Formulas"
%
%      http://www.epsg.org/Portals/0/373-07-2.pdf?ver=2019-03-08-165437-017
% 
% Inputs:
%   - Ellipdef : Structure defining the Ellipsoid 
%   - Projdef  : Structure defining the Projection
%   - E        : Easting (m)
%   - N        : Northing (m)
% 
% Outputs:
%   - lat : Latitude  (decimal degrees)
%   - lon : Longitude (decimal degrees)
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
THRESH = 1e-16;
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
m1 = cosd(lat1)./sqrt(1-e2*sind(lat1).^2);
m2 = cosd(lat2)./sqrt(1-e2*sind(lat2).^2);

t1 = tand(45 - lat1/2)./((1 - e*sind(lat1))/(1+e*sind(lat1))).^(e/2);
t2 = tand(45 - lat2/2)./((1 - e*sind(lat2))/(1+e*sind(lat2))).^(e/2);
tf = tand(45 - latF/2)./((1 - e*sind(latF))/(1+e*sind(latF))).^(e/2);

n = (log(m1)-log(m2))./(log(t1)-log(t2));

F  = m1./(n*t1.^n);

rf = a .* F .* tf.^n;

rp = sqrt((E-EF).^2+(rf-(N-NF)).^2);
if n>0 % rp same sign as n
    rp(rp<0) = rp(rp<0) * -1;
else
    rp(rp>0) = rp(rp>0) * -1;
end
tp = (rp./(a.*F)).^(1./n);
thetap = atan2d(E-EF,rf-(N-NF));


%% Final Computation
lat0 = 90 - 2 * atand(tp);
keeplooping = true;
while(keeplooping)
    lat = 90 - 2 .* atand(tp.*((1-e.*sind(lat0))./(1+e.*sind(lat0))).^(e./2));
    dlat = abs(lat-lat0);
    lat0=lat;
    keeplooping = any(dlat(:)>THRESH);
end

lon = thetap/n+lonF;
%% Scale Factor and Convergence Angle
t  = tand(45 - lat/2)./((1 - e*sind(lat))/(1+e*sind(lat))).^(e/2);
r  = a .* F .* t.^n;

m = cosd(lat)./sqrt(1-e2*sind(lat).^2);
k = (r .* n) ./ (a * m); % Scale Factor
ca = (lon-lonF)*n;       % Convergence Angle
end