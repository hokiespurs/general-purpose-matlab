%% example axgrid with basic 3x2 grid
f1 = figure(1);
clf
NROWS = 4;dROW = 0.02;
NCOLS = 5;dCOL = 0.01;
[axg,axh] = axgrid(NROWS,NCOLS,dROW,dCOL,0.05,0.7,0.1,0.8);
for r=1:NROWS
    for c=1:NCOLS
        axg(r,c);pcolor(rand(20));
        set(gca,'xtick','');set(gca,'ytick','');
    end
end
f1.InvertHardcopy = 'off';
% saveas(f1,'doc/axgridex1.png');

%% example axgrid basic case
f2 = figure(2);clf
axg = axgrid(2,3,0.05,0.1);
axg(1);pcolor(rand(20));
axg(2,1);pcolor(rand(5));
axg([1 2],[2 3]);hist(randn(1000,1));
f2.InvertHardcopy = 'off';
% saveas(f2,'doc/axgridex2.png');

%% get crazy with it
f3 = figure(3);
axg = axgrid(4,6,0.01,0.01,0.05,0.9,0.05,0.95);
h(1) = axg([1 1],[1 3]);
h(2) = axg([2 2],[2 4]);
h(3) = axg([1 2],[5 5]);
h(4) = axg([2 4],[6 6]);
h(5) = axg(4);
h(6) = axg(6);
h(7) = axg(7);
h(8) = axg([3 4],[1 2]);
h(9) = axg(3,3);
h(10) = axg([4 4],[3 4]);
h(11) = axg(4,5);
h(12) = axg([3 3],[4 5]);
set(h,'xtick','','ytick','');
f3.InvertHardcopy = 'off';
% saveas(f3,'doc/axgridex3.png');

%% Overlay Two axes so you can do two colormaps
f4 = figure(4);clf
axg = axgrid(3,3,0.05,0.2,0.2,0.9,0.1,0.9);

h1 = axg([1 3],[1 2]);
pcolor(peaks(100));shading flat
c2a = colorbar('location','manual','position',...
    [h1.Position(1)+h1.Position(3)+0.05 h1.Position(2) 0.1 h1.Position(4)]);
colormap('gray');

h2a = axg(1,3);
h2b = axg(2,3);
h2c = axg(3,3);

h1b = axg([1 3],[1 2],true);
scatter(rand(100,1)*100,rand(100,1)*100,50,randn(100,1),'filled');
c2b = colorbar('location','south','position',...
    [h1.Position(1) h1.Position(2)-0.15 h1.Position(3) 0.1]);
set(h1b,'visible','off')
colormap(h1b,'jet')
linkaxes([h1 h1b],'xy')
xlim([1 100]);ylim([1 100])
set([h1 h2a h2b h2c h1b],'xtick','','ytick','')
f4.InvertHardcopy = 'off';
% saveas(f4,'doc/axgridex4.png');
