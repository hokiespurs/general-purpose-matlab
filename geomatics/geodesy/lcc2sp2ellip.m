function [lat,lon] = lcc2sp2ellip(Ellipdef,Projdef,E,N)
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
m1 = cosd(lat1)./sqrt(1-e2*sind(lat1).^2);
m2 = cosd(lat2)./sqrt(1-e2*sind(lat2).^2);

t1 = tand(45 - lat1/2)./((1 - e*sind(lat1))/(1+e*sind(lat1))).^(e/2);
t2 = tand(45 - lat2/2)./((1 - e*sind(lat2))/(1+e*sind(lat2))).^(e/2);
tf = tand(45 - latF/2)./((1 - e*sind(latF))/(1+e*sind(latF))).^(e/2);

n = (log(m1)-log(m2))./(log(t1)-log(t2));

F  = m1./(n*t1.^n);

rf = a .* F .* tf.^n;

rp = sqrt((E-EF).^2+(rf-(N-NF)).^2);
if (rp<0 && n>0) || (rp>0 && n<0)
    rp = rp * -1;
end
tp = (rp/(a*F))^(1/n);
thetap = atan2d(E-EF,rf-(N-NF));


%% Final Computation
lat0 = 90 - 2 * atand(tp);
keeplooping = true;
while(keeplooping)
    lat = 90 - 2 * atand(tp*((1-e*sind(lat0))./(1+e*sind(lat0))).^(e/2));
    dlat = abs(lat-lat0);
    lat0=lat;
    keeplooping = dlat>1e-16;
end

lon = thetap/n+lonF;
end