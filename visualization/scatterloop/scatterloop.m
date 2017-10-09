function h = scatterloop(x,y,s,c,cax,cmap)
% SCATTERLOOP Short summary of this function goes here
%   Detailed explanation goes here
% 
% Inputs:
%   - x     : Description of variable goes here
%   - y     : Description of variable goes here
%   - s     : Description of variable goes here
%   - c     : Description of variable goes here
%   - cax   : Description of variable goes here
%   - cmap  : Description of variable goes here
% 
% Outputs:
%   - n/a 
% 
% Examples:
%   - Example code goes here
% 
% Dependencies:
%   - num2ind.m
%   - loopStatus.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 24-Aug-2017
% Date Modified : 24-Aug-2017

nind = size(cmap,1);
hold on

cind = num2ind(c,cax,nind);
starttime = now;
for i=1:nind
    plotind = cind == i;
    plot(x(plotind),y(plotind),'.','color',cmap(i,:),'markersize',s);
    loopStatus(starttime,i,nind,1);
    drawnow
end

end