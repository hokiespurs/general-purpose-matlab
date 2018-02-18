function test_stereonet(az,slope)
% TODO: 
%  - maybe chagne gridding algorithm
%  - add option for smoothing
%  - plot in cartesian rather than polar coords?
%  - inputParser
%  - matlab slope/azimuth computations rather than CloudCompare?
%  - pick better colorbar
%  - way more documentation
%
% INPUTS:
%   slope in degrees (0-90)
%   az in degrees (0-360)
%% EXAMPLE DATA
if nargin==0
    NPTS = 1000000;
    az = randn(NPTS,1)*10 + 20;
    slope = randn(NPTS,1)*5 + 30;
end
%% CONSTANTS
AZRANGE = [0 360];
DAZ = 1;
SLOPERANGE = [0 90];
DSLOPE = 1;
CMAP = hot(256);
CMAPLOG = false;
% grid
GRIDLINECOLOR = [1-eps, 1, 1]; %stupid matlab doesnt like saving pure white
GRIDLABELCOLOR = [1-eps, 1, 1];%stupid matlab doesnt like saving pure white
SLOPEGRIDLABELSIZE = 18;
SLOPEGRIDVALS = 10:10:80;
AZGRIDVALS = 0:45:315;
AZGRIDLABELS = {'N','NE','E','SE','S','SW','W','NW'};
AZGRIDLABELPAD = 7;
AZGRIDLABELCOLOR = 'k';
AZGRIDLABELFONTSIZE = 24;
%% Convert all azimuth data to (0-360)
az(az<0)=az(az<0)+360;

%% Set up Values to Grid to
azGridVals = AZRANGE(1)+DAZ/2:DAZ:AZRANGE(2)-DAZ/2;
slopeGridVals = SLOPERANGE(1)+DSLOPE/2:DSLOPE:SLOPERANGE(2)-DSLOPE/2;

[slopeGrid, azGrid] = meshgrid(slopeGridVals,azGridVals);

%% Grid Data
ptsPerCell = roundgridfun(az,slope,ones(size(az)),azGrid,slopeGrid,@numel);

%% Set up Plotting Grid
% Pad grid so that pcolor works... pcolor is weird and cuts off edges
azPlotVals = AZRANGE(1):DAZ:AZRANGE(2);
slopePlotVals = SLOPERANGE(1):DSLOPE:SLOPERANGE(2);
[slopePlotGrid, azPlotGrid] = meshgrid(slopePlotVals,azPlotVals);

padPtsPerCell = padarray(ptsPerCell,[1 1],'replicate','post')';

% Convert to cartesian coordinates
[xgPlot,ygPlot]=pol2cart((90-azPlotGrid)*pi/180,slopePlotGrid);
%% Pcolor Data
pcolor(xgPlot,ygPlot,padPtsPerCell);
shading flat
axis equal
axis off
hold on

%% Colorbar
hc = colorbar;
ylabel(hc,'Number of Points','fontsize',20)

colormap(CMAP);
if CMAPLOG
    caxis(log([0 max(ptsPerCell(:))]));
    c = get(hc,'Ytick');
    set(hc,'FontSize',20,'YTick',c,'TickLabels',round(10.^c));
end

%% Make and Label Grid
% slope rings
for i=1:numel(SLOPEGRIDVALS)
    r = SLOPEGRIDVALS(i);
    rectangle('Position',[-r -r 2*r 2*r],'Curvature',[1 1],'edgecolor',GRIDLINECOLOR);
    text(r,0,sprintf('%.0f°',r),'Color',GRIDLABELCOLOR,'VerticalAlignment','Bottom',...
        'fontsize',SLOPEGRIDLABELSIZE)
end
% azimuth rays
for i=1:numel(AZGRIDVALS)
    islope = [0 90];
    iaz = [AZGRIDVALS(i) AZGRIDVALS(i)];
    [ix,iy]=pol2cart((90-iaz)*pi/180,islope);
    plot(ix,iy,'color',GRIDLINECOLOR)
    
    [ixlabel,iylabel] = pol2cart((90-iaz(1))*pi/180,90+AZGRIDLABELPAD);
    text(ixlabel,iylabel,AZGRIDLABELS{i},'Color',AZGRIDLABELCOLOR,...
        'HorizontalAlignment','center','VerticalAlignment','middle',...
        'fontsize',AZGRIDLABELFONTSIZE)
end

end