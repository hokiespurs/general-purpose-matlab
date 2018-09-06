%% test extractProfile
xyStart = [2 3];
xyDirection = 170;
offlinethresh = .25;
downlinethresh = [0 2];
xy = randn(100000,2)*3;
profileinds = extractProfile(xyStart,xyDirection,offlinethresh,downlinethresh,xy);

% plot results
figure(101);clf
plot(xy(~profileinds,1),xy(~profileinds,2),'r.');
hold on
plot(xy(profileinds,1),xy(profileinds,2),'g.');
grid on
axis([-5 5 -5 5])
plot([xyStart(1) xyDirection(1)],[xyStart(2) xyDirection(2)],'k.-','markersize',50,'linewidth',2);
plot([xyStart(1)],[xyStart(2)],'w+','markersize',15,'linewidth',2);