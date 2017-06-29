%% Example heatmapscat
NPTS = 1000000;
x = rand(NPTS,1)*100;
y = 5 + rand(NPTS,1).*x/10 + 9*randn(NPTS,1);
figure(1);clf
subplot 121
plot(x,y,'b.','markersize',1)
xlim([0 100]);
ylim([-50 50]);
subplot 122
xi = 0:1:100;
yi = -50:1:50;
heatmapscat(x,y,xi,yi);