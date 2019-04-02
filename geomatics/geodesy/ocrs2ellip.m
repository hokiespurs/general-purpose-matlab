function [lat,lon] = ocrs2ellip(E,N,ocrsname)
% OCRS2ELLIP converts from OCRS coords(E,N) to ellipsoid coords (lat,lon)
%   Converts from OCRS projection coordinates to ellipsoid coordinates by
%   using the 'ocrsname' string to determine which zone
% 
% Inputs:
%   - E        : Easting(m)
%   - N        : Northing(m)
%   - ocrsname : Name of OCRS zone
% 
% Outputs:
%   - lat : Latitude (decimal degrees)
%   - lon : Longitude (decimal degrees)
% 
% Examples:
%   [lat,lon] = ocrs2ellip(39123.57959,43885.68277,'Santiam');
% 
% Dependencies:
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
% Date Created  : 15-Mar-2019
% Date Modified : 27-Mar-2019
% Github        : https://github.com/hokiespurs/general-purpose-matlab/tree/master/geomatics/geodesy

%%
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

end

