%%
clc
NAD83.a = 6378137.0;
NAD83.b = 6356752.314140356;
lat = dms2degrees([34  3 34.65778]);
lon = dms2degrees([240  4 49.47622]);
h =  -25.587;

[xa,ya,za]=ellip2cart(NAD83,lat,lon,h);
[xyzb]=ell2cart(NAD83,[lon lat h]);
xb= xyzb(1);
yb= xyzb(2);
zb= xyzb(3);

% 

fprintf('X   : %20.8f | %20.8f | %20.8f \n',xa,xb,xa-xb);
fprintf('Y   : %20.8f | %20.8f | %20.8f \n',ya,yb,ya-yb);
fprintf('Z   : %20.8f | %20.8f | %20.8f \n',za,zb,za-zb);
fprintf('\n');
%%
[latA,lonA,hA]=cart2ellip(NAD83,xa,ya,za);
ELL=cart2ell(NAD83,xyzb);
lonB = ELL(1);
latB = ELL(2);
hB   = ELL(3);

fprintf('LatA: %20.8f | %20.8f | %20.8f \n', latA , lat , latA-lat );
fprintf('LonA: %20.8f | %20.8f | %20.8f \n', lonA , lon , lonA-lon );
fprintf('hA  : %20.8f | %20.8f | %20.8f \n', hA   , h   , hA-h   );

fprintf('LatB: %20.8f | %20.8f | %20.8f \n', latB , lat , latB-lat );
fprintf('LonB: %20.8f | %20.8f | %20.8f \n', lonB , lon , lonB-lon );
fprintf('hB  : %20.8f | %20.8f | %20.8f \n', hB   , h   , hB-h   );
