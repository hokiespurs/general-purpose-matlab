% show difference between WGS84 and NAD83 over a small area
lat = [  44.459496, 44.659496];
lon = [-123.381359, -123.181359];
[latvector,lonvector,Iortho] = getWMSll(lat,lon,11);
[latvector2,lonvector2,Zortho] = getTerraLatLon(lat,lon,11);
%% Make CSV w/ lat-lon-h
[latgrid,longrid]=meshgrid(latvector,lonvector);
fid = fopen('NAD83.txt','w');
fprintf(fid,'%20.15f,%20.15f,%15.6f\n',[longrid(:) latgrid(:) Zortho(:)]');
fclose(fid);

%% VDATUM
% data processed in VDATUM
% source: NAD83(2011/2007...)
% target: ITRF2008
% soords lat/lon,ellip
% 
% input_epoch  = 2010.0
% output_epoch = 2005.0
%
% output in result folder

%% Read Data
wgs84 = importdata('result/NAD83.txt');

%% Convert to OCRS
[wgs84x,wgs84y] = ellip2ocrs(wgs84(:,2),wgs84(:,1),'salem');
wgs84h = wgs84(:,3);

[nad83x,nad83y] = ellip2ocrs(latgrid(:),longrid(:),'salem');
nad83h = Zortho(:);

%% convert to grid again
ocrsx = reshape(nad83x,size(latgrid));
ocrsy = reshape(nad83y,size(latgrid));

%% Compute Deltas
dx = nad83x-wgs84x;
dy = nad83y-wgs84y;
dh = nad83h-wgs84h;

dx = reshape(dx,size(latgrid));
dy = reshape(dy,size(latgrid));
dh = reshape(dh,size(latgrid));

%% smooth dx,dy,dh
dx = imgaussfilt(dx, 3);
dy = imgaussfilt(dy, 3);
dh = imgaussfilt(dh, 3);

%%
figure(1);clf
axg = axgrid(2,3,0.05,0.125,0.05,0.9,0.05,0.95);
axg(1);
imagesc(lonvector,latvector,Iortho)
set(gca,'ydir','normal');
axis equal
axis tight
title('Corvallis Basemap','interpreter','latex','fontsize',16);
xlabel('Longitude','interpreter','latex','fontsize',14);
ylabel('Latitude','interpreter','latex','fontsize',14);

axg(4);
pcolor(lonvector,latvector,Zortho);shading flat
set(gca,'ydir','normal');
axis equal
axis tight
title('Corvallis Elevations','interpreter','latex','fontsize',16);
xlabel('Longitude','interpreter','latex','fontsize',14);
ylabel('Latitude','interpreter','latex','fontsize',14);

axg(2);
pcolor(ocrsx,ocrsy,dx);shading flat
set(gca,'ydir','normal');
axis equal
axis tight
set(gca,'ticklabelinterpreter','latex','fontsize',12);
title('OCRS $\Delta$x (NAD83-WGS84)','interpreter','latex','fontsize',16);
xlabel('OCRS (Salem) Easting(m)','interpreter','latex','fontsize',14);
ylabel('OCRS (Salem) Northing(m)','interpreter','latex','fontsize',14);
xticklabels({'25km','30km','35km','40km','45km','50km'})
yticklabels({'5km','10km','15km','20km','25km','30km','35km','40km'})

c = colorbar;
ylabel(c,'$\Delta x(m)$','interpreter','latex','fontsize',16);
hold on
cax = caxis;
newcax = round(cax,3);
caxis(newcax);
contour(reshape(nad83x,size(dx)),reshape(nad83y,size(dx)),dx,newcax(1):0.001:newcax(2),'k','ShowText','on');

axg(3);
pcolor(ocrsx,ocrsy,dy);shading flat
set(gca,'ydir','normal');
axis equal
axis tight
set(gca,'ticklabelinterpreter','latex','fontsize',12);
title('OCRS $\Delta$y (NAD83-WGS84)','interpreter','latex','fontsize',16);
xlabel('OCRS (Salem) Easting(m)','interpreter','latex','fontsize',14);
ylabel('OCRS (Salem) Northing(m)','interpreter','latex','fontsize',14);
xticklabels({'25km','30km','35km','40km','45km','50km'})
yticklabels({'5km','10km','15km','20km','25km','30km','35km','40km'})

c = colorbar;
ylabel(c,'$\Delta y(m)$','interpreter','latex','fontsize',16);
hold on
cax = caxis;
newcax = round(cax,3);
caxis(newcax);
contour(reshape(nad83x,size(dx)),reshape(nad83y,size(dx)),dy,newcax(1):0.001:newcax(2),'k','ShowText','on');

axg(5);
pcolor(ocrsx,ocrsy,dh);shading flat
set(gca,'ydir','normal');
axis equal
axis tight
set(gca,'ticklabelinterpreter','latex','fontsize',12);
title('OCRS $\Delta$h (NAD83-WGS84)','interpreter','latex','fontsize',16);
xlabel('OCRS (Salem) Easting(m)','interpreter','latex','fontsize',14);
ylabel('OCRS (Salem) Northing(m)','interpreter','latex','fontsize',14);
xticklabels({'25km','30km','35km','40km','45km','50km'})
yticklabels({'5km','10km','15km','20km','25km','30km','35km','40km'})

c = colorbar;
ylabel(c,'$\Delta h(m)$','interpreter','latex','fontsize',16);
hold on
cax = caxis;
newcax = round(cax,3);
caxis(newcax);
contour(reshape(nad83x,size(dx)),reshape(nad83y,size(dx)),dh,newcax(1):0.001:newcax(2),'k','ShowText','on');

% meandx = nanmean(ddx)./diff(nad83x
axg(6);
set(gca,'visible','off')
text(0,0.7,'$\dot{\Delta x}$ = 1mm/4.5km','interpreter','latex','fontsize',24)
text(0,0.5,'$\dot{\Delta y}$ = 1mm/7.0km','interpreter','latex','fontsize',24)
text(0,0.3,'$\dot{\Delta h}$ = 1mm/3.0km','interpreter','latex','fontsize',24)

bigtitle('NAD83(2011) Epoch 2010.0 vs WGS84(G1674)/ITRF2008/IGS08 Epoch 2005.0',...
    0.5,0.95,'fontsize',30,'interpreter','latex');