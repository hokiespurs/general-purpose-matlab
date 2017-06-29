function exampleRoundgridfun
close all
%% EXAMPLE 2D
npts1 = 100000;
x = randn(npts1,1)*10;
y = sin(.1*x)*5;
xgi = -30:1:30;

[val,numpts]=roundgridfun(x,y,xgi,@mean);

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
%% Example 2D That Returns and Sorts a Cell Array
npts1b = 1000;
x = randn(npts1b,1)*10;
y = sin(.1*x)*5+randn(npts1b,1);
xgi = -30:1:30;

[val,numpts]=roundgridfun(x,y,xgi,@(x) {sort(x)});

%turn all data into a matrix from a 
maxpts = max(numpts(:));
A = nan(numel(xgi),maxpts);
for i=1:numel(val)
    A(i,1:numpts(i)) = cell2mat(val(i));
end
f = figure;
pcolor(1:maxpts,xgi,A);
ylabel('Grid Bin','fontsize',18,'interpreter','latex');
xlabel('Point Number','fontsize',18,'interpreter','latex');
title('Organize All Data Into Sorted Bins','fontsize',20,'interpreter','latex')
%% EXAMPLE 3D
npts2 = 10000;
x = rand(npts2,1)*10;
y = rand(npts2,1)*10;
z = x.*y;
xgi = 0:1:10; ygi = 0:1:10;

val=roundgridfun(x,y,z,xgi,ygi,@min); % Minimum Z Surface

figure('units','normalized','outerposition',[0.5 0.5 0.5 0.5]);
pcolor(xgi,ygi,val);
title('3D Case Minimum Z Surface');
title('Minimum Z Surface','fontsize',20,'interpreter','latex')

xlabel('x','interpreter','latex','fontsize',16);
ylabel('y','interpreter','latex','fontsize',16);
c = colorbar;ylabel(c,'minimum Z','fontsize',16,'interpreter','latex');
drawnow

%% EXAMPLE 4D *uses meshgrid array
x = rand(100000,1)*10;
y = rand(100000,1)*10;
z = rand(100000,1)*10;
I=x.^2.*y.*z;
xgi = 0:1:10;
ygi = 0:1:10;
zgi = 0:1:10;
[xg,yg,zg]=meshgrid(xgi,ygi,zgi);
val=roundgridfun(x,y,z,I,xg,yg,zg,@std); % Mean Intensity voxels
figure;
slice(val,6,8,3)
xlabel('x','interpreter','latex','fontsize',16);
ylabel('y','interpreter','latex','fontsize',16);
zlabel('z','interpreter','latex','fontsize',16);
title('Voxelized Gridding','fontsize',20,'interpreter','latex')

%% Example 5D
npts4 = 100000;
xn = randn(npts4,5)*2+5;
xni = 1:1:9;
[xg1,xg2,xg3,xg4]=ndgrid(xni,xni,xni,xni);
[val,numpts]=roundgridfun(xn(:,1),xn(:,2),xn(:,3),xn(:,4),xn(:,5),...
    xg1,xg2,xg3,xg4,@std);%interstellar dimensions

figure('units','normalized','outerposition',[0.5 0 0.5 0.5]);drawnow
for i=1:9
    subplot(3,3,i)
    slice(numpts(:,:,:,i),6,8,3);
    caxis([0 100])
    title(sprintf('t=%.0f',i),'interpreter','latex','fontsize',14)
    xlabel('x','interpreter','latex','fontsize',16);
    ylabel('y','interpreter','latex','fontsize',16);
    zlabel('z','interpreter','latex','fontsize',16);
%     c = colorbar;ylabel(c,'number of points');drawnow
end
subplot 332;title('5D Interstellar Dimensions');

end