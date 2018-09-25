%% test calcXsAs
% data
pt = [1, 2];
AsAz = 45;

x = rand(3,1)* 3;
y = rand(3,1)* 3;

[Xs,As]=calcXsAs(x,y,pt,AsAz);

% debug
rotangle = 90-AsAz;

figure(1);clf
subplot(1,2,1)
plot(x,y,'k.-');
hold on
plot([pt(1) pt(1)+cosd(rotangle)],[pt(2) pt(2)+sind(rotangle) ],'b.-')
plot([pt(1) pt(1)+cosd(rotangle+90)],[pt(2) pt(2)+sind(rotangle+90) ],'g.-')

axis equal
grid on

subplot(1,2,2);
plot(As,Xs,'k.-');
hold on
plot([0 1],[0 0],'b.-')
plot([0 0],[0 1],'g.-')

axis equal
grid on

%% test inverse calcXsAs
pt = [11, 2];
AsAz = 45;

x = 16;
y = 31;

[Xs,As]=calcXsAs(x,y,pt,AsAz);

[x2,y2]=calcXsAs(Xs,As,pt,AsAz,true)
