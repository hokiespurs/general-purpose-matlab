function [E,N]=ellip2obliquemercator(Ellipdef,Projdef,lat,lon)
% ELLIP2OBLIQUEMERCATOR Converts from Ellipsoid to Oblique Mercator(Hotine)
%   EPSG Code 9812, as defined in:
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


%%
% EPSG 9812
%% Constants
latc   = Projdef.latOrigin;
lonc   = Projdef.lonOrigin;
Azc    = Projdef.azline;
gammac = Projdef.skewaxis;
kc     = Projdef.scaleFactor;
FE     = Projdef.falseEasting;
FN     = Projdef.falseNorthing;

f = Ellipdef.f;
a = Ellipdef.a;
e2 = Ellipdef.e2;
e = sqrt(e2);

%% Map Projection Constants
B = sqrt(1 + ((e2*cosd(latc)^4)/(1-e2)));
A = a * B * kc * sqrt(1-e2) / (1-e2*sind(latc)^2);
to = tand(45-latc/2)/((1-e*sind(latc))/(1+e*sind(latc)))^(e/2);
D = B * sqrt(1-e2) /(cosd(latc)*sqrt(1-e2*sind(latc)^2));
if D<1
    D2 = 1;
else
    D2 = D^2;
end
F = D + sqrt(D2-1);
if (latc<0 && F>0) || (latc>0 && F<0)
    F = -1*F;
end
H = F * to^B;
G = (F-1/F)/2;
gammao = asind(sind(Azc)/D);
lono = lonc - (asind(G*tand(gammao)))/B;

%% 
t = tand(45-lat./2)./((1-e.*sind(lat))./(1+e.*sind(lat))).^(e/2);
Q = H./t.^B;
S = (Q-1./Q)./2;
T = (Q+1./Q)./2;
V = sind(B.*(lon-lono));
U = (-V.*cosd(gammao)+S .* sind(gammao))./T;
v = A .* log((1-U)./(1+U))./(2.*B);

%%
u = A .* atan2(S.*cosd(gammao)+V.*sind(gammao),cosd(B.*(lon-lono)))./B;

E = v .* cosd(gammac) + u .* sind(gammac) + FE;
N = u .* cosd(gammac) - v .* sind(gammac) + FN;

end