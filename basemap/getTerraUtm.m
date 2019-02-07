function [Evector,Nvector,Zg] = getTerraUtm(E,N,zone,z,varargin)
% (red * 256 + green + blue / 256) - 32768
[Evector,Nvector,Iortho] = getWMSutm(E,N,zone,z,'servername','terra',varargin{:});

Zg = (double(Iortho(:,:,1)) * 256 + double(Iortho(:,:,2)) + double(Iortho(:,:,3)) / 256) - 32768;
Zg(Zg==-32768)=nan;
end