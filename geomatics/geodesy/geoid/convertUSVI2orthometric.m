function zorthometric = convertUSVI2orthometric(E,N,zellip)

utmstr = repmat('20 Q',size(E));
[lat,lon]=utm2deg(E,N,utmstr);

geoid12B = readGeoid12BUSVI;

zorthometric=ellip2orthometric(lat,lon,zellip,geoid12B);

end

% %%
% indlat = 168:169;
% indlon = 263:264;
% 
% geoid12B = readGeoid12BUSVI;
% [latg,long]=meshgrid(geoid12B.lat(indlat),geoid12B.lon(indlon));
% [Eg,Ng]=deg2utm(latg(1:3),long(1:3));
% 
% Zg = geoid12B.separation(indlat,indlon);
% Z = Zg(1:3)';
% 
% 
% eplot = [eo.E];
% nplot = [eo.N];
% figure(1);clf
% plot(Eg,Ng,'b.-','markersize',20);
% hold on
% scatter(Eg,Ng,50,Z,'filled');
% plot(eplot,nplot,'r.')
% colorbar
% 
% %%
% E=[326861.913030819 328629.014225691 326877.984097131];
% N=[1966968.50599487 1966953.19495486 1968813.01546706];
% 
% B = [ones(3,1) E(:) N(:)] \ Z';
% 
% a = B(2);
% b = B(3);
% c = B(1);
% 
% a.*E + b.*N + c;
% 
