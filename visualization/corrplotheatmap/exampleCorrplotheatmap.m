function exampleCorrplotheatmap
%% Test corrplotheatmap
NPTS = 100000;

t = randn(NPTS,1)+rand(NPTS,1);
x = 4.*t + randn(NPTS,1)*2;
y = 0.2.*x.^2 + 3.*x + 4 + rand(NPTS,1)*5;
z = sin(2*t)+randn(NPTS,1)*0.1;
X = [t x y z];
names = {'t','x','y','z'};

figure(1);clf
corrplotheatmap(X,'strlabel',names);
%% Test with different colormap
figure(2);clf
cmap = flipud(jet(1000));
cmap = cmap(200:800,:);
falloff2white = flipud([linspace(cmap(1,1),1,20)'...
    linspace(cmap(1,2),1,20)' linspace(cmap(1,3),1,20)']);
cmap = [falloff2white;cmap];
corrplotheatmap(X,'strlabel',names,'cmap',cmap,'npoly',[0 1 2 1;1 0 2 1;2 2 0 1;1 1 1 0]);

end