function examplePointcloud2control
%% CONSTANTS
NPC = 1e6;
NOISE = 0.25;
% beta = [a b c d]  % ax + by + c = z
modelfun3Dplane = @(b,x)(b(1)*x(:,1) + b(2)*x(:,2) + b(3));

%generate Npc data points with X=[-5 5] Y=[-5 5]
rng(1);
truebeta = [-.1 -.5 2]';
xpts = (rand(NPC,1)-0.5)*10;
ypts = (rand(NPC,1)-0.5)*10;
zpts = modelfun3Dplane(truebeta,[xpts ypts]) + randn(NPC,1)*NOISE;

xyzPointcloud = [xpts ypts zpts];
xyzControl = [0 0 modelfun3Dplane(truebeta,[0 0])];

normalRadius = 1.5;
evalRadius = 1.5;
maxDist = 2;
makeNormalZ = false;

%
stats = pointcloud2control(xyzPointcloud, xyzControl, normalRadius, ...
    'evalRadius',evalRadius,'maxDist',maxDist,'makeNormalZ',makeNormalZ);

end