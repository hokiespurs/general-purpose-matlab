function fixedString = fixfigstring(rawString)
% FIXFIGSTRING Convert a string with underscore for use in figure titles
% 
% Inputs:
%   - rawString   : Raw character string containing '_'
% 
% Outputs:
%   - titleString : Input Character String with '_' replaced with '\_'
% 
% Examples:
%   mytitlestr = 'Subscripts_are_bad';
%   fixedtitlestr = fixfigstring(mytitlestr);
%   figure;
%   subplot 211;title(mytitlestr);
%   subplot 212;title(fixedtitlestr)
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 1-Jan-2016    
% Date Modified : 11-Jun-2017      
% Github        : https://github.com/hokiespurs/general-purpose-matlab

% of course matlab already had a function for this
fixedString = strrep(rawString,'_','\_');

% maybe add future characters to replace here

end