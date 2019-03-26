function [E,N]=ellip2obliqueMercator(Ellipdef,Projdef,lat,lon)
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