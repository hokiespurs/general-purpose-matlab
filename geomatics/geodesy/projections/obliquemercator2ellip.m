function [lat,lon]=obliquemercator2ellip(Ellipdef,Projdef,E,N)
% OBLIQUEMERCATOR2ELLIP Converts from Oblique Mercator(Hotine) to Ellipsoid
%   EPSG Code 9812, as defined in:
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

%% Constants
latc   = Projdef.latOrigin;
lonc   = Projdef.lonOrigin;
Azc    = Projdef.azline;
gammac = Projdef.skewaxis;
kc     = Projdef.scaleFactor;
FE     = Projdef.falseEasting;
FN     = Projdef.falseNorthing;

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
vp = (E-FE).*cosd(gammac)-(N-FN).*sind(gammac);
up = (N-FN).*cosd(gammac)+(E-FE).*sind(gammac);

Qp = exp(-(B.*vp./A));
Sp = (Qp-1./Qp)/2;
Tp = (Qp+1./Qp)/2;
Vp = sin(B.*up./A);
Up = (Vp.*cosd(gammao)+Sp.*sind(gammao))./Tp;
tp = (H./sqrt((1+Up)./(1-Up))).^(1./B);
chi= pi./2-2.*atan(tp);
lat = chi + sin(2*chi) .* (e^2/2 + 5*e^4/24 + e^6/12 + 13*e^8/360) + ...
            sin(4*chi) .* (7*e^4/48 + 29*e^6/240 + 811*e^8/11520) + ...
            sin(6*chi) .* (7*e^6/120 + 81 * e^8/1120) + ...
            sin(8*chi) .* (4279*e^8/161280);
lat = lat.*180/pi;
lon = lono - atan2d((Sp.*cosd(gammao)-Vp.*sind(gammao)),cos(B*up./A))./B;
end
