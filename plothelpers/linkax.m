function linkax(ax,props,KEY)
% LINKAX enables linking the properties of multiple axes
%   this is similar to linkaxes, but any property of an axes can be linked.
%
%   The function uses the linkprop command, but rather than having to keep
%   the handle returned from linkprop in the workspace, it stores the
%   linkprop away somewhere in appdata.  This essentially makes it a global
%   variable, sort of, so the link is retained without having to hold onto
%   the handle.  KEY is used to identify the link in the appdata, so for 
%   linking multiple plots with different calls to linkax, a different KEY
%   string needs to be used.  
%
%   I wasnt able to make unlinkax work, so this is a permanent link
% 
% Inputs:
%   - ax    : matrix of axes handles
%   - props : string or cell array of strings for properties to link
% 
% Outputs:
%   - n/a 
% 
% Examples:
%     h(1) = subplot(2,2,1);
%     plot(rand(10),rand(10),'.');
%     h(2) = subplot(2,2,2);
%     plot(rand(10),rand(10),'.');
%     h(3) = subplot(2,2,3);
%     plot(rand(10),rand(10),'.');
%     h(4) = subplot(2,2,4);
%     plot(rand(10),rand(10),'.');
%     linkax(h([1 2]),'YLim');
%     linkax(h([3 4]),'YLim');
%     linkax(h([1 3]),'XLim');
%     linkax(h([2 4]),'XLim');
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


if nargin==2 % KEY is undocumented until unlinkax can delete links
    KEY = 'graphics_linkaxes'; 
end

hlink = linkprop(ax,props);

%matlab stores this somewhere down in the memory... 
% point:        this might be dangerous
% counterpoint: it works?
for i=1:length(ax)
    setappdata(ax(i),KEY,matlab.graphics.internal.LinkAxes(hlink));
end

end