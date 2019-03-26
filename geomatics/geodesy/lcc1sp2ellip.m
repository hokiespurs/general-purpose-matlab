function [lat,lon] = lcc1sp2ellip(Ellipdef,Projdef,E,N)
%% Lambert Conic Conformal (2SP)
% EPSG Dataset coordinate operation method code 9802

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
mo = cosd(lato)./sqrt(1-e2*sind(lato).^2);

to = tand(45 - lato/2)./((1 - e*sind(lato))/(1+e*sind(lato))).^(e/2);

n = sind(lato);

F  = mo./(n*to.^n);

ro = a .* F .* to.^n * ko;
rp = sqrt((E-EF).^2+(ro-(N-NF)).^2);
if (rp<0 && n>0) || (rp>0 && n<0)
    rp = rp * -1;
end
tp = (rp/(a*ko*F))^(1/n);
thetap = atan2d(E-EF,ro-(N-NF));

%% Final Computation
lat0 = 90 - 2 * atand(tp);
keeplooping = true;
while(keeplooping)
    lat = 90 - 2 * atand(tp*((1-e*sind(lat0))./(1+e*sind(lat0))).^(e/2));
    dlat = abs(lat-lat0);
    lat0=lat;
    keeplooping = dlat>1e-16;
end

lon = thetap/n+lono;
end