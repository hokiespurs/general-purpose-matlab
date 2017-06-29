function [hc,hax] = bigcolorbar(pos, ytext, varargin)
% BIGCOLORBAR generates a large colorbar useful for multiple subplots
%   bigcolorbar generates a blank axes and creates a colorbar at the
%   position pos labeled with the string in ytext.  varargin is any extra
%   parameters which can be passed to 'ylabel'.
% 
% Inputs:
%   - pos      : 4 element position vector (x,y,dx,dy)
%   - ytext    : String to label the colorbar
%   - varargin : Optional parameters for the ylabel call ('fontsize', etc)
% 
% Outputs:
%   - hc  : handle to the colorbar axes
%   - hax : handle to the invisible axes containing the colorbar
% 
% Examples:
%     ax1 = subplot(2,3,1:2);
%     ax2 = subplot(2,3,4:5);
%     [hc,hax] = bigcolorbar([0.8 0.1 0.05 0.8],'COLORBAR','fontsize',18)
%     caxis([-5 5]);
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

hax = axes('units','normalized','pos',[-1 -1 1 1],...
    'visible','off');
hc=colorbar('Position',pos);
ylabel(hc,ytext,varargin{:});

end