function stats = pointcloud2control(xyzPointcloud, xyzControl, normalRadius, varargin)
% POINTCLOUD2CONTROL Compares pointcloud to control using modified M3C2
%   A positive value indicates xyzPointcloud is above xyz Control when the
%   surface normal is straight up
% 
% Required Inputs:
%	- xyzPointcloud   : (Mx3) pointcloud 
%	- xyzControl      : (Mx3) control points
%	- normalRadius    : radius to search around control to get surface normal 
% Optional Inputs: (default)
%	- 'evalRadius'    : (normalRadius) cylinder radius to search 
%	- 'maxDist'       : (inf) maximum distance to include in stats
%   - 'makenormalZ'   : (false) makes the normal default to Z up
%   - 'histVals'      : (-1:0.02:1) histogram bin edges
%   - 'dodebug'       : (inf) how often to print update to screen
%
% Outputs:
%   - stats : struture with statistics for each control point
% 
% Examples:
%   - Example code goes here
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 05-Jul-2018
% Date Modified : 05-Jul-2018
% Github        : https://github.com/hokiespurs/general-purpose-matlab\pointcloud\pointcloud2control

%% Parse Inputs
[xyzPointcloud,xyzControl,normalRadius,evalRadius,maxDist,makeNormalZ,histVals,dodebug] = ...
    parseInputs(xyzPointcloud,xyzControl,normalRadius,varargin{:});

nControlPoints = size(xyzControl,1);

%% Compute Normal for Each point
if ~makeNormalZ
    controlNormal = nan(nControlPoints,3);
    starttime = now;
    fprintf('Computing Normals\n');
    for iPointNum = 1:nControlPoints
        controlNormal(iPointNum,:) = ...
            calcNormal(xyzControl(iPointNum,:),xyzPointcloud,normalRadius);
        if dodebug
            loopStatus(starttime,iPointNum,nControlPoints,25);
        end
    end
else
    controlNormal = repmat([0 0 1],nControlPoints,1);
end

%% Compute stats on points within cylinder
starttime = now;
for iPointNum = 1:nControlPoints
    stats(iPointNum) = calcStats(xyzControl(iPointNum,:),...
        controlNormal(iPointNum,:),xyzPointcloud,evalRadius,maxDist,histVals);
    loopStatus(starttime,iPointNum,nControlPoints,dodebug);
end

end

function stats = calcStats(xyzControlPoint,N,xyzPointcloud,evalRadius,maxDist,histvals)
    if all(N==[0 0 1]) %faster when only considering z
        dXY = xyzPointcloud(:,1:2)-xyzControlPoint(:,1:2);
        dOffline = sqrt(sum(dXY.^2,2));
        dDownline = xyzPointcloud-xyzControlPoint;
    else
        [dDownline,dOffline] = point_to_line(xyzPointcloud, N, xyzControlPoint);
    end
    indGood = abs(dDownline)<=maxDist & dOffline<=evalRadius;

    %%
    if sum(indGood)~=0
        stats.mean = mean(dDownline(indGood));
        stats.median = median(dDownline(indGood));
        stats.min = min(dDownline(indGood));
        stats.max = max(dDownline(indGood));
        stats.std = std(dDownline(indGood));
        stats.npts = sum(indGood);

        [stats.hist.val,stats.hist.edges] = histcounts(dDownline(indGood),histvals);
        stats.hist.centerbars = stats.hist.edges(1:end-1) + diff(stats.hist.edges);

        stats.indvals = find(indGood);
        
        stats.Normal = N;
        [~,el]=cart2sph(N(1),N(2),N(3));
        stats.Slope = 90-el*180/pi;
        
        stats.controlPt = xyzControlPoint;
    else
        stats.mean = nan;
        stats.median = nan;
        stats.min = nan;
        stats.max = nan;
        stats.std = nan;
        stats.npts = nan;

        stats.hist.val = nan;
        stats.hist.edges = nan;
        stats.hist.centerbars = nan;

        stats.indvals = [];
        
        stats.Normal = nan;
        stats.Slope = nan;
        
        stats.controlPt=nan;
    end
end

function [dDownline,dOffline] = point_to_line(pc, N, P0)
% pc should be nx3 pointcloud
% v1 and v2 are vertices on the line (each 1x3)
% d is a nx1 vector with the orthogonal distances
a = repmat(-N,size(pc,1),1);
b = pc - repmat(P0,size(pc,1),1);

% OfflineDist = sqrt(sum(cross(a,b,2).^2,2)) ./ sqrt(sum(a.^2,2));

t = dot(-b,a,2);
t(t==inf | t==-inf)=0;
P1 = P0 + N.*t;

dOffline = sqrt(sum((pc-P1).^2,2));
dDownline = sqrt(sum((P0-P1).^2,2));
dDownline = dDownline .* (2*(t>0)-1);

% %% DEBUG
% T = 2;
% DPLOTTHRESH = 1;
% SPHERESIZE = .5;
% ind = dOffline<DPLOTTHRESH;
% figure(1);clf
% subplot(2,1,1);
% plot3([P0(1)-T*N(1) P0(1)+T*N(1)],...
%       [P0(2)-T*N(2) P0(2)+T*N(2)],...
%       [P0(3)-T*N(3) P0(3)+T*N(3)],'k-');
% grid on
% hold on
% plot3(pc(~ind,1),pc(~ind,2),pc(~ind,3),'b.','markersize',1)
% scatter3(pc(ind,1),pc(ind,2),pc(ind,3),20,dOffline(ind),'filled')
% axis equal
% 
% [x,y,z] = sphere;
% surf(x*SPHERESIZE+P0(1),y*SPHERESIZE+P0(2),z*SPHERESIZE+P0(3),...
%     'FaceColor','k','faceAlpha',0.1,'EdgeColor','k','linewidth',.01);
% 
% caxis([0 DPLOTTHRESH]);
% 
% subplot(2,1,2)
% plot3([P0(1)-T*N(1) P0(1)+T*N(1)],...
%       [P0(2)-T*N(2) P0(2)+T*N(2)],...
%       [P0(3)-T*N(3) P0(3)+T*N(3)],'k-');
% grid on
% hold on
% plot3(pc(~ind,1),pc(~ind,2),pc(~ind,3),'b.','markersize',1)
% scatter3(pc(ind,1),pc(ind,2),pc(ind,3),20,dDownline(ind),'filled')
% axis equal

end

function N = calcNormal(xyzControlPoint,xyzPointcloud,normalRadius)
%% Compute the normal for each control point based on the pointcloud points
%%  within a sphere with a radius defined by the the input 'normalRadius'

% only calculate radius on points within a cube surrounding the sphere
limXYZ = [xyzControlPoint - normalRadius; xyzControlPoint + normalRadius];

indCube = xyzPointcloud(:,1) >= limXYZ(1,1) & xyzPointcloud(:,1) <= limXYZ(2,1) & ...
      xyzPointcloud(:,2) >= limXYZ(1,2) & xyzPointcloud(:,2) <= limXYZ(2,2) & ...
      xyzPointcloud(:,3) >= limXYZ(1,3) & xyzPointcloud(:,3) <= limXYZ(2,3);
PC = xyzPointcloud(indCube,:);

% compute distance for each point
D = sqrt((PC(:,1)-xyzControlPoint(1)).^2 + ...
          (PC(:,2)-xyzControlPoint(2)).^2 + ...
          (PC(:,3)-xyzControlPoint(3)).^2);

% find index for points within radius
ind = D<=normalRadius;

% fit a plane to the points to compute the surface normal
% Ordinary Least Squares
% Equation: ax + by + c = z
% Where Normal = [a,b,-1];
%
% X = [a,b,c]'; unknowns
% A = [x y 1]; 
% L = [z];
% A*X = L + V
% beta = inv(A'A)*A'*L

if sum(ind)<4 % no points within radius
    N = [0 0 0]; % let code further on handle this
    return;
end

xpts = PC(ind,1);
ypts = PC(ind,2);
zpts = PC(ind,3);

A = [xpts(:) ypts(:) ones(size(xpts(:)))];
L = zpts(:);

m = numel(L); % number of observations
n = size(A,2); % number of unknowns
dof = m-n; % degrees of freedom

X = (A'*A)\A'*L;

%normalize so unit vector
Nraw = [-X(1) -X(2) 1];
N = Nraw./sqrt(sum(Nraw.^2));
end

function [xyzPointcloud,xyzControl,normalRadius,evalRadius,maxDist,makeNormalZ,histVals,dodebug] = ...
    parseInputs(xyzPointcloud,xyzControl,normalRadius,varargin)
%%	 Call this function to parse the inputs

% Default Values
default_evalRadius  = normalRadius;
default_maxDist     = inf;
default_makeNormalZ = false;
default_histVals    = -1:0.02:1;
default_dodebug     = inf;

% Check Values
check_xyzPointcloud  = @(x) size(x,2)==3;
check_xyzControl     = @(x) size(x,2)==3;
check_normalRadius   = @(x) isscalar(x);
check_evalRadius     = @(x) isscalar(x);
check_maxDist        = @(x) isscalar(x);
check_makeNormalZ    = @(x) islogical(x);
check_histVals       = @(x) isvector(x);
check_dodebug        = @(x) mod(x,1)==0;

% Parser Values
p = inputParser;
% Required Arguments:
addRequired(p, 'xyzPointcloud' , check_xyzPointcloud );
addRequired(p, 'xyzControl'    , check_xyzControl    );
addRequired(p, 'normalRadius'  , check_normalRadius  );
% Parameter Arguments
addParameter(p, 'evalRadius'  , default_evalRadius  , check_evalRadius  );
addParameter(p, 'maxDist'     , default_maxDist     , check_maxDist     );
addParameter(p, 'makeNormalZ' , default_makeNormalZ , check_makeNormalZ );
addParameter(p, 'histVals'    , default_histVals    , check_histVals    );
addParameter(p, 'dodebug'     , default_dodebug     , check_dodebug     );

% Parse
parse(p,xyzPointcloud,xyzControl,normalRadius,varargin{:});
% Convert to variables
xyzPointcloud = p.Results.('xyzPointcloud');
xyzControl    = p.Results.('xyzControl');
normalRadius  = p.Results.('normalRadius');
evalRadius    = p.Results.('evalRadius');
maxDist       = p.Results.('maxDist');
makeNormalZ   = p.Results.('makeNormalZ');
histVals      = p.Results.('histVals');
dodebug       = p.Results.('dodebug');
end