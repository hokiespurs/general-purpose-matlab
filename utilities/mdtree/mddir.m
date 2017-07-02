function mddir(diglevel)
% MDDIR generates an ascii directory tree suitable for markdown
%   This function prints an ascii directory tree to the screen for the
%   current working directory.  It helps with documenting folder and file
%   structures.
%
%   * Inspired by mddir (https://www.npmjs.com/package/mddir)
% 
% Inputs:
%   - n/a 
% 
% Outputs:
%   - n/a 
% 
% Examples:
%   mddir
% 
% Dependencies:
%   - dirname.m
%   - mdprint.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 01-Jul-2017
% Date Modified : 01-Jul-2017
%%
if nargin==0
   diglevel = 65535; 
end
%% Get all the data
% first column is the relative file path
[f,d] = dirname('*',diglevel);
f = cellfun(@(x) x(numel(pwd)+1:end),f,'UniformOutput',false);
d = cellfun(@(x) x(numel(pwd)+1:end),d,'UniformOutput',false);

[~,name,~] = fileparts(pwd);

mdprint(f,d,name);

end
