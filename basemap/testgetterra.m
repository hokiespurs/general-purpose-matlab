%%
lat = [15 60];
lon = [-130 -50];
z = 2;

[latvec,lonvec,Zg] = getTerraLatLon(lat,lon,z,'override',true,'dodebug',2);

figure(10);
pcolor(lonvec,latvec,Zg);shading flat
axis equal