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

function [F, S] = getstructnames(X,name)
% return field names and structure names from a structure X
% append the 'name' to the beginning of each 
% In order to make it work the same way as as mddir, '\' is added between
% levels.
if nargin==1
    name = '';
end

fnames = fieldnames(X);
Sflag = false(size(fnames));

iFall = [];
iSall = [];
for i=1:numel(fnames)
    if isstruct(X.(fnames{i}))
        Sflag(i) = true;

        [iF, iS]= getstructnames(X.(fnames{i}),fnames{i});
        iFall = [iFall; iF];
        iSall = [iSall; iS];
    end
end

combineFnames = [fnames(~Sflag); iFall];
combineSnames = [fnames(Sflag); iSall];

combName = @(x) [name '\' x];
F = cellfun(combName,combineFnames,'UniformOutput',false);
S = cellfun(combName,combineSnames,'UniformOutput',false);

end