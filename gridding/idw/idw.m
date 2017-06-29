function [zgrid, npts] = idw(varargin)
% IDW Performs Inverse Distance Weighting to Grid Data
%   Grid sparse data onto a grid using inverse distance weighting algorithm
%   The weighted average of points within a specified radius(r) are computed
%   using the equation:
%
%                     W = distance^power
%   
%   The most common implementation uses a power value of -2
%
%   * NOTE that the equation requires a negative power to be inverse
%
%   [zgrid, npts] = idw(x,y,xgrid,r,p)                         % 1D Case
%   [zgrid, npts] = idw(x,y,z,xgrid,ygrid,r,p)                 % 2D Case  
%   [zgrid, npts] = idw(x,y,z,I,xgrid,ygrid,zgrid,r,p)         % 3D Case
%
% Inputs:
%   - x     : vector of x data
%   - y     : vector of y data
%   - z     : vector of z data
%   - xgrid : x grid nodes to query data at
%   - ygrid : y grid nodes to query data at
%   - r     : IDW search radius
%   - p     : IDW power (default=-2)
% 
% Outputs:
%   - zgrid : z data at (xgrid,ygrid) nodes (nan if no data)
%   - npts  : number of points at (xgrid,ygrid) nodes
% 
% Examples:
%     RADIUS = 1;
%     POWER = -2;
%     x = randn(10000,1)*2;
%     y = randn(10000,1)*1;
%     z = sin(10*x) + cos(5*y);
%     [xg,yg]=meshgrid(-5:.1:5,-5:.1:5);
%     [zg, npts] = idw(x,y,z,xg,yg,RADIUS,POWER);
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - (Recommended for Performance) Statistics and Machine Learning Toolbox 
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 17-Mar-2017    
% Date Modified : 14-Jun-2017    
% Github        : https://github.com/hokiespurs/general-purpose-matlab  
%% 
if mod(nargin,2)==0 %even number so power not input
    p = -2;
    r = varargin{end};
else
    r = varargin{end-1};
    p = varargin{end};
end

ndim = floor(nargin/2)-1;

zgrid = nan(size(varargin{ndim+2}));
npts = zeros(size(varargin{ndim+2}));

%% Put points in arrays
nsparsepts = numel(varargin{1});
ngridpts   = numel(varargin{ndim+2}(:));
sparsepts  = nan(nsparsepts,ndim);
gridpts    = nan(ngridpts,  ndim);
sparsevals = varargin{ndim+1};
for i=1:ndim
    sparsepts(:,i) = varargin{i}(:);
    gridpts(:,i) = varargin{ndim+1+i}(:);
end
%% Calculate Range to Points
if exist('rangesearch.m','file')
    [idx,D] = rangesearch(sparsepts,gridpts,r);
else
    [idx,D] = rangesearch2(sparsepts,gridpts,r); %slower
end
%% dumb looping code... cant think of how to make smarter
for i=1:numel(idx)
    iSparseval = sparsevals(idx{i});
    if ~isempty(iSparseval)
        W = D{i}.^p;
        zgrid(i) = W* iSparseval./sum(W);
        npts(i) = numel(W);
    end
end

end

function [idx,dist]=rangesearch2(xy,xgyg,r)
% brute force replacement for rangesearch in the stats toolbox
% it is much slower, and doesnt sort the idx and dist
%
% input xy data and xgyg grid query points and a radius
% output: matrix of cells containing index and dist to points within radius

ndim = size(xy,2);

idx = cell(size(xgyg,1),1);
dist = cell(size(xgyg,1),1);

for i=1:size(xgyg,1)
    switch ndim %explicitly writing it out is a bit faster than looping
        case 1 %1D Line
            D = xy(:,1)-xgyg(i,1);
        case 2 %2D surface
            D = sqrt((xy(:,1)-xgyg(i,1)).^2+(xy(:,2)-xgyg(i,2)).^2);
        case 3 %3D Voxels
            D = sqrt((xy(:,1)-xgyg(i,1)).^2+(xy(:,2)-xgyg(i,2)).^2+...
                (xy(:,3)-xgyg(i,3)).^2);
        case 4 %4D
            D = sqrt((xy(:,1)-xgyg(i,1)).^2+(xy(:,2)-xgyg(i,2)).^2+...
                (xy(:,3)-xgyg(i,3)).^2+(xy(:,4)-xgyg(i,4)).^2);
        otherwise % Getting crazy
            D = 0;
            for j=1:ndim
                D = D + (xy(:,j)-xgyg(i,j)).^2;
            end
            D = sqrt(D);
    end
   idx{i} = find(D<=r)';
   dist{i} = D(D<=r)';
end

end