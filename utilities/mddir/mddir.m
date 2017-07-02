function mddir
% MDDIR generates ascii directory tree suitable for markdown
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
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 01-Jul-2017
% Date Modified : 01-Jul-2017

%% Constants to format the output
STR1      = '|   ';
STRFOLDER = '|-- ';
STRFILE   = '|-- ';
STR3      = '    ';
%% Get all the data
% first column is the relative file path
[f,d] = dirname('*',65535);
f = cellfun(@(x) x(numel(pwd)+1:end),f,'UniformOutput',false);
d = cellfun(@(x) x(numel(pwd)+1:end),d,'UniformOutput',false);

% It was a pain to make it print subfolders before files, so I wrote a not
% so elequent way of making it work.  Every directory gets an 'a' character
% in front of it, every filename gets a 'z' in front of it.  Then when it
% sorts it works out.  Before it prints it to the screen, it wipes the
% prefix letter.

f = strrep(f,'\','\a');
d = strrep(d,'\','\a');

f = cellfun(@(x) addLetterToName(x,'z'),f,'UniformOutput',false);


% second column indicates the layer it is at
f(:,2) = cellfun(@(x) sum(x==filesep),f,'UniformOutput',false);
d(:,2) = cellfun(@(x) sum(x==filesep),d,'UniformOutput',false);

% third column indicates if it is a folder or not
f(:,3)={0};
d(:,3)={1};

% sort it alphabetically
fd = sortrows([f;d]);

[~,topfolder,~] = fileparts(pwd);    % get top folder name

%% Print it all to the screen
fprintf('%s%s\n',STRFOLDER,topfolder);

for i=1:size(fd,1)
    [~,printname,ext] = fileparts(fd{i,1});
    printname = printname(2:end);
    fprintf('%s',STR3);
    fprintf('%s',repmat(STR1,1,fd{i,2}-1));
    if fd{i,3}==1
        fprintf('%s',STRFOLDER);
    else
        fprintf('%s',STRFILE);
    end
    fprintf('%s\n',[printname ext]);
end

end

function newstr = addLetterToName(oldstr,letter)
% replaces the first letter of the filename with the given 'letter'
% This is to help with the sorting of the files and folders so the output
% looked nice.  It is not elequent at all, but it works.  
[dname,fname,ext]=fileparts(oldstr);
fname(1)=letter;
if dname=='\'
    newstr = ['\' fname ext];
else
    newstr = [dname '\' fname ext];
end

end
