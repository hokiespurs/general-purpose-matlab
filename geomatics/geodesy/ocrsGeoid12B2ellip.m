function [lat,lon,h]=ocrsGeoid12B2ellip(E,N,H,ocrsname)
% OCRSGEOID12B2ELLIP Converts from OCRS orthometric H to ellipsoidal coords
%   Converts from OCRS to lat,lon ellipsoidal coordinates
%   Converts from Geoid12B Orthometric elevation to ellipsoidal elevations
% 
% Inputs:
%   - E        : Easting (m)
%   - N        : Northing (m)
%   - H        : Orthometric Height (m)
%   - ocrsname : Name of OCRS zone
% 
% Outputs:
%   - lat   : Latitude  (decimal degrees)
%   - lon   : Longitude  (decimal degrees)
%   - h     : Ellipsoidal Elevation
% 
% Examples:
%   [lat,lon,h]=ocrsGeoid12B2ellip(36000,139000,31,'Riley-Lakeview')
% 
% Dependencies:
%   - ellip2orthometric.m
%   - g2012bu0.bin
%   - readGeoid12B.m
%   - ocrsGeoid12B2ellip.m
%   - getOCRS.m
%   - readPRJfile.m
%   - lcc1sp2ellip.m
%   - lcc2sp2ellip.m
%   - obliquemercator2ellip.m
%   - transmercator2ellip.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 28-Mar-2019
% Date Modified : 28-Mar-2019
% Github        : https://github.com/hokiespurs/general-purpose-matlab/tree/master/geomatics/geodesy

%%
% ocrs -> ellipsoid horizontal coordinates
[Projdef,Ellipdef,type] = getOCRS(ocrsname);

switch type
    case 'lcc1sp'
        fun = @lcc1sp2ellip;
    case 'lcc2sp'
        fun = @lcc2sp2ellip;
    case 'tm'
        fun = @transmercator2ellip;
    case 'om'
        fun = @obliquemercator2ellip;
end
[lat,lon]=fun(Ellipdef,Projdef,E,N);

% orthometric height -> ellipsoidal elevation
Geoid = readGeoid12B;
[~,N] = ellip2orthometric(lat,lon,0,Geoid);
h = H + N;
end