function justname = getjustname(fnames,n,includeextension)
% GETJUSTNAME Extracts just the name at a level n from filepaths
%   Takes an input of either a string, or a cell array of strings
%   Computes just the name at a certain level
%   eg. helps to extract just 'foo' from C:/foo/test/dummy/file.txt
% 
% Inputs:
%   - fnames           : String, or cell array of file pathts
%
% Optional Inputs:
%   - n                : (0)     How far up in the filepath to go
%   - includeextension : (false) Should a file extension be included?
% 
% Outputs:
%   - justname         : String, or cell array of names
% 
% Examples:
%   fnames = {'C:/a/b/c/justname1/d/e1.png','C:/a/b/c/justname2/d/e2.png'};
%   justname = getjustname(fnames,2,false)
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 07-Feb-2019
% Date Modified : 07-Feb-2019
% Github        : 

%%
if nargin==1
   n=0;
   includeextension = false;
elseif nargin==2
   includeextension = false;
end


if iscell(fnames)
    justname = cell(size(fnames));
    for i=1:numel(fnames)
        justname{i} = getjustname(fnames{i},n,includeextension);
    end
else
    [d,f,e]=fileparts(fnames);
    for i=1:n
        [d,f,e]=fileparts(d);
    end
    if includeextension
        justname = [f e];
    else
        justname = f;
    end
end

end