function mdprint(f,d,name)
% MDPRINT Prints files and directories in an ascii tree structure
%   Used by mddir and mdstruct to print an ascii tree format of data to the
%   screen in markdown format. Also prints an ascii table.
% 
% Inputs:
%   - f    : File name as a structure
%   - d    : Directory name as a structure
%   - name : Name of the first level of the directory tree
% 
% Outputs:
%   - n/a 
% 
% Examples:
%   - n/a
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 02-Jul-2017
% Date Modified : 07-Jul-2017

%% Constants to format the output
STR0      = '    ';
STR1      = '|   ';
STRFOLDER = '|-- ';
STRFILE   = '|-- ';
%%
% It was a pain to make it print subfolders before files, so I wrote a not
% so elequent way of making it work.  Every directory gets an 'a' character
% in front of it, every filename gets a 'z' in front of it.  Then when it
% sorts it works out.  Before it prints it to the screen, it wipes the
% prefix letter.

f = strrep(f,'\','\z');
d = strrep(d,'\','\z');
if ~isempty(f)
    f = cellfun(@(x) addLetterToName(x,'a'),f,'UniformOutput',false);
else
    f=cell(0,3);
end
% second column indicates the layer it is at
f(:,2) = cellfun(@(x) sum(x==filesep),f,'UniformOutput',false);
d(:,2) = cellfun(@(x) sum(x==filesep),d,'UniformOutput',false);

% third column indicates if it is a folder or not
f(:,3)={0};
d(:,3)={1};

% sort it alphabetically
fd = sortrows([f;d]);

%% Run a filter to determine when to draw the vertical bars
% For example 
% |-- a
% |-- |-- b
% |--     |-- c
% |-- d
%     |-- e
nentry = size(fd,1);
maxdepth = max(cellfun(@(x) x,fd(:,2)));
Y = zeros(nentry,maxdepth);
for i=1:nentry
    Y(i,fd{i,2}:end)=nan;
    Y(i,fd{i,2}) = 1;
end
% interpolate along y dimension across nans;
indval = 1:nentry;
Yfix = Y;
for i=1:maxdepth
    yval = Y(:,i);
    induse = yval~=0;
    if sum(induse)<=1
        Yfix(~induse,i)=nan;
    else
        Yfix(:,i) = interp1(indval(induse),yval(induse),indval);
    end
end
Yfix(isnan(Y))=-1;
Yfix(isnan(Yfix))=0;
Yfix(Y==1)=2;
%% Print it all to the screen as a Tree
fprintf('```\n');
fprintf('%s%s\n',STRFOLDER,name);
maxstrlen = 0;
allprintname = cell(nentry,1);
for i=1:nentry
    [~,printname,ext] = fileparts(fd{i,1});
    maxstrlen = max(numel([printname ext]),maxstrlen);
    allprintname{i} = [printname(2:end) ext]; %rid of either 'a' or 'z' used for sort
    fprintf('%s',STR0);
    for j=1:maxdepth
        switch Yfix(i,j) %nothing for -1
            case 0
                fprintf('%s',STR0);
            case 1
                fprintf('%s',STR1);
            case 2
                if fd{i,3}==1
                    fprintf('%s',STRFOLDER);
                else
                    fprintf('%s',STRFILE);
                end
        end
    end
    fprintf('%s\n',allprintname{i});
end
fprintf('```\n');
%% Print it to the screen as a Table
fprintf('| %*s | %*s |\n',maxstrlen,'Name',20,'Description');
fprintf('|%s:|%s|\n',repmat('-',1,maxstrlen+1),repmat('-',1,20+2));
for i=1:nentry
    if fd{i,3}==1
        fprintf('| %*s | %*s |\n',maxstrlen,allprintname{i},20,'Folder Description');
    else
        fprintf('| %*s | %*s |\n',maxstrlen,allprintname{i},20,'File Description');
    end
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