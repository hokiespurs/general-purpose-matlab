function [E,N] = ellip2ocrs(lat,lon,ocrsname)
% ELLIP2OCRS converts from ellipsoid coords (lat,lon) to OCRS coords(E,N)
%   Converts from ellipsoid coordinates to OCRS projection coordinates by
%   using the 'ocrsname' string to determine which zone
% 
% Inputs:
%   - lat      : Latitude (decimal degrees)
%   - lon      : Longitude (decimal degrees)
%   - ocrsname : Name of OCRS zone
% 
% Outputs:
%   - E : Easting (m)
%   - N : Northing (m)
% 
% Examples:
%   [E,N] = ellip2ocrs(43,-120.75,'Riley');
% 
% Dependencies:
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
% Date Created  : 15-Mar-2019
% Date Modified : 27-Mar-2019
% Github        : https://github.com/hokiespurs/general-purpose-matlab/tree/master/geomatics/geodesy

%%
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

end

