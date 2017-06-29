function [ax,p] = colorbarangle(pos,varargin)
% COLORBARANGLE creates a circular colorbar to depict angular measurements
%   Colorbar angle makes a circular colorbar anywhere in the figure in
%   order to help depict the angular measurements in a pcolor or imagesc
%   plot.  
% 
% Inputs:
%   - pos : 4 Element Position vector for the colorbar
%
% Optional Inputs:
% - 'nslices'         : Number of slices in the colorbar circle
% - 'cmap'            : colormap to use
% - 'tick'            : tick values for where lines/text will be added
% - 'ticklabel'       : label to add at the tick values
% - 'ticklinecolor'   : line color for the tick values
% - 'ticklabelcolor'  : text color for the tick labels
% - 'ticklinewidth'   : linewidth for the tick line
% - 'cax'             : limits of the colorbar
% - 'doazimuth'       : convert angle to azimuth or leave as math angles
% - 'textscalefactor' : distance of tick label from edge of colorbar
% - 'tickfontsize'    : font size to use for tick labels
%
%  * tick properties can be either a scalar, which will apply to all tick
%  values, or a vector with an element for each tick value
%
% Outputs:
%   - ax : Description of variable goes here
%   - p  : Description of variable goes here
% 
% Examples:
%   figure(1);clf;
%   colorbarangle([0.2 0.2 0.6 0.6]);
% 
% Dependencies:
%   - az2math.m
%   - math2az.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 26-Apr-2017
% Date Modified : 21-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%% Parse Inputs
% default values
defaultNslices = 100;
defaultCmap = hsv(256);
defaultTick = [0 45 90 135 180 225 270 315];
defaultTickLabel = [];
defaultTickLineColor = [0 0 0];
defaultTickLabelColor = [0 0 0];
defaultTickLineWidth = 1;
defaultCax = [0 360];
defaultDoaz = true;
defaultTextScaleFactor = 1.3;
defaultTickFontsize = 16;

% check functions
checkPos = @(X) isvector(X) && numel(X)==4 && isnumeric(X);
checkNslices = @(X) isscalar(X) && isnumeric(X);
checkCmap = @(X) isnumeric(X) && size(X,2)==3;
checkTick = @(X) isvector(X) && isnumeric(X);
checkTickLabel = @(X) iscell(X) || isstring(X);
checkTickLineColor = @(X) size(X,2)==3;
checkTickLabelColor = @(X) size(X,2)==3;
checkTickLineWidth = @(X) isnumeric(X);
checkCax = @(X) isnumeric(X) & numel(X)==2;
checkDoaz = @(X) islogical(X);
checkTextScaleFactor = @(X) isscalar(X) && isnumeric(X);
checkTickFontsize = @(X) isnumeric(X);

% parse inputs
p = inputParser;

addRequired(p, 'pos'            ,checkPos);

addParameter(p,'nslices'        ,defaultNslices,checkNslices);
addParameter(p,'cmap'           ,defaultCmap,checkCmap);
addParameter(p,'tick'           ,defaultTick,checkTick);
addParameter(p,'ticklabel'      ,defaultTickLabel,checkTickLabel);
addParameter(p,'ticklinecolor'  ,defaultTickLineColor,checkTickLineColor);
addParameter(p,'ticklabelcolor' ,defaultTickLabelColor,checkTickLabelColor);
addParameter(p,'ticklinewidth'  ,defaultTickLineWidth,checkTickLineWidth);
addParameter(p,'cax'            ,defaultCax,checkCax);
addParameter(p,'doazimuth'      ,defaultDoaz,checkDoaz);
addParameter(p,'textscalefactor',defaultTextScaleFactor,checkTextScaleFactor);
addParameter(p,'tickfontsize'   ,defaultTickFontsize,checkTickFontsize);

parse(p,pos,varargin{:});

% get inputs out
pos = p.Results.pos;
nslices = p.Results.nslices;
cmap = p.Results.cmap;
tick = p.Results.tick;
ticklabel = p.Results.ticklabel;
ticklinecolor = p.Results.ticklinecolor;
ticklabelcolor = p.Results.ticklabelcolor;
ticklinewidth = p.Results.ticklinewidth;
cax = p.Results.cax;
doazimuth = p.Results.doazimuth;
textscalefactor = p.Results.textscalefactor;
tickfontsize = p.Results.tickfontsize;

nticks = numel(tick);
if isempty(ticklabel)
    for i=1:nticks
        ticklabel{i} = [num2str(tick(i)) '°'];
    end
end
if size(ticklinecolor,1)==1
    ticklinecolor=repmat(ticklinecolor,nticks,1);
end
if size(ticklabelcolor,1)==1
    ticklabelcolor=repmat(ticklabelcolor,nticks,1);
end
if isscalar(ticklinewidth)
    ticklinewidth(1:nticks) = ticklinewidth;
end
if isscalar(tickfontsize)
    tickfontsize(1:nticks) = tickfontsize;
end
if isscalar(textscalefactor)
    textscalefactor(1:nticks)=textscalefactor;
end
%% Draw patches of the pie

ax = axes('Position',pos,'visible','off');
hold on

dAng = 360/nslices;
sliceangles = linspace(0,360-dAng,nslices)';

x = [zeros(nslices,1) cosd(sliceangles-dAng/2) cosd(sliceangles+dAng/2)];
y = [zeros(nslices,1) sind(sliceangles-dAng/2) sind(sliceangles+dAng/2)];

if doazimuth
    c = math2az(sliceangles);
else
    c = sliceangles;
end

patch(x',y',c');
shading flat
%% Draw and Label Angles
for i=1:nticks
    if doazimuth
       tickX = cosd(az2math(tick(i)));
       tickY = sind(az2math(tick(i)));
    else
       tickX = cosd(tick(i));
       tickY = sind(tick(i));
    end
    text(textscalefactor(i)*tickX,textscalefactor(i)*tickY,ticklabel{i},...
        'HorizontalAlignment','Center',...
        'fontsize',tickfontsize(i),'color',ticklabelcolor(i,:))
    
    plot([0 tickX],[0 tickY],...
        'color',ticklinecolor(i,:),'linewidth',ticklinewidth(i))
end
axis([-1 1 -1 1]);
axis equal
colormap(ax,cmap)
caxis(cax)
figure(gcf); 
end