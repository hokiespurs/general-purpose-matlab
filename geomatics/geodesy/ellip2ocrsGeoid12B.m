function [E,N,H] = ellip2ocrsGeoid12B(lat,lon,h,ocrsname)
% ELLIP2OCRSGEOID12B Converts ellipsoid coords to OCRS and applies geoid12B
%   Converts from Ellipsoid (Lat,Lon) to OCRS Projection (E,N)
%   Converts Elevation from Ellipsoidal(h) to Orthometric(H) using Geoid12B
% 
% Inputs:
%   - lat      : Latitude  (decimal degrees)
%   - lon      : Longitude  (decimal degrees)
%   - h        : Ellipsoidal Elevation
%   - ocrsname : Name of OCRS zone
% 
% Outputs:
%   - E : Easting (m)
%   - N : Northing (m)
%   - H : Orthometric Height (m)
% 
% Examples:
%   [E,N,H] = ellip2ocrsGeoid12B(43,-120.75,10,'Riley-Lakeview');
% 
% Dependencies:
%   - ellip2ocrsGeoid12B.m
%   - ellip2orthometric.m
%   - g2012bu0.bin
%   - readGeoid12B.m
%   - getOCRS.m
%   - readPRJfile.m
%   - ellip2lcc1sp.m
%   - ellip2lcc2sp.m
%   - ellip2obliquemercator.m
%   - ellip2transmercator.m
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
% project coordinates
[Projdef,Ellipdef,type] = getOCRS(ocrsname);

switch type
    case 'lcc1sp'
        fun = @ellip2lcc1sp;
    case 'lcc2sp'
        fun = @ellip2lcc2sp;
    case 'tm'
        fun = @ellip2transmercator;
    case 'om'
        fun = @ellip2obliquemercator;
end
[E,N]=fun(Ellipdef,Projdef,lat,lon);

% apply geoid
Geoid = readGeoid12B;
H = ellip2orthometric(lat,lon,h,Geoid);

end