function mddir(diglevel,dofiles,groupfiles)
% MDDIR generates an ascii directory tree suitable for markdown
%   This function prints an ascii directory tree to the screen for the
%   current working directory.  It helps with documenting folder and file
%   structures.
%
%   * Inspired by mddir (https://www.npmjs.com/package/mddir)
% 
% Inputs:
%   - diglevel   : determines how far to dig into the directory structure
%   - dofiles    : flag for if files should be returned {default=true} 
%   - groupfiles : flag to determine if like files should be grouped
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
% TODO: make these varargin
if nargin==0
    diglevel = 65535;
    dofiles = true;
    groupfiles = false;
elseif nargin==1
    dofiles = true;
    groupfiles = false;
elseif nargin==2
    groupfiles = false;
end
%% Get all the data
% first column is the relative file path
[f,d] = dirname('*',diglevel);
f = cellfun(@(x) x(numel(pwd)+1:end),f,'UniformOutput',false);
d = cellfun(@(x) x(numel(pwd)+1:end),d,'UniformOutput',false);

[~,name,~] = fileparts(pwd);
if ~dofiles
   f = cell(0);
elseif groupfiles
   % summarize number of file types, rather than print each one out
   f = mddirgroupf(f,d);
end
clc
mdprint(f,d,name);

end
