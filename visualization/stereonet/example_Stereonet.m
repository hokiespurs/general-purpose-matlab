% date are output from cloudcompare after dip and dip direction are
% converted to SFs
dat10 = importdata('VS_10cm.txt');
dat50 = importdata('VS_50cm.txt');
dat100 = importdata('VS_100cm.txt');

%%
figure(1);clf
az = dat10.data(:,11);
slope = dat10.data(:,10);
test_stereonet(az,slope);
% caxis([0 10000])

%% Compare
% NEED TO CLEAN THESE UP TO LOOK BETTER

% 10cm
f2 = figure(2);clf;
az = dat10.data(:,11);
slope = dat10.data(:,10);
test_stereonet(az,slope);
axis([-35 35 -35 35]);
title('10cm Window')

% 50cm
f3 = figure(3);clf;
az = dat50.data(:,11);
slope = dat50.data(:,10);
test_stereonet(az,slope);
axis([-35 35 -35 35]);
title('50cm Window')

% 100cm
f4 = figure(4);clf;
az = dat100.data(:,11);
slope = dat100.data(:,10);
test_stereonet(az,slope);
axis([-35 35 -35 35]);
title('100cm Window')

f2.Name = '10cm';
f3.Name = '50cm';
f4.Name = '100cm';

set(f2,'WindowStyle','docked');
set(f3,'WindowStyle','docked');
set(f4,'WindowStyle','docked');

saveas(f2,'10cm.png')
saveas(f3,'50cm.png')
saveas(f4,'100cm.png')

