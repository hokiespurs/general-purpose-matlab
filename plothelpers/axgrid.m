function [axg,axh] = axgrid(nr,nc,dr,dc,y1,y2,x1,x2)
% AXGRID generates more flexability for generating subplot axes
%   This function helps with making subplots by allowing the user to edit
%   various parameters for the spacing and positioning of each axes.  axg
%   is a function handle which is used to generate a subplot, or return an
%   axes handle to an existing subplot.
%
% Inputs:
%   - ny : Number of Rows
%   - nx : Number of Columns
%   - dy : Space Between Rows
%   - dx : Space Between Columns
%   - y1 : Row Starting Coordinate (Bottom)   Default = 0.05
%   - y2 : Row Ending Coordinate (Top)        Default = 0.05
%   - x1 : Column Starting Coordinate (Left)  Default = 0.05
%   - x2 : Column Ending Coordinate (Right)   Default = 0.05
%
% Outputs:
%   - axg   : pass in (r,c) or (ind) and  returns a handle to that axes
%   - axh   : matrix of numerical axes handles (each axes auto-generated)
%
%    *axg by default will delete axes it overlaps with, OR will just return
%     the axes handle if the exact axes exists.  If you want to overlay an
%     axes on another axes, say for a different colormap, call axg with the
%     optional dooverlay parameter: (r,c,dooverlay) or axg(ind,dooverlay)
%
% Examples:
%     figure(1);clf
%     [axg,axh] = axgrid(2,3,0.05,0.1);
%     axg(1);pcolor(rand(20));
%     axg(2,1);pcolor(rand(5));
%     axg([1 2],[2 3]);hist(randn(1000,1));
%
% Dependencies:
%   - n/a
%
% Toolboxes Required:
%   - n/a
%
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 17-Jun-2017
% Date Modified : 20-Jun-2017
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%% Handle default values
if nargin<=4
    y1=0.05;
    y2=0.95;
    x1=0.05;
    x2=0.95;
end

% compute the corner coordinates for each plot as xpos and ypos
xspace = x2-x1;
xplotspace = xspace-(nc-1)*dc;
dxpos = xplotspace/nc;
xpos = x1:dxpos+dc:x2;

yspace = y2-y1;
yplotspace = yspace-(nr-1)*dr;
dypos = yplotspace/nr;
ypos = fliplr(linspace(y1,y2-dypos,nr));

% throw error if padding and limits leave no room for axes
if dxpos<=0 || dypos<=0
    if (x1+x2)>=1 || (y1+y2)>=1
        error('(x1,x2,y1,y2)limits leave no room for axes');
    else
        error('dr or dc is too large for the given limits');
    end
end

%% Generate Plots for the axes handle output axh
if nargout==2
    clf;
    figure(gcf);
    axh = nan(nr,nc);
    for i=1:nc
        for j=1:nr
            axh(j,i) = axes('Units','Normalized',...
                'Position',[xpos(i) ypos(j) dxpos dypos]);
        end
    end
end
% create function axg
sz = [nc nr];
axg = @(varargin) makeaxes(xpos,ypos,dxpos,dypos,sz,varargin{:});
end

function h = makeaxes(xpos,ypos,dxpos,dypos,sz,varargin)
% This function makes an axes on the current figure at the position given
% by [xpos ypos dxpos dypos].  sz is used so that the user can input just
% the index value and it can be converted to (r,c)
%
% By default, if the axes overlaps another axes it deletes that axes unless
% they have the exact same position, in this case the function just returns
% the handle for the existing axes
%
% The user can optionally pass in a logical value for dooverlay which will
% override the previous logic for overlapping axes.  If it is true, the
% axes can be placed directly on another axes or overlapping another axes.7
%
% Input options for varargin are:
%    @(ind)
%    @(ind,dooverlay)
%    @(r,c)
%    @(r,c,dooverlay)

narginchk(6,8)
if nargin==6 % @axg(ind)
    [c,r]=ind2sub(sz,varargin{1});
    dooverlay = false;
elseif nargin == 7
    if islogical(varargin{2}) % @axg(ind,dooverlay)
        [c,r]=ind2sub(sz,varargin{1});
        dooverlay = varargin{2};
    else% @axg(r,c)
        r = varargin{1};
        c = varargin{2};
        dooverlay = false;
    end
else % @axg(r,c,dooverlay)
    r = varargin{1};
    c = varargin{2};
    dooverlay = varargin{2};
end
if ~iswithin(c,[1 sz(1)]) || ~iswithin(r,[1 sz(2)])
    error('Desired axes location out of range(%.0f,%.0f)',sz);
end
% determine limits of axes
X = reshape(xpos(c(:)),1,numel(c));
Y = reshape(ypos(r(:)),1,numel(r));
xyxy = [X; Y; X+dxpos; Y+dypos]';

minX = min([xyxy(:,1); xyxy(:,3)]);
maxX = max([xyxy(:,1); xyxy(:,3)]);
minY = min([xyxy(:,2); xyxy(:,4)]);
maxY = max([xyxy(:,2); xyxy(:,4)]);
pos = [minX minY maxX-minX maxY-minY];

%look for overlapping or matching axes
A = findobj(gcf,'type','axes');
if ~dooverlay
    for i=1:numel(A)
        A(i).Units = 'normalized';
        aPos = A(i).Position;
        if all(aPos==pos) % matching axes
            h = A(i);
            axes(A(i));
            return
        end
    end
    % if no exact matches, delete all overlaps
    for i=1:numel(A)
        A(i).Units = 'normalized';
        aPos = A(i).Position;
        if rectint(aPos,pos)>0 % overlapping axes
            delete(A(i));
        end
    end
end
h = axes('Units','Normalized','Position',pos);

end