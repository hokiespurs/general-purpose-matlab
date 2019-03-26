function [lat,lon]=obliqueMercator2ellip(Ellipdef,Projdef,E,N)
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
