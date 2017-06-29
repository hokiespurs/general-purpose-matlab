function [hc,hax] = bigcolorbarax(ax, dx, width, ytext, varargin)
% BIGCOLORBARAX generates a big colorbar to the right of a set of axes
%   bigcolorbarax automatically positions a colorbar so that it aligns
%   nicely with a set of input axes.
%
%   All units are in "normalized" coordinates
% 
% Inputs:
%   - ax       : Vector of axes handles
%   - dx       : Gap between right edge of axes and left edge of colorbar
%   - width    : Width of colorbar
%   - ytext    : String to label the colorbar
%   - varargin : Optional parameters for the ylabel call ('fontsize', etc)
% 
% Outputs:
%   - hc  : handle to the colorbar axes
%   - hax : handle to the invisible axes containing the colorbar
% 
% Examples:
%     figure(1);clf
%     ax1 = subplot(2,3,1:2);
%     ax2 = subplot(2,3,4:5);
%     [hc,hax] = bigcolorbarax([ax1 ax2],0.05,0.1,'COLORBAR','fontsize',18)
%     caxis([-5 5]);
% 
% Dependencies:
%   - bigcolorbar.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 20-Jun-2017
% Date Modified : 20-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab

drawnow;pause(0.05);%getting errors because axes werent drawn yet

pos = maxpos(ax);
cpos = [pos(1)+pos(3)+dx pos(2) width pos(4)];

[hc,hax] = bigcolorbar(cpos, ytext, varargin{:});

end



