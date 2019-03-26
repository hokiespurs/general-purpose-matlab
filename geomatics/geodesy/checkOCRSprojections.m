clear
clc
%% EPSG Oblique Mercator Example
% Everest 1830(1967 Definition)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6377298.556;
Ellipdef.f  = 1/300.8017;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% Timbalai 1948 / R.S.O. Borneo (m) (Oblique Mercator)
Projdef.latOrigin     = dms2degrees([4 0 0]);
Projdef.lonOrigin     = dms2degrees([115 0 0]);
Projdef.falseNorthing = 0;
Projdef.falseEasting  = 0;
Projdef.scaleFactor   = 0.99984;
Projdef.skewaxis      = dms2degrees([53 07 48.3685]);
Projdef.azline        = dms2degrees([53 18 56.9537]);

truelat = dms2degrees([ 5 23 14.1129]);
truelon = dms2degrees([115 48 19.8196]);

trueN = 596562.78;
trueE = 679245.73;

[myE,myN]=ellip2obliqueMercator(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=obliqueMercator2ellip(Ellipdef,Projdef,trueE,trueN);
printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'EPSG Oblique Mercator')

%% EPSG Transverse Mercator
% Airy 1830(1967 Definition)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6377563.396;
Ellipdef.f  = 1/ 299.32496;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% OSGB 1936 British National Grid (Transverse Mercator)
Projdef.latOrigin     = dms2degrees([49 0 0]);
Projdef.lonOrigin     = -dms2degrees([2 0 0]);
Projdef.falseNorthing = -100000.00;
Projdef.falseEasting  = 400000.00;
Projdef.scaleFactor   = 0.9996012717;

truelat = dms2degrees([ 50 30 0]);
truelon = dms2degrees([0 30 0]);

trueN = 69740.5;
trueE = 577274.99;

[myE,myN]=ellip2transmercator(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=transmercator2ellip(Ellipdef,Projdef,trueE,trueN);
printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'EPSG TRANSVERSE MERCATOR')

%% EPSG LCC2SP Mercator
% Clarke 1866
%  - ellipsoid: Clarke 1866 (survey ft)
Ellipdef.a  =  20925832.16;
Ellipdef.f  = 1/ 294.97870;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% NAD27 / Texas South Central (LCC 2SP)
Projdef.falseLat = dms2degrees([27 50 0]);   % False Origin Latitude
Projdef.falseLon = -dms2degrees([99 0 0]);    % False Origin Longitude
Projdef.LatSP1 = dms2degrees([28 23 0]);      % Latitude of Standard Parallel 1
Projdef.LatSP2 = dms2degrees([30 17 0]);      % Latitude of Standard Parallel 2
Projdef.falseEast = 2000000; % False Easting
Projdef.falseNorth = 0; % False Northing

truelat = dms2degrees([ 28 30 0]);
truelon = -dms2degrees([96 0 0]);

trueN = 254759.80;
trueE = 2963503.91;

[myE,myN]=ellip2lcc2sp(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=lcc2sp2ellip(Ellipdef,Projdef,trueE,trueN);
printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'EPSG LCC 2SP MERCATOR')

%% EPSG LCC1SP Mercator
% Clarke 1866
%  - ellipsoid: Clarke 1866 (survey ft)
Ellipdef.a  =  6378206.400;
Ellipdef.f  = 1/ 294.97870;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% JAD69 / Jamaica National Grid (LCC 1SP)
Projdef.latOrigin = dms2degrees([18 00 0]);
Projdef.lonOrigin = -dms2degrees([77 00 0]);
Projdef.scaleFactor = 1;      
Projdef.falseEast = 250000.00; % False Easting
Projdef.falseNorth = 150000.00; % False Northing

truelat = dms2degrees([17 55 55.8]);
truelon = -dms2degrees([76 56 37.26]);
trueN = 142493.51;
trueE = 255966.58;

[myE,myN]=ellip2lcc1sp(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=lcc1sp2ellip(Ellipdef,Projdef,trueE,trueN);
printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'EPSG LCC 1SP MERCATOR')

%% Oregon Coast Zone (OBLIQUE  MERCATOR)
% NAD83(2011)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6378137;
Ellipdef.f  = 1/298.257222101;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% Oregon Coast Zone (Oblique Mercator)
Projdef.latOrigin     = dms2degrees([44 45 0]);
Projdef.lonOrigin     = -dms2degrees([124 3 0]);
Projdef.falseNorthing = -4600000;
Projdef.falseEasting  = -300000;
Projdef.scaleFactor   = 1;
Projdef.skewaxis      = dms2degrees([5 0 0]);
Projdef.azline        = dms2degrees([5 0 0]);

% Test Values
truelat = dms2degrees([  42 50   9.93918]);
truelon = -dms2degrees([124 33 47.98916]);
trueN = 156617.94338;
trueE = 92771.55752;

[myE,myN]=ellip2obliqueMercator(Ellipdef,Projdef,truelat,truelon);

[mylat,mylon]=obliqueMercator2ellip(Ellipdef,Projdef,trueE,trueN);

printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'OCRS Coast Zone(OBLIQUE MERCATOR)')
%% Columbia River West Zone (OBLIQUE  MERCATOR)
% NAD83(2011)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6378137;
Ellipdef.f  = 1/298.257222101;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% Oregon Coast Zone (Oblique Mercator)
Projdef.latOrigin     = dms2degrees([45 55 0]);
Projdef.lonOrigin     = -dms2degrees([123 0 0]);
Projdef.falseNorthing = -3000000;
Projdef.falseEasting  = 7000000;
Projdef.scaleFactor   = 1;
Projdef.skewaxis      = -dms2degrees([65 0 0]);
Projdef.azline        = -dms2degrees([65 0 0]);

% Test Values
truelat = dms2degrees([  46 12 17.57866]);
truelon = -dms2degrees([123 57 21.88345]);
trueN = 218152.78553;
trueE = 94514.71992;

[myE,myN]=ellip2obliqueMercator(Ellipdef,Projdef,truelat,truelon);

[mylat,mylon]=obliqueMercator2ellip(Ellipdef,Projdef,trueE,trueN);

printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'OCRS Columbia River West(OBLIQUE MERCATOR)')

%% Ontario Zone (TRANSVERSE MERCATOR)
% NAD83(2011)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6378137;
Ellipdef.f  = 1/298.257222101;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% Ontario Zone (Transverse Mercator)
Projdef.latOrigin     = dms2degrees([43 15 0]);
Projdef.lonOrigin     = -dms2degrees([117 0 0]);
Projdef.falseNorthing = 0;
Projdef.falseEasting  = 80000;
Projdef.scaleFactor   = 1.000100;

% Test Values
truelat = dms2degrees([ 43 59 45.82871]);
truelon = -dms2degrees([117 06 22.74797]);
trueN = 82905.08851;
trueE = 71471.15057;

[myE,myN]=ellip2transmercator(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=transmercator2ellip(Ellipdef,Projdef,trueE,trueN);
printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'OCRS Ontario Zone (TRANSVERSE MERCATOR)')
%% Baker Zone (TRANSVERSE MERCATOR)
% NAD83(2011)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6378137;
Ellipdef.f  = 1/298.257222101;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% Baker Zone (Transverse Mercator)
Projdef.latOrigin     = dms2degrees([44 30 0]);
Projdef.lonOrigin     = -dms2degrees([117 50 0]);
Projdef.falseNorthing = 0;
Projdef.falseEasting  = 40000;
Projdef.scaleFactor   = 1.000160;

% Test Values
truelat = dms2degrees([ 44 49 57.80963]);
truelon = -dms2degrees([117 48 54.56244]);
trueN = 36980.20833;
trueE = 41437.60083;

[myE,myN]=ellip2transmercator(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=transmercator2ellip(Ellipdef,Projdef,trueE,trueN);
printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'OCRS Baker Zone (TRANSVERSE MERCATOR)')
%% OCRS North Central
% NAD83(2011)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6378137;
Ellipdef.f  = 1/298.257222101;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% OCRS North Central LCC1SP
Projdef.latOrigin = dms2degrees([46 10 0]);
Projdef.lonOrigin = -dms2degrees([120 30 0]);
Projdef.scaleFactor = 1;      
Projdef.falseEast = 100000.00; % False Easting
Projdef.falseNorth = 140000.00; % False Northing

truelat = dms2degrees([45 45 0]);
truelon = -dms2degrees([119 30 0]);
trueN = 94176.71550;
trueE = 177811.41737;

[myE,myN]=ellip2lcc1sp(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=lcc1sp2ellip(Ellipdef,Projdef,trueE,trueN);
printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'OCRS North Central (LCC 1SP)')
