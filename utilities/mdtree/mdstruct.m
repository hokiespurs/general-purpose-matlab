function mdstruct(X,name)
% MDSTRUCT generates ascii directory tree format to depict structure fields
%   This function makes a visual ascii printout to help display a structure
%   fields for documentation
% 
% Inputs:
%   - X    : Structure to parse through
%   - name : Name of the structure {Default = 'Structure'}
% 
% Outputs:
%   - n/a 
% 
% Examples:
%   X.a = 'test';
%   X.b = 1;
% 
% Dependencies:
%   - mdprint.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 02-Jul-2017
% Date Modified : 02-Jul-2017

if nargin==1
   name = 'Structure';
end

[f,s] = getstructnames(X);

mdprint(f,s,name);

end