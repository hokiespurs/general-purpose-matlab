function exampleIdw
%% EXAMPLE 1D
npts1 = 100000;
x = randn(npts1,1)*10;
y = sin(.1*x)*5;
xgi = -30:1:30;

[val,numpts]=idw(x,y,xgi,0.5);

figure('units','normalized','outerposition',[0 0.5 0.5 0.5]);
h1=subplot(2,1,1); 
plot(xgi,val,'.-');
title('2D Case Mean Values ($y = 5\sin(x/10)$)','interpreter','latex','fontsize',16);
ylabel('Mean Y Value','interpreter','latex','fontsize',16);
h2=subplot(2,1,2); 
plot(xgi,numpts,'.-');
title('Number of Points','interpreter','latex','fontsize',16);
linkaxes([h1 h2],'x');
xlim([min(xgi) max(xgi)])
xlabel('x','interpreter','latex','fontsize',16);
ylabel('Number of Points','interpreter','latex','fontsize',16);
drawnow
%% EXAMPLE 2D
RADIUS = 1;
POWER = -2;
x = randn(10000,1)*2;
y = randn(10000,1)*1;
z = sin(10*x) + cos(5*y);
[xg,yg]=meshgrid(-5:.1:5,-5:.1:5);

[zgrid, npts] = idw(x,y,z,xg,yg,RADIUS,POWER);

figure(1)
subplot 121
pcolor(xg,yg,zgrid);shading flat;axis equal
axis equal
xlim([-5 5]);
ylim([-5 5]);
xlabel('x','fontsize',16,'interpreter','latex');
ylabel('y','fontsize',16,'interpreter','latex');
title('Value Computed with IDW','interpreter','latex','fontsize',18)
colorbar

subplot 122
pcolor(xg,yg,npts);shading flat;axis equal
axis equal
xlim([-5 5]);
ylim([-5 5]);
xlabel('x','fontsize',16,'interpreter','latex');
title('Number of Points','interpreter','latex','fontsize',18)
colorbar
%% EXAMPLE 2D
npts2 = 10000;
x = rand(npts2,1)*10;
y = rand(npts2,1)*10;
z = x.*y;
xgi = 0:1:10;
ygi = 0:1:10;
[xg,yg]=meshgrid(xgi,ygi);
val=idw(x,y,z,xg,yg,0.5,-1);

figure('units','normalized','outerposition',[0.5 0.5 0.5 0.5]);
pcolor(xgi,ygi,val);
title('3D Case Minimum Z Surface');
title('Z Surface','fontsize',20,'interpreter','latex')

xlabel('x','interpreter','latex','fontsize',16);
ylabel('y','interpreter','latex','fontsize',16);
c = colorbar;ylabel(c,'minimum Z','fontsize',16,'interpreter','latex');
drawnow

%% EXAMPLE 3D *uses meshgrid array
x = rand(100000,1)*10;
y = rand(100000,1)*10;
z = rand(100000,1)*10;
I=x.^2.*y.*z;
xgi = 0:1:10;
ygi = 0:1:10;
zgi = 0:1:10;
[xg,yg,zg]=meshgrid(xgi,ygi,zgi);
val=idw(x,y,z,I,xg,yg,zg,0.5); % Mean Intensity voxels
figure;
slice(val,6,8,3)
xlabel('x','interpreter','latex','fontsize',16);
ylabel('y','interpreter','latex','fontsize',16);
zlabel('z','interpreter','latex','fontsize',16);
title('Voxelized Gridding','fontsize',20,'interpreter','latex')

%% Example 4D
npts4 = 100000;
xn = randn(npts4,5)*2+5;
xni = 1:1:9;
[xg1,xg2,xg3,xg4]=ndgrid(xni,xni,xni,xni);
[val,numpts]=idw(xn(:,1),xn(:,2),xn(:,3),xn(:,4),xn(:,5),...
    xg1,xg2,xg3,xg4,0.5);% interstellar dimensions

figure('units','normalized','outerposition',[0.5 0 0.5 0.5]);drawnow
for i=1:9
    subplot(3,3,i)
    slice(numpts(:,:,:,i),6,8,3);
    caxis([0 100])
    title(sprintf('t=%.0f',i),'interpreter','latex','fontsize',14)
    xlabel('x','interpreter','latex','fontsize',16);
    ylabel('y','interpreter','latex','fontsize',16);
    zlabel('z','interpreter','latex','fontsize',16);
end
subplot 332;title('5D Interstellar Dimensions');



end