function [filenames,foldernames] = dirname(name,diglayer,dname)
% DIRNAME returns cell arrays for file/foldernames that match the template
%   dirname returns a cell array of filenames and foldernames which satisfy
%   the template 'name', just like the dir command.  Diglayer allows the
%   function to search within folders it finds.
%
%   *This code has not been tested with folders that have restricted access
% 
% Inputs:
%   - name     : template for name of file to search for (* = wildcard)
%   - diglayer : How deep into a folder structure the algorithm will go
%   - dname    : Optional directory name when using diglayer
% 
% Outputs:
%   - filenames   : Cell array of filenames
%   - foldernames : Cell array of foldernames
% 
% Examples:
%   [filenames,foldernames] = dirname('*',1)
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 22-Jun-2017
% Date Modified : 22-Jun-2017
% Github        : https://github.com/hokiespurs/general-purpose-matlab

if nargin==1
    diglayer = 0;
    dname ='.';
elseif nargin==2
    dname ='.';
end

if ~iscell(name)
    foundfiles = dir([dname '/' name]);
    dnames = {foundfiles.folder};
    fnames = {foundfiles.name};
    isfolder = [foundfiles.isdir];
    % remove '.' and '..' relative paths
    badinds = strcmp(fnames,{'.'}) | strcmp(fnames,{'..'});
    
    % get all files at this layer
    fileroot = dnames(~isfolder & ~badinds);
    filenames = fnames(~isfolder & ~badinds);
    
    nfiles = numel(filenames);
    levelfilenames = cell(nfiles,1);
    
    for i=1:nfiles
        levelfilenames{i} = [fileroot{i} '\' filenames{i}];
    end
    
    % get all folders at this layer
    folderroot = dnames(isfolder & ~badinds);
    foldernames = fnames(isfolder & ~badinds); % in this case, file == folder
    
    nfolders = numel(foldernames);
    levelfoldernames = cell(nfolders,1);
    for i=1:nfolders
        levelfoldernames{i} = [folderroot{i} '\' foldernames{i}];
    end
    % dig
    alldigfilenames = {};
    alldigfoldernames = {};
    if diglayer>0
        for i=1:nfolders
%             fprintf('%s\n',levelfoldernames{i});
            [digfilenames,digfoldernames] = ...
                dirname(name,diglayer-1,levelfoldernames{i});
            alldigfilenames = [alldigfilenames; digfilenames];
            alldigfoldernames = [alldigfoldernames; digfoldernames];
        end
        filenames = [levelfilenames; alldigfilenames];
        foldernames = [levelfoldernames; alldigfoldernames];
    end
else
    filenames = {};
    foldernames = {};
    for i=1:numel(name)
        [ifilenames,ifoldernames] = dirname2(name{i},diglayer,dname);
        filenames = [filenames;ifilenames];
        foldernames = [foldernames;ifoldernames];
    end
end
end