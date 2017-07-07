function [F, S] = getstructnames(X,name)
% GETSTRUCTNAMES returns structure format as cell array of 'filenames'
%   Used by mdstruct, this reads a structure X and returns all of the
%   fields as though they are filesnames in a directory tree
% 
% Inputs:
%   - X    : Structure to be parsed
%   - name : Name to add to the beginning of each output line
% 
% Outputs:
%   - F : Field Names
%   - S : Structure Names 
%
% Examples:
%   x.a=1;x.b=2;x.c.a='xca';
%   [F,S]=getstructnames(x,'test')
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 07-Jul-2017
% Date Modified : 07-Jul-2017

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