function pcolorCenter(xg,yg,zg)
% PCOLORCENTER interpolate/extrapolates to make pcolor patches centered
%   pcolor uses the xg,yg coordinates you give it as the corners of the
%   patches that it draws.  Sometimes, you want to have thte patch centered
%   at the xg,yg coordinates, like imagesc does.  But, imagesc can't handle
%   nonuniform data.  So, pcolorCenter attempts to extrapolate/interpolate
%   to compute the corner of each patch, so that all of the data is
%   plotted.  This won't be perfect, ideally you would explicitly compute
%   the corners of each patch and pcolor it that way.
% 
% Inputs:
%   - xg : vector or matrix of x grid values
%   - yg : vector or matrix of y grid values
%   - zg : matrix of z values
% 
% Outputs:
%   - n/a 
% 
% Examples:
%     n = 6;
%     r = (1:n)'/n;
%     theta = pi*(0:n)/n;
%     X = r*cos(theta);
%     Y = r*sin(theta);
%     C = r*cos(2*theta);
%     figure(1);clf;
%     subplot 211
%     pcolor(X,Y,C);title('pcolor');
%     subplot 212
%     pcolorCenter(X,Y,C);title('pcolorCenter');
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 21-Jun-2017
% Date Modified : 21-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab

if isvector(xg) && isvector(yg)
    xgnew = interp1(1:numel(xg),xg,0.5:numel(xg)+0.5,'linear','extrap');
    ygnew = interp1(1:numel(yg),yg,0.5:numel(yg)+0.5,'linear','extrap');
else
    [m,n]=size(xg);
    if size(yg,1)~=m || size(yg,2)~=n
        error('xg and yg must be same size if matrices')
    end
    [nind,mind]=meshgrid(1:n,1:m);
    [ng,mg]=meshgrid(0.5:n+0.5,0.5:m+0.5);
    xgnew = interp2(nind,mind,xg,ng,mg,'spline');
    ygnew = interp2(nind,mind,yg,ng,mg,'spline');
end

zg(end+1,end+1)=0; %add extra values to zg that wont be plotted

pcolor(xgnew,ygnew,zg)
end