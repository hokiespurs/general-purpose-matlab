function [latvector,lonvector,Zg] = getTerraLatLon(lat,lon,z,varargin)
%% Grab and parse the mapzen terrain tiles and convert to DTM
%
% (red * 256 + green + blue / 256) - 32768
% terrazen elevation
[latvector,lonvector,Iortho] = getWMSll(lat,lon,z,'servername','terra',varargin{:});

Zg = (double(Iortho(:,:,1)) * 256 + double(Iortho(:,:,2)) + double(Iortho(:,:,3)) / 256) - 32768;

end