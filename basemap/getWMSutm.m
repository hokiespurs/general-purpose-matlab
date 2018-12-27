function [Evector,Nvector,Iortho] = getWMSutm(E,N,zone,z,varargin)
%%
% regrids to rectilinear E,N
% requires deg2utm, utm2deg, and llortho2utm

% convert E,N to Lat,Lon
if size(zone,1)==1
    zone = repmat(zone,numel(E),1); % handle zone issue
end

[lat,lon]=utm2deg(E,N,zone);
lat = [min(lat) max(lat)];
lon = [min(lon) max(lon)];

% convert Lat, Lon to E,N
[latvector,lonvector,Iortholl] = getWMSll(lat(:),lon(:),z,varargin{:});

% convert ll image to utm
[Evector,Nvector,Iortho] = llortho2utm(latvector,lonvector,Iortholl);
end