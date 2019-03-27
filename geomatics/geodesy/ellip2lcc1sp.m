function [E,N]=ellip2lcc1sp(Ellipdef,Projdef,lat,lon)
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