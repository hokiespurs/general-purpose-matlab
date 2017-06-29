function [htxt,h] = bigtitleax(titlestr,ax,dy,varargin)
% BIGTITLEAX generates a title centered and above the given axes
%   Rather than try to figure out the correct position of the bigtitle,
%   this function allows the user to input a vector of axes handles that
%   the title should be centered over.  dy depicts how high above the top
%   of the uppermost axes the title should be.
% 
% Inputs:
%   - titlestr : Desired string for the title
%   - ax       : Vector of axes handles for the title to be centered over
%   - dy       : Height above the top of the uppermost axes for the title
%   - varargin : Extra parameters which may be passed to the 'text' command
% 
% Outputs:
%   - htxt : handle for the title txt box
%   - h    : handle for the invisible axes containing the title
% 
% Examples:
%     ax1=subplot(1,3,1);
%     ax2=subplot(1,3,2);
%     ax3=subplot(1,3,3);
%     bigtitleax('TITLE',[ax1 ax2],0.02)
%
% Dependencies:
%   - bigtitle.m
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
xpos = pos(1)+pos(3)/2;
ypos = pos(2)+pos(4)+dy;
[htxt,h]= bigtitle(titlestr,xpos,ypos,varargin{:});

end