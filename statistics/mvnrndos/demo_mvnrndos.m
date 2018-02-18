covXY = [0.2 0.3;0.3 0.9];
u = [0 0];
N = 10000;
for i=1:10
tic;
xy = mvnrnd(u,covXY,N);
dt = toc;
tic;
xy2 = mvnrnd_os(u,covXY,N);
dt2 = toc;

fprintf('DT: %10.5g \n',dt-dt2);
figure(1);clf
plot(xy(:,1),xy(:,2),'r.');
hold on
plotCovEllip(covXY,'confidence',0.95);
axis equal
end