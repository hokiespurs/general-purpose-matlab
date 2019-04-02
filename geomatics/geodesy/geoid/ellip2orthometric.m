function [H,N] = ellip2orthometric(lat,lon,h,Geoid)
% ELLIP2ORTHOMETRIC converts ellipsoidal elevation to orthometric height
%   Interpolates geoid seperation values for each position and computes an
%   othometric elevation
%
% Inputs:
%   - lat   : Latitude  (decimal degrees)
%   - lon   : Longitude  (decimal degrees)
%   - h     : Ellipsoidal Elevation
%   - Geoid : Structure for the geoid
%
% Outputs:
%   - H  : Orthometric Elevation
%   - N  : Interpolated Geoid Separation
%
% Examples:
%   [H,N] = ellip2orthometric(34,-119,-30,readGeoid12B);
%
% Dependencies:
%   - n/a
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
% make grid for interpolation
F = griddedInterpolant({Geoid.lat, Geoid.lon},Geoid.separation);

% interpolate geoid separation
N = F(lat,lon);

% orthometric elevation
H = h-N;
end