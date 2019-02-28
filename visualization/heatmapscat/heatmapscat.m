function [h,zg] = heatmapscat(x,y,xgi,ygi,doprobability,doplot,dolog10)
% HEATMAPSCAT generates a 2d heatmap of x,y data
%   heatmapscat is used as an alternative to plotting 2d data points when
%   there is very dense data and the trend is hard to discern due to there
%   being so many points.
%
%   The data is binned similarly to a 2d histogram, but uses a roundgridfun
%   Therefore, the grid nodes must be evenly spaced in each dimension.
% 
% Inputs:
%   - x             : Raw x Data
%   - y             : Raw y Data
%   - xgi           : x grid or vector of values for x grid
%   - ygi           : y grid or vector of values for y grid
%   - doprobability : Boolean to make probabilty(true)/npts(false{default})
%   - doplot        : Boolean flag to generate the plo (true{default})
% 
% Outputs:
%   - zg : values for each bin defined by xgi and ygi
%   - h  : handle to the axes if it is made, else NaN
% 
% Examples:
%     NPTS = 1000000;
%     x = rand(NPTS,1)*100;
%     y = 5 + rand(NPTS,1).*x/10 + 9*randn(NPTS,1);
%     figure
%     subplot 121
%     plot(x,y,'b.','markersize',1)
%     xlim([0 100]);
%     ylim([-50 50]);
%     subplot 122
%     xi = 0:1:100;
%     yi = -50:1:50;
%     heatmapscat(x,y,xi,yi);
% 
% Dependencies:
%   - roundgridfun.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 23-Jan-2016
% Date Modified : 21-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab

narginchk(4,7);
if nargin==4
    doprobability = false;
    doplot = true;
    dolog10 = false;
elseif nargin==5
    doplot = true;
    dolog10 = false;
else
    dolog10 = false;
end

x = x(:);
y = y(:);

% alow for xgi to be a 2d matrix or a vector
if isvector(xgi) || ~isvector(ygi)
    [xg,yg] = meshgrid(xgi,ygi);
else
    xg = xgi;
    yg = ygi;
end
% ensure variables are sized correctly
if size(xg,1)~=size(yg,1) || size(xg,2)~=size(yg,2)
   error('xg and yg grid sizes must be the same'); 
end
if numel(x) ~= numel(y)
   error('x and y input must have the same number of elements'); 
end
% grid data to cells
zg = roundgridfun(x,y,ones(size(x)),xg,yg,@sum);

%normalize the plot to be a probability (0,1) for each bin
if doprobability==1
   npts = numel(x);
   zg=zg./npts;
end
%generate the plot of data using imagesc
if doplot
    if ~dolog10
        h = imagesc(xgi,ygi,zg);
    else
        h = imagesc(xgi,ygi,log10(zg));
    end
    set(gca,'ydir','normal')
else
    h = nan;
end
end