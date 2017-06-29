function h = plotRect(ux,sx,varargin)
% PLOTRECT plot a 2D rectangle or 3D prism
%   The rectangle function plots from the corner, this function plots by
%   defining a center coordinate and edge lengths.  The rectangle is often
%   used to depict uncertainty, therefore the edge length is twice sx in
%   all dimensions
% 
% Inputs:
%   - ux       : 1xN : num : mean coordinate (N=2 or N=3)
%   - sx       : 1xN : num : half the total length in each dimension
%   - varargin :     :     : any valid plot or plot3 optional parameters
% 
% Outputs:
%   - n/a 
% 
% Examples:
%   h = plotRect([0 1 3],[2 1 3],'linewidth',3);
%   h.Color = 'r'
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : hokiespurs@gmail.com
% Date Created  : 08-Feb-2017
% Date Modified : 08-Feb-2017    
% Github        : https://github.com/hokiespurs/general-purpose-matlab 

%% ensure valid inputs
nux = numel(ux);
ndx = numel(sx);
if nux ~= ndx
   error('ux and sx need same number of elements'); 
end

if nux==2 %2D Case
    dx = sx(1);
    dy = sx(2);
    
    xpts = [-dx -dx dx dx -dx];
    ypts = [-dy dy dy -dy -dy];
    
    h = plot(xpts+ux(1),ypts+ux(2),varargin{:});
elseif nux==3 %3D Case
    dx = sx(1);
    dy = sx(2);
    dz = sx(3);
    
    xpts = [-dx -dx  dx  dx -dx -dx  dx  dx  dx dx  dx dx -dx -dx -dx -dx];
    ypts = [-dy  dy  dy -dy -dy -dy -dy -dy -dy dy  dy dy  dy  dy  dy -dy];
    zpts = [-dz -dz -dz -dz -dz  dz  dz -dz  dz dz -dz dz  dz -dz  dz  dz];
    
    h = plot3(xpts+ux(1),ypts+ux(2),zpts+ux(3),varargin{:});
else
    error('unknown dimensions, must be 2 or 3D ');
end
end
