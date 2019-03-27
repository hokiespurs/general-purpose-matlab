function [Easting,Northing]=ellip2transmercator(Ellipdef,Projdef,lat,lon)
% assume not at poles, need to implement USGS method if so
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

Q = asinh(tand(lat)) - (e .* atanh(e.*sind(lat)));
Beta = atan(sinh(Q));
n0 = atanh(cos(Beta).*sind(lon-lono));
E0 = asin(sin(Beta).*cosh(n0));

E1 = h1 .* sin(2*E0) .* cosh(2*n0);
E2 = h2 .* sin(4*E0) .* cosh(4*n0);
E3 = h3 .* sin(6*E0) .* cosh(6*n0);
E4 = h4 .* sin(8*E0) .* cosh(8*n0);
E = E0+E1+E2+E3+E4;

n1 = h1.*cos(2*E0).*sinh(2*n0);
n2 = h2.*cos(4*E0).*sinh(4*n0);
n3 = h3.*cos(6*E0).*sinh(6*n0);
n4 = h4.*cos(8*E0).*sinh(8*n0);
eta = n0 + n1 + n2 + n3 + n4;

Easting = FE + ko .* B .* eta;
Northing = FN + ko .* (B.*E-M0);

end