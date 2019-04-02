function geoid12B = readGeoid12B
% READGEOID12B Short summary of this function goes here
%   Detailed explanation goes here
% 
% Inputs:
%   - n/a 
% 
% Outputs:
%   - geoid12B : geoid structure 
% 
% Examples:
%   geoid = readGeoid12B;
%   pcolor(geoid.lon,geoid.lat,geoid.separation);shading flat
% 
% Dependencies:
%   - g2012bu0.bin
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 28-Mar-2019
% Date Modified : 28-Mar-2019
% Github        : https://github.com/hokiespurs/general-purpose-matlab/tree/master/geomatics/geodesy

%% File Format
% SLAT:  Southernmost North latitude in whole degrees. 
%        Use a minus sign (-) to indicate South latitudes. 
% WLON:  Westernmost East longitude in whole degrees. 
% DLAT:  Distance interval in latitude in whole degrees 
%        (point spacing in E-W direction)
% DLON:  Distance interval in longitude in whole degrees 
%        (point spacing in N-S direction)
% NLAT:  Number of rows 
%        (starts with SLAT and moves northward DLAT to next row)
% NLON:  Number of columns 
%        (starts with WLON and moves eastward DLON to next column)
% IKIND: Always equal to one (indicates data are real*4 and endian condition)

fname = 'g2012bu0.bin';

fid = fopen(fname,'r');
h = fread(fid,4,'double','ieee-be');
h = [h; fread(fid,3,'int','ieee-be')];
z = fread(fid,'single','ieee-be');
fclose(fid);

SLAT = h(1);
WLON = h(2);
DLAT = h(3);
DLON = h(4);
NLAT = h(5);
NLON = h(6);

latvecN = SLAT:DLAT:SLAT+DLAT*(NLAT-1);
lonvecW = 360-(WLON:DLON:WLON+DLON*(NLON-1));

geoidSeparation = reshape(z,h(6),h(5))';

geoid12B.separation = geoidSeparation;
geoid12B.lon = -lonvecW;
geoid12B.lat = latvecN;

end