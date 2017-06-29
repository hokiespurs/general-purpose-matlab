function pos = maxpos(ax)
% MAXPOS computes the position vector which encompasses all ax handles
%   The position vector (x,y,dx,dy) for each axes handle (ax) is returned,
%   and the maximum and minimum are computed to determine the bounding box
%   which encompasses each of the axes.
%
% Inputs:
%   - ax : vector of axes handles
%
% Outputs:
%   - pos : position vector which encompasses all axes handles ax
%
% Examples:
%     ax1 = subplot(3,3,2);
%     ax2 = subplot(3,3,6);
%     maxpos([ax1 ax2])
%
% Dependencies:
%   - n/a
%
% Toolboxes Required:
%   - n/a
%
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 20-Jun-2017
% Date Modified : 20-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab
tic
while(toc<1) % give plot a second to let the axes be drawn
    try
        ax = ax(:);
        nax = numel(ax);
        xyxy = nan(nax,4);
        for i=1:numel(ax)
            ipos = get(ax(i),'Position');
            xyxy(i,:) = [ipos(1) ipos(2) ipos(1)+ipos(3) ipos(2)+ipos(4)];
        end
        
        minX = min(xyxy(:,1));
        maxX = max(xyxy(:,3));
        minY = min(xyxy(:,2));
        maxY = max(xyxy(:,4));
        pos = [minX minY maxX-minX maxY-minY];
    catch
        fprintf('Waiting for axes to be drawn...');
        pause(0.25);
    end
end
end