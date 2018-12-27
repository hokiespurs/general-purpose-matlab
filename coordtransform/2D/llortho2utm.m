function [e,n,Iutm]=llortho2utm(lat,lon,Ill)
% regrids the image to easting northing, nodata = white

[long,latg]=meshgrid(lon,lat);

[ellg,nllg]=deg2utm(latg(:),long(:));
ellg = reshape(ellg,size(long));
nllg = reshape(nllg,size(long));

dE = abs(median(median(diff(ellg'))));
dN =  abs(median(median(diff(nllg))));

dx = mean([dE dN]);

e = min(ellg(:)):dx:max(ellg(:));
n = min(nllg(:)):dx:max(nllg(:));

[eg,ng] = meshgrid(e,n);
npts = numel(Ill(:,:,1));
RF = scatteredInterpolant(ellg(:),nllg(:),reshape(double(Ill(:,:,1)),npts,1),'natural','none');
GF = scatteredInterpolant(ellg(:),nllg(:),reshape(double(Ill(:,:,2)),npts,1),'natural','none');
BF = scatteredInterpolant(ellg(:),nllg(:),reshape(double(Ill(:,:,3)),npts,1),'natural','none');

R = uint8(RF(eg,ng));
G = uint8(GF(eg,ng));
B = uint8(BF(eg,ng));

Iutm = cat(3,R,G,B);

end