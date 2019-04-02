function [lat,lon] = transmercator2ellip(Ellipdef,Projdef,E,N)
% TRANSMERCATOR2ELLIP Converts from Transverse Mercator(JHS) to Ellipsoid
%   EPSG Code 9807, as defined in:
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

%%
% assume not at poles, need to implement USGS method if so
THRESH = 1e-16;
%%
f = Ellipdef.f;
a = Ellipdef.a;
e2 = Ellipdef.e2;
e = sqrt(e2);

lato = Projdef.latOrigin;   % Latitude of Natural Origin
lono = Projdef.lonOrigin;   % Longitude of Natural Origin
ko   = Projdef.scaleFactor; % Scale Factor
FE   = Projdef.falseEasting;   % False Easting
FN   = Projdef.falseNorthing;  % False Northing

%% JHS Constants for projection
n = f./(2-f);
B = (a./(1+n))*(1 + n^2/4 + n^4/64);

h1 = n/2-(2/3)*n^2 + (5/16)*n^3 + (41/180)*n^4;
h2 = (13/48)*n^2 - (3/5)*n^3 + (557/1440)*n^4;
h3 = (61/240)*n^3 - (103/140)*n^4;
h4 = (49561/161280)*n^4;

h1p = n/2-(2/3)*n^2 + (37/96)*n^3 - (1/360)*n^4;
h2p = (1/48)*n^2 + (1/15)*n^3 - (473/1440)*n^4;
h3p = (17/480)*n^3 - (37/840)*n^4;
h4p = (4397/161280)*n^4;

if lato==0 
    M0 = 0;
elseif lato == 90
    M0 = B * 45;
elseif lato == -90
    M0 = B * -45;
else
    Q0 = asinh(tand(lato)) - (e * atanh(e*sind(lato)));
    B0 = atan(sinh(Q0));
    EO0 = asin(sin(B0));
%     EO0 = atan(sinh(Q0));
    
    EO1 = h1 * sin(2*EO0);
    EO2 = h2 * sin(4*EO0);
    EO3 = h3 * sin(6*EO0);
    EO4 = h4 * sin(8*EO0);
    
    EO = EO0 + EO1 + EO2 + EO3 + EO4;
    
    M0 = B * EO;
end

np =(E-FE)./(B.*ko);
Ep = ((N-FN)+ko.*M0)./(B.*ko);

E1p = h1p .* sin(2.*Ep) .* cosh(2*np);
E2p = h2p .* sin(4.*Ep) .* cosh(4*np);
E3p = h3p .* sin(6.*Ep) .* cosh(6*np);
E4p = h4p .* sin(8.*Ep) .* cosh(8*np);
E0p = Ep-(E1p+E2p+E3p+E4p);

n1p = h1p.*cos(2.*Ep).*sinh(2.*np);
n2p = h2p.*cos(4.*Ep).*sinh(4.*np);
n3p = h3p.*cos(6.*Ep).*sinh(6.*np);
n4p = h4p.*cos(8.*Ep).*sinh(8.*np);
eta0p = np - (n1p + n2p + n3p + n4p);

Bp = asin(sin(E0p)./cosh(eta0p));
Qp = asinh(tan(Bp));
Qpp0 = Qp;
keeplooping = true;
x=0;
while (keeplooping)
    Qpp = Qp + (e.*atanh(e.*tanh(Qpp0)));
    keeplooping = any(abs(Qpp-Qpp0))>THRESH;
    Qpp0 = Qpp;
    x = x+1;
end
lat = atand(sinh(Qpp));
lon = lono + asind(tanh(eta0p)./cos(Bp));

end