clear
clc
fprintf('\nTesting Each Projection from EPSG \n\n');

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

[myE,myN]=ellip2obliquemercator(Ellipdef,Projdef,truelat,truelon);
[mylat,mylon]=obliquemercator2ellip(Ellipdef,Projdef,trueE,trueN);
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

fprintf('\nTesting OCRS Manually \n\n');

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

[myE,myN]=ellip2obliquemercator(Ellipdef,Projdef,truelat,truelon);

[mylat,mylon]=obliquemercator2ellip(Ellipdef,Projdef,trueE,trueN);

printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,'OCRS Coast Zone(OBLIQUE MERCATOR)')
%% Columbia River West Zone (OBLIQUE  MERCATOR)
% NAD83(2011)
%  - ellipsoid: GRS1980
Ellipdef.a  =  6378137;
Ellipdef.f  = 1/298.257222101;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% Columbia River West Zone (Oblique Mercator)
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

[myE,myN]=ellip2obliquemercator(Ellipdef,Projdef,truelat,truelon);

[mylat,mylon]=obliquemercator2ellip(Ellipdef,Projdef,trueE,trueN);

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

%% Check Each Projection using PRJ files
fprintf('\nTesting All OCRS from PRJ Files \n\n');

truelat = [];truelon = [];trueN = [];trueE = [];

% Baker
truelat{1} =  dms2degrees([ 44 49 57.80936;  44 52 07.48389;  44 40 24.70946]);
truelon{1} = -dms2degrees([117 48 54.56244; 117 54 26.35126; 117 59 40.97048]);
trueN{1} = [36980.20833; 40986.29136; 19299.09877];
trueE{1} = [41437.60083; 34152.16275; 27201.54461];
zonestr{1} = 'Baker';

% Bend-Burns
truelat{2} =  dms2degrees([ 43 12 59.24787;  43 20 57.19424;  43 35 07.15981]);
truelon{2} = -dms2degrees([118 27 03.95863; 119 53 31.05128; 118 57 16.25662]);
trueN{2} = [10796.84894; 24733.52031; 51268.40968];
trueE{2} = [225561.08353; 108487.85026; 184257.38779];
zonestr{2} = 'Bend-Burns';

% Bend-Klamath
truelat{3} =  dms2degrees([ 42 17 19.71674;  42 25 06.01243;  42 12 32.57089]);
truelon{3} = -dms2degrees([121 40 09.54146; 121 13 17.70770; 121 44 50.17150]);
trueN{3} = [59862.74501; 74385.61148; 50997.92871];
trueE{3} = [86655.66105; 123500.38364; 80225.49733];
zonestr{3} = 'Bend-Klamath';

% Bend-Redmond
truelat{4} =  dms2degrees([ 44 15 35.14513;  44 05 37.43097;  44 18 20.44566]);
truelon{4} = -dms2degrees([121 08 52.31624; 121 12 11.97934; 121 33 21.22192]);
trueN{4} = [84783.59542; 66327.93549; 89927.19462];
trueE{4} = [88157.16577; 83738.15165; 55588.29029];
zonestr{4} = 'Bend-Redmond';

% Burns-Harper
truelat{5} =  dms2degrees([ 44 15 00.00000;  43 50 00.00000;  43 40 00.00000]);
truelon{5} = -dms2degrees([117 30 00.00000; 118 30 00.00000; 118 00 00.00000]);
trueN{5} = [83357.53001; 37378.06049; 18573.94894];
trueE{5} = [103313.30456; 22965.20470; 63111.60573];
zonestr{5} = 'Burns-Harper';

% Canyon City-Burns
truelat{6} =  dms2degrees([ 44 00 00.00000;  43 50 00.00000;  43 45 00.00000]);
truelon{6} = -dms2degrees([119 00 00.00000; 118 50 00.00000; 118 55 00.00000]);
trueN{6} = [55565.90294; 37056.89883; 27785.71747];
trueE{6} = [20000.00000; 33408.01218; 26713.32731];
zonestr{6} = 'Canyon City-Burns';

% Canyonville-Grants Pass
truelat{7} =  dms2degrees([ 42 37 15.80562;  42 48 41.75301;  42 47 56.60859]);
truelon{7} = -dms2degrees([123 22 56.67677; 123 35 45.71429; 123 15 10.17963]);
trueN{7} = [13449.63952; 34650.09185; 33226.59339];
trueE{7} = [35973.43780; 18512.47686; 46586.32144];
zonestr{7} = 'Canyonville-Grants Pass';

% Coast Range North
truelat{8} =  dms2degrees([ 45 50 00.00000;  45 40 00.00000;  45 35 00.00000]);
truelon{8} = -dms2degrees([123 10 00.00000; 123 40 00.00000; 123 25 00.00000]);
trueN{8} = [47818.01306; 29292.77904; 20000.00000];
trueE{8} = [49424.91472; 10517.34959; 30000.00000];
zonestr{8} = 'Coast Range North';

% Columbia River East
truelat{9} =  dms2degrees([ 45 36 41.82270;  45 37 22.73728;  45 40 20.31754]);
truelon{9} = -dms2degrees([122 01 15.12506; 121 58 40.65328; 121 52 36.28740]);
trueN{9} = [25007.74017; 26208.05388; 31549.15733];
trueE{9} = [31373.11293; 34742.89853; 42729.28899];
zonestr{9} = 'Columbia River East';

% Columbia River West
truelat{10} =  dms2degrees([ 46 12 17.57866;  45 46 15.02108;  46 10 24.21823]);
truelon{10} = -dms2degrees([123 57 21.88345; 122 51 37.48609; 123 49 55.47899]);
trueN{10} = [218152.78553; 169474.85476; 214545.28450];
trueE{10} = [94514.71992; 179157.87759; 104047.54956];
zonestr{10} = 'Columbia River West';

% Cottage Grove-Canyonville
truelat{11} =  dms2degrees([ 43 12 39.61530;  43 13 57.45207;  43 42 20.44764]);
truelon{11} = -dms2degrees([123 20 29.39067; 123 21 19.11848; 123 14 15.15491]);
trueN{11} = [41957.65613; 44359.97917; 96922.63912];
trueE{11} = [49336.56065; 48214.67944; 57721.03085];
zonestr{11} = 'Cottage Grove-Canyonville';

% Dayville-Prairie City
truelat{12} =  dms2degrees([ 44 30 00.00000;  44 45 00.00000;  44 25 00.00000]);
truelon{12} = -dms2degrees([118 45 00.00000; 119 30 00.00000; 119 15 00.00000]);
trueN{12} = [28162.85184; 55576.32133; 18593.50024];
trueE{12} = [90259.59645; 30559.79476; 50533.39266];
zonestr{12} = 'Dayville-Prairie City';

% Denio-Burns
truelat{13} =  dms2degrees([ 43 25 00.00000;  43 00 00.00000;  42 15 00.00000]);
truelon{13} = -dms2degrees([118 55 00.00000; 118 00 00.00000; 118 25 00.00000]);
trueN{13} = [185297.68973; 138961.36998; 55547.19416];
trueE{13} = [39498.36436; 113981.88003; 80000.00000];
zonestr{13} = 'Denio-Burns';

% Dufur-Madras
truelat{14} =  dms2degrees([ 45 30 08.26496;  44 48 58.86147;  44 51 05.56605]);
truelon{14} = -dms2degrees([121 12 34.44887; 120 41 19.69993; 121 09 28.82604]);
trueN{14} = [111420.55961; 35205.45835; 39082.16381];
trueE{14} = [63619.34714; 104617.66329; 67508.12646];
zonestr{14} = 'Dufur-Madras';

% Eugene
truelat{15} = dms2degrees([   44 03 57.45763;  44 35 07.91068;  44 03 04.40693]);
truelon{15} = -dms2degrees([ 123 05 53.28029; 123 18 16.51921; 123 05 24.25020]);
trueN{15} = [35109.31719;92851.07880;33472.46085];
trueE{15} = [55490.78035;39047.00734;56138.37116];
zonestr{15} = 'Eugene';

% Grants Pass-Ashland
truelat{16} = dms2degrees([  42 06 16.06850;  42 12 56.39712;  42 22 01.47650]);
truelon{16} = -dms2degrees([123 40 53.51268; 122 42 25.17018; 122 52 28.13141]);
trueN{16} = [39431.29476;51915.05751;68646.39250];
trueE{16} = [21197.50808;101719.61390;87798.66183];
zonestr{16} = 'Grants Pass-Ashland';


% Gresham-Warm Springs
truelat{17} = dms2degrees([  45 26 55.28190;  45 27 14.92001;  45 27 35.13762]);
truelon{17} = -dms2degrees([122 08 55.83937; 122 16 12.82641; 122 34 20.65976]);
trueN{17} = [49884.67201; 50476.35587; 51126.42321];
trueE{17} = [24433.12050; 14936.31760; -8699.65627];
zonestr{17} = 'Gresham-Warm Springs';


% Halfway
truelat{18} = dms2degrees([  45 50 00.00000;  45 00 00.00000;  44 44 00.00000]);
truelon{18} = -dms2degrees([117 30 00.00000; 117 15 00.00000; 117 10 00.00000]);
trueN{18} = [134869.77436; 42213.99556; 12579.75429];
trueE{18} = [20573.48558; 40000.00000; 46601.80257];
zonestr{18} = 'Halfway';


% La Grande
truelat{19} = dms2degrees([  45 17 13.18990;  45 17 15.70482;  45 17 48.36576]);
truelon{19} = -dms2degrees([118 00 45.92076; 118 00 43.70866; 117 49 12.11261]);
trueN{19} = [31899.53873; 31977.18073; 33001.29294];
trueE{19} = [38999.15169; 39047.37636; 54118.35633];
zonestr{19} = 'La Grande';

% Medford-Diamond Lake
truelat{20} = dms2degrees([  42 40 00.00000;  43 15 00.00000;  42 45 00.00000]);
truelon{20} = -dms2degrees([122 45 00.00000; 122 00 00.00000; 122 30 00.00000]);
trueN{20} = [14177.49480; 78903.02981; 23346.02212];
trueE{20} = [19005.63839; 80308.03073; 39529.76273];
zonestr{20} = 'Medford-Diamond Lake';

% Mitchell
truelat{21} = dms2degrees([  44 45 00.00000;  44 40 00.00000;  44 30 00.00000]);
truelon{21} = -dms2degrees([119 55 00.00000; 120 16 00.00000; 120 10 00.00000]);
trueN{21} = [40090.37369; 30773.32957; 12253.44199];
trueE{21} = [56396.97808; 28678.17691; 36628.81764];
zonestr{21} = 'Mitchell';

% North Central
truelat{22} = dms2degrees([  45 45 00.00000;  45 35 00.00000;  45 00 00.00000]);
truelon{22} = -dms2degrees([119 30 00.00000; 121 10 00.00000; 120 30 00.00000]);
trueN{22} = [94176.71550; 75380.39919; 10324.07586];
trueE{22} = [177811.41737; 47969.47628; 100000.00000];
zonestr{22} = 'North Central';

% Ochoco Summit
truelat{23} = dms2degrees([  44 30 00.00000;  44 32 00.00000;  44 20 00.00000]);
truelon{23} = -dms2degrees([120 23 00.00000; 120 45 00.00000; 120 40 00.00000]);
trueN{23} = [31131.05996; 34859.28878; 12614.31087];
trueE{23} = [49280.41900; 20124.53891; 26705.17262];
zonestr{23} = 'Ochoco Summit';

% Ontario
truelat{24} = dms2degrees([  43 59 45.82871;  44 01 35.30352;  44 15 30.91593]);
truelon{24} = -dms2degrees([117 06 22.74797; 117 01 02.04955; 117 34 57.00068]);
trueN{24} = [82905.08851; 86278.96757; 112237.85973];
trueE{24} = [71471.15057; 78618.04382; 33478.59685];
zonestr{24} = 'Ontario';

% Oregon Coast
truelat{25} = dms2degrees([  42 50 09.93918;  43 59 00.96460;  45 29 11.43812]);
truelon{25} = -dms2degrees([124 33 47.98916; 124 06 27.69262; 123 58 41.18748]);
trueN{25} = [156617.94338; 283978.89187; 450992.95166];
trueE{25} = [92771.55752; 130114.54983; 140363.83797];
zonestr{25} = 'Oregon Coast';

% Owyhee
truelat{26} = dms2degrees([  43 05 00.00000;  43 00 00.00000;  42 15 00.00000]);
truelon{26} = -dms2degrees([117 04 00.00000; 118 00 00.00000; 117 45 00.00000]);
trueN{26} = [148264.77269; 138959.98063; 55560.09179];
trueE{26} = [112080.13297; 36018.45973; 56243.24291];
zonestr{26} = 'Owyhee';

% Pendleton
truelat{27} = dms2degrees([  45 40 01.47744;  45 40 10.42949;  45 40 22.63117]);
truelon{27} = -dms2degrees([118 46 38.96233; 118 47 29.47552; 118 48 49.44218]);
trueN{27} = [46430.01635; 46701.19336; 47070.05244];
trueE{27} = [90328.59835; 89233.83305; 87501.19269];
zonestr{27} = 'Pendleton';

% Pendleton-La Grande
truelat{28} = dms2degrees([  45 35 58.22564;  45 41 30.56154;  45 40 01.47744]);
truelon{28} = -dms2degrees([118 31 48.55554; 118 51 14.66742; 118 46 38.96233]);
trueN{28} = [57395.64145; 67770.86965; 64984.08945];
trueE{28} = [14641.28669; -10568.75761; -4617.61867];
zonestr{28} = 'Pendleton-La Grande';

% Pilot Rock-Ukiah
truelat{29} = dms2degrees([  45 29 00.00000;  45 08 00.00000;  45 15 00.00000]);
truelon{29} = -dms2degrees([118 50 00.00000; 119 00 00.00000; 118 45 00.00000]);
trueN{29} = [54058.91981; 15141.65609; 28140.54484];
trueE{29} = [63031.42275; 50000.00000; 69628.74874];
zonestr{29} = 'Pilot Rock-Ukiah';

% Portland
truelat{30} = dms2degrees([  45 18 00.17000;  45 29 08.88672;  45 31 23.21213]);
truelon{30} = -dms2degrees([122 58 31.85235; 122 47 50.56450; 122 59 25.84389]);
trueN{30} = [27802.06823; 48423.08858; 52597.11898];
trueE{30} = [82311.82137; 96296.00903; 81209.71492];
zonestr{30} = 'Portland';

% Prairie City-Brogan
truelat{31} = dms2degrees([  44 18 00.00000;  44 34 00.00000;  44 10 00.00000]);
truelon{31} = -dms2degrees([117 50 00.00000; 118 30 00.00000; 118 10 00.00000]);
trueN{31} = [33353.81037; 63098.88578; 18535.62287];
trueE{31} = [73302.59211; 20272.10711; 46667.46504];
zonestr{31} = 'Prairie City-Brogan';

% Riley-Lakeview
truelat{32} = dms2degrees([  43 15 00.00000;  43 00 00.00000;  42 15 00.00000]);
truelon{32} = -dms2degrees([119 52 00.00000; 120 45 00.00000; 120 10 00.00000]);
trueN{32} = [166766.10874; 138964.84335; 55562.03604];
trueE{32} = [107905.98805; 36017.27059; 83757.23849];
zonestr{32} = 'Riley-Lakeview';

% Salem
truelat{33} = dms2degrees([  44 35 07.91068;  44 56 28.31372;  44 58 25.70178]);
truelon{33} = -dms2degrees([123 18 16.51921; 123 06 08.10051; 122 57 20.63967]);
trueN{33} = [28048.57816; 67549.65038; 71181.16936];
trueE{33} = [32429.22836; 48506.92980; 60065.54709];
zonestr{33} = 'Salem';

% Santiam Pass
truelat{34} = dms2degrees([  44 23 05.17700;  44 26 02.55048;  44 45 49.32354]);
truelon{34} = -dms2degrees([121 55 40.80530; 121 56 56.00645; 122 38 12.10401]);
trueN{34} = [33659.19921; 39123.57959; 75623.61352];
trueE{34} = [45587.37939; 43885.68277; -10823.89864];
zonestr{34} = 'Santiam Pass';

% Siskiyou Pass
truelat{35} = dms2degrees([  42 07 00.00000;  42 20 00.00000;  42 00 00.00000]);
truelon{35} = -dms2degrees([122 20 00.00000; 122 40 00.00000; 122 35 00.00000]);
trueN{35} = [17443.38623; 41487.00831; 4451.89751];
trueE{35} = [30678.34448; 3130.86167; 10000.00000];
zonestr{35} = 'Siskiyou Pass';

% Ukiah-Fox
truelat{36} = dms2degrees([  44 35 00.00000;  45 10 00.00000;  44 45 00.00000]);
truelon{36} = -dms2degrees([118 30 00.00000; 118 57 00.00000; 119 00 00.00000]);
trueN{36} = [16024.27164; 80738.59769; 34425.63059];
trueE{36} = [69716.07188; 33931.44990; 30000.00000];
zonestr{36} = 'Ukiah-Fox';

% Wallowa
truelat{37} = dms2degrees([  45 45 00.00000;  45 50 00.00000;  45 25 00.00000]);
truelon{37} = -dms2degrees([117 00 00.00000; 118 00 00.00000; 117 20 00.00000]);
trueN{37} = [55703.23397; 64967.30160; 18540.17710];
trueE{37} = [98913.28813; 21144.66324; 73048.08973];
zonestr{37} = 'Wallowa';

% Warner Highway
truelat{38} = dms2degrees([  42 30 00.00000;  42 00 00.00000;  42 10 00.00000]);
truelon{38} = -dms2degrees([119 30 00.00000; 119 20 00.00000; 120 00 00.00000]);
trueN{38} = [60121.18321; 4663.77396; 22964.13370];
trueE{38} = [81109.33713; 95248.89476; 40000.00000];
zonestr{38} = 'Warner Highway';

% Willamette Pass
truelat{39} = dms2degrees([  44 25 00.00000;  43 35 00.00000;  43 30 00.00000]);
truelon{39} = -dms2degrees([121 50 00.00000; 122 00 00.00000; 121 45 00.00000]);
trueN{39} = [157449.56348; 64821.86466; 55591.56308];
trueE{39} = [33276.75354; 20000.00000; 40223.68195];
zonestr{39} = 'Willamette Pass';

for i=1:numel(zonestr)
    [myE,myN]=ellip2ocrs(truelat{i},truelon{i},zonestr{i});
    [mylat,mylon]=ocrs2ellip(trueE{i},trueN{i},zonestr{i});
    
    printComparison(truelat{i},truelon{i},trueE{i},trueN{i},mylat,mylon,myE,myN,['OCRS ' zonestr{i} ' Zone'],[1e-5,1e-5/3600])
end
