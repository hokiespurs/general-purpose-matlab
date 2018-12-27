%% test WMS
E = [450000 480000];
N = [4910000 4940000];

zone = '10 T';
z = 11;

[Evector2,Nvector2,Zg] = getTerraUtm(E,N,zone,z,'dodebug',true);
[Evector,Nvector,Iortho] = getWMSutm(E,N,zone,z,'dodebug',true);

figure(10);clf
imagesc(Evector,Nvector,Iortho);
hold on
plot([E(1) E(1) E(2) E(2) E(1)],...
     [N(1) N(2) N(2) N(1) N(1)],'r-');
set(gca,'ydir','normal');
%
[M,N,P]=size(Iortho);
%%
figure(11);clf
surface(Evector,Nvector,Zg,Iortho,...
    'FaceColor','texturemap',...
    'EdgeColor','none',...
    'CDataMapping','direct');
zlim([0 4000])
view(35,45)
%%
