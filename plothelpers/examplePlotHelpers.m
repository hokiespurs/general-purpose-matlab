function examplePlotHelpers
%% Example Script Demonstrating how to use many of the plot helpers
fname = 'yyyy_mm_dd_Data';
f = figure(1);clf
%AXGRID: Make a Grid of subplots
axg = axgrid(4,4,0.075,0.075,0.1,0.8,0.1,0.8);
h = nan(1,5);
hb = nan(1,2);
h(1) = axg(1);pcolor(peaks(100));shading flat
h(2) = axg(2);pcolor(peaks(100));shading flat
h(3) = axg(2,1);pcolor(peaks(100));shading flat
h(4) = axg(2,2);pcolor(peaks(100));shading flat
h(5) = axg([3 4],[1 2]);plot(rand(10))

hb(1) = axg([1 4],[3 3]);plot(rand(10),'b.')
hb(2) = axg([1 4],[4 4]);plot(rand(10),'r.')

%BIGTITLEAX: Use axes to make a big title
bigtitleax('Left Side',h,0.01,'fontsize',16,'interpreter','latex');
bigtitleax('Strong Side',hb,0.01,'fontsize',16,'interpreter','latex');
%FIXFIGSTRING: fix the underscore values in the filename
%BIGTITLE: Explicitly define the location of a title
bigtitle(fixfigstring(fname),0.5,0.9,'fontsize',20,'interpreter','latex')

set(h,'xtick','','ytick','')
%BIGCOLORBARAX: Make a colorbar that aligns with each of the axes
[c,cax] = bigcolorbarax(h([1 3]),0.0125,0.05,'');
set(c,'ytick','');
colormap('gray')

%LINKAX the top 4 plots x,y, and caxis limits
linkax([h(1:4) cax],{'CLim'});
linkax(h([1 3]),'XLim');
linkax(h([1 2]),'YLim');
caxis([-5 5])

%make bigcolorbar for right 2 plots
c = bigcolorbarax(hb,0.01,0.05,'color label','fontsize',20);
colormap(c,jet(256))
f.InvertHardcopy = 'off';
% saveas(f,'doc/examplePlotHelpers.png');

end