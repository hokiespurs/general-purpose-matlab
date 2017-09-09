function makefunctionh1(mfile,userInputs,savetofile,optParts)
% MAKEFUNCTIONHEADER - generates header info for functions
%   Reads the function and prints out a template for what the h1 header of
%   the file should look like.
%   NOTE: The dependencies are only accurate for files on the current path
%
% Inputs:
%   - functionname  : full filepath to function
%   - userInputs    : logical for user input(true), empty template(false)
%   - savetofile    : logical save into file(true), print to screen(false)
%   - optionalparts : 1x16 : binary
%        binary indicator for which parts of the header file to make
%        (1) Short description
%        (2) Long description
%        (3) Input Size
%        (4) Input Type
%        (5) Input Description
%        (6) Output Size
%        (7) Output Type
%        (8) Output Description
%        (9) Examples
%        (10)Dependency Files
%        (11)Dependency Toolboxes
%        (12)TODO
%        (13)Author
%        (14)Email
%        (15)Date Created
%        (16)Date Modified
%        (17)Github Repository
%
% Outputs:
%   - n/a
%
% Examples:
%   - makefunctionh1('makefunctionh1.m');
%
% Dependencies:
%   - n/a
%
% Toolboxes Required:
%   - n/a
%
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : March 23, 2016
% Date Modified : March 23, 2016  
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%% Handle Inputs
if nargin == 1
    userInputs=0;
    savetofile=0;
    optParts=ones(1,17);
    optParts([3 4 6 7 12])=0;
elseif nargin == 2
    savetofile=0;
    optParts=ones(1,17);
elseif nargin == 3
    optParts=ones(1,17);
elseif nargin>4
    error('Too Many Inputs');
end
%% Set Constants
LWIDTH = 75;
L1 = 3;
L2 = 8;
%% Get Function Name
[~,fname,~] = fileparts(mfile);

%% Read in data, extract function inputs and end of first line index
[inVars,outVars]=getFunctionIO(mfile);

nInVars = numel(inVars);
nOutVars = numel(outVars);

%% Preallocate Default Values as Blank
uInputs = cell(16,max([nInVars nOutVars]));
uInputs(:)={'    '};
uInputs{1} = 'Short summary of this function goes here';
uInputs{2} = 'Detailed explanation goes here';
uInputs([3 6],:)={'Size'};
uInputs([4 7],:)={'Class'};
uInputs([5 8],:)={'Description of variable goes here'};
uInputs{9} = 'Example code goes here';
uInputs{12} = 'list of todo items goes here';

uInputs{13} = 'Richie Slocum';
uInputs{14} = 'richie@cormorantanalytics.com';
uInputs{15} = datestr(now,'dd-mmm-yyyy');
uInputs{16} = datestr(now,'dd-mmm-yyyy');
uInputs{17} = '';
%% If prompt inputs, run through use inputs
if userInputs
    if optParts(1)  , uInputs(1)            = getShortDescrip(fname); end
    if optParts(2)  , uInputs(2)            = getLongDescrip(fname);  end
    if optParts(3)  , uInputs(3,1:nInVars)  = getSize(inVars,1);      end
    if optParts(4)  , uInputs(4,1:nInVars)  = getType(inVars,1);      end
    if optParts(5)  , uInputs(5,1:nInVars)  = getDescrip(inVars,1);   end
    if optParts(6)  , uInputs(6,1:nOutVars) = getSize(outVars,0);     end
    if optParts(7)  , uInputs(7,1:nOutVars) = getType(outVars,0);     end
    if optParts(8)  , uInputs(8,1:nOutVars) = getDescrip(outVars,0);  end
    if optParts(9)  , uInputs(9)            = getExamples(fname);     end
    if optParts(12) , uInputs(12)           = getTODO(fname);         end
    if optParts(13) , uInputs(13)           = getAuthor(fname);       end
    if optParts(14) , uInputs(14)           = getEmail(fname);        end
    if optParts(15) , uInputs(15)           = getDateCreated(fname);  end
    if optParts(16) , uInputs(16)           = getDateModified(fname); end
    if optParts(17) , uInputs(17)           = getGithub(fname);       end
end
if optParts(10) || optParts(11)
    [fListNames,pListNames] = getDependencies(mfile);
    if optParts(10) , uInputs{10} = fListNames; end
    if optParts(11) , uInputs{11} = pListNames; end
end

%%
% load('test.mat')
%% Header Parts
H = '';
if optParts(1)   ,H = [H addShortHeader(uInputs,fname,LWIDTH)];         end
if optParts(2)   ,H = [H addLongHeader(uInputs,L1,LWIDTH)];             end

if sum(optParts(3:5))
    H = [H addVars(optParts(3:5),uInputs(3:5,:),inVars,1,L1,L2,LWIDTH)]; end

if sum(optParts(6:8))
    H = [H addVars(optParts(6:8),uInputs(6:8,:),outVars,0,L1,L2,LWIDTH)];end

if optParts(9)   ,H = [H addExamples(uInputs{9},LWIDTH,L1)];            end
if optParts(10)  ,H = [H addDependencyFiles(uInputs{10},L1,LWIDTH)];    end
if optParts(11)  ,H = [H addToolboxes(uInputs{11},L1,LWIDTH)];          end
if optParts(12)  ,H = [H addTODO(uInputs{12},L1,L2,LWIDTH)];            end
if optParts(13)  ,H = [H addAuthor(uInputs{13})];                       end
if optParts(14)  ,H = [H addEmail(uInputs{14})];                        end
if optParts(15)  ,H = [H addDateCreated(uInputs{15})];                  end
if optParts(16)  ,H = [H addDateModified(uInputs{16})];                 end
if optParts(16)  ,H = [H addGithub(uInputs{17})];                       end

if savetofile
    saveHeaderToFile(mfile,H);
end
fprintf(H);

end
%% Save to file
function saveHeaderToFile(mfile,H)
%% backup file
copyfile(which(mfile),[which(mfile) '_old.m']);

filechars = fileread(mfile);
H2 = strrep(H,'\n',char(10));
H2 = strrep(H2,'%%','%');

ind1 = find(filechars==')',1,'first');

fid = fopen(which(mfile),'w');
fprintf(fid,'%s\n',filechars(1:ind1));
fprintf(fid,'%s\n',H2);
fprintf(fid,'%s',filechars(ind1+1:end));
fclose(fid);

end
 
%% Adders
function H = addShortHeader(uInputs,fname,LWIDTH)
%%
H = '';
H = [H cc(1) upper(fname) ' ' uInputs{1}];
if numel(H)>LWIDTH
    H = H(1:LWIDTH); %trim anything too long
end
H = [H '\n'];
end

function H = addLongHeader(uInputs,L1,LWIDTH)
%%
H = '';
H = [H cc(L1) wrapComment(uInputs{2},L1,LWIDTH)];
H = [H cc(1) '\n'];
end

function H = addVars(opts,uInputs,vars,isInput,L1,L2,LWIDTH)
%%
if isInput
    H = [cc(1) 'Inputs:\n'];
else
    H = [cc(1) 'Outputs:\n'];
end

if ~strcmp(vars,'')
    % Calculate Padding
    nVar = max(cellfun(@numel,vars));
    nSize = max(cellfun(@numel,uInputs(1,:)));
    nType = max(cellfun(@numel,uInputs(2,:)));
    
    for i=1:numel(vars)
        H = [H cc(L1) '- ' pad(vars{i},nVar) ' : ' ];
        if opts(1)
            H = [H pad(uInputs{1,i},nSize) ' : '];
        end
        if opts(2)
            H = [H pad(uInputs{2,i},nType) ' : '];
        end
        if opts(3)
            Lin = L1 + sum([nVar+3 nSize+3 nType+3].*opts)+1;
            %           H = [H '\n' cc(Lin) wrapComment(uInputs{3,i},Lin,LWIDTH)];
            H = [H wrapComment(uInputs{3,i},Lin,LWIDTH)];
        else
            H = [H '\n'];
        end
    end
else
    H = [H cc(L1) '- n/a \n'];
end
H = [H cc(1) '\n'];

end

function H = addExamples(uInput,LWIDTH,L1)
%%
H = [cc(1) 'Examples:\n'];
for i=1:size(uInput,1)
    H = [H cc(L1) '- ' wrapComment(strtrim(uInput(i,:)),L1,LWIDTH)];
end
H = [H cc(1) '\n'];

end

function H = addDependencyFiles(uInput,L1,LWIDTH)
%%
H = [cc(1) 'Dependencies:\n'];

if isempty(uInput) || sum(strcmp(uInput,''))
    H = [H cc(L1) '- n/a\n'];
else
    for i=1:numel(uInput)
        H = [H cc(L1) '- ' uInput{i} '\n'];
    end
end
H = [H cc(1) '\n'];

end

function H = addToolboxes(uInput,L1,LWIDTH)
%%
H = [cc(1) 'Toolboxes Required:\n'];
if isempty(uInput) || sum(strcmp(uInput,''))
    H = [H cc(L1) '- n/a\n'];
else
    for i=1:numel(uInput)
        H = [H cc(L1) '- ' uInput{i} '\n'];
    end
end
H = [H cc(1) '\n'];

end

function H = addTODO(uInput,L1,L2,LWIDTH)
%%
H = [cc(1) 'TODO:\n'];
for i=1:size(uInput,1)
    H = [H cc(L1) '- ' wrapComment(strtrim(uInput(i,:)),L1,LWIDTH)];
end
H = [H cc(1) '\n'];

end

function H = addAuthor(uInput)
%%
H = [cc(1) 'Author        : ' uInput '\n'];
end

function H = addEmail(uInput)
%%
H = [cc(1) 'Email         : ' uInput '\n'];
end

function H = addDateCreated(uInput)
%%
try
    H = [cc(1) 'Date Created  : ' datestr(round(datenum(uInput))) '\n'];
catch
    H = [cc(1) 'Date Created  :     \n'];
end
end

function H = addDateModified(uInput)
%%
try
    H = [cc(1) 'Date Modified : ' datestr(round(datenum(uInput))) '\n'];
catch
    H = [cc(1) 'Date Modified :     \n'];
end
end

function H = addGithub(uInput)
%%
H = [cc(1) 'Github        : ' uInput '\n'];

end
%% Getters
function uInput = getShortDescrip(fname)
%%
prompt = ['Input a short description of ' fname];
dlgTitle = fname;
sz = [1 80];
uInput = inputdlg(prompt,dlgTitle,sz);

if isempty(uInput)
    uInput={''};
end
end

function uInput = getLongDescrip(fname)
%%
prompt = ['Input a long description of ' fname];
dlgTitle = fname;
sz = [5 80];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end

function uInput = getSize(inVars,isInput)
%%
if ~strcmp(inVars{1},'')
    prompt = inVars;
    if isInput
        inout = 'INPUT';
    else
        inout = 'OUTPUT';
    end
    dlgTitle = ['Input the SIZE of the following '...
        inout ' variables'];
    sz = [1 80];
    uInput = inputdlg(prompt,dlgTitle,sz);
    if isempty(uInput)
        uInput = cell(1,numel(inVars));
        uInput(:)={''};
    end
else
    uInput={''};
end
end
function uInput = getType(inVars,isInput)
%%
if ~strcmp(inVars{1},'')
    prompt = inVars;
    if isInput
        inout = 'INPUT';
    else
        inout = 'OUTPUT';
    end
    dlgTitle = ['Input the TYPE of the following '...
        inout ' variables'];
    sz = [1 80];
    uInput = inputdlg(prompt,dlgTitle,sz);
    if isempty(uInput)
        uInput = cell(1,numel(inVars));
        uInput(:)={''};
    end
else
    uInput={''};
end
end

function uInput = getDescrip(inVars,isInput)
%%
if ~strcmp(inVars{1},'')
    prompt = inVars;
    if isInput
        inout = 'INPUT';
    else
        inout = 'OUTPUT';
    end
    dlgTitle = ['Input a DESCRIPTION for the following '...
        inout 'variables'];
    sz = [1 80];
    uInput = inputdlg(prompt,dlgTitle,sz);
    if isempty(uInput)
        uInput = cell(1,numel(inVars));
        uInput(:)={''};
    end
else
    uInput={''};
end
end

function uInput = getExamples(fname)
%%
prompt = ['Input any examples for the use of ' fname];
dlgTitle = fname;
sz = [5 80];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end

function uInput = getTODO(fname)
%%
prompt = ['Input any TODO items for ' fname];
dlgTitle = fname;
sz = [5 80];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end

function uInput = getAuthor(fname)
%%
prompt = ['Input Author Name: '];
dlgTitle = fname;
sz = [1 40];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end

function uInput = getEmail(fname)
%%
prompt = ['Input Email: '];
dlgTitle = fname;
sz = [1 40];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end
function uInput = getGithub(fname)
%%
prompt = ['Github : '];
dlgTitle = fname;
sz = [1 40];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end
function uInput = getDateCreated(fname)
%%
prompt = ['Input Date Created: '];
dlgTitle = fname;
sz = [1 40];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end

function uInput = getDateModified(fname)
%%
prompt = ['Input Date Modified: '];
dlgTitle = fname;
sz = [1 40];
uInput = inputdlg(prompt,dlgTitle,sz);
if isempty(uInput)
    uInput={''};
end
end

function [fListNames,pListNames] = getDependencies(mfile)
%% Get .m file and toolbox dependencies
[fList,pList] = matlab.codetools.requiredFilesAndProducts(mfile);
pListNames = {pList.Name}';
fListNames = cell(numel(fList)-1,1);
for i=1:numel(fList)-1
    [~,justname,ext] = fileparts(fList{i});
    fListNames{i} = [justname ext];
end
% Remove Matlab dependency
MatlabDependencyIndex = strcmpi(pListNames,'Matlab');
pListNames(MatlabDependencyIndex)=[];
end

function x = cc(nspaces)
%% adds a comment with nspaces padded
x = ['%%' char(ones(1,nspaces)*32)];
end

function [inputVars,outputVars]=getFunctionIO(fname)
%% Return input and output args to the function fname
filechars = fileread(fname);
ind = strfind(filechars,char(10));
firstline = filechars(1:ind(1));
while ~isempty(strfind(firstline,'...'))
    ind(1)=[];
    firstline = filechars(1:ind(1));
    badinds = firstline =='.' | firstline == char(10);
    firstline(badinds)=[];
end
%% Extract Function Inputs
iLeftParenth = strfind(firstline,'(');
iRightParenth = strfind(firstline,')');
inputVars = strsplit(firstline(iLeftParenth+1:iRightParenth-1),',');
inputVars = strtrim(inputVars);

%% Extract Function Outputs
iLeftBrack = strfind(firstline,'[');
iRightBrack = strfind(firstline,']');
outputVars = strsplit(firstline(iLeftBrack+1:iRightBrack-1),',');
outputVars = strtrim(outputVars);
end

function paddedStr = pad(S,N)
%% Pad a string with trailing spaces
paddedStr = char(ones(1,N)*32);
paddedStr(1:numel(S))=S;

end

function wrappedStr = wrapComment(longStr,NINDENT,MAXLINEWIDTH)
%% Wraps a comment and precedes with '%'
nChars = numel(longStr);
nUseableWidth = MAXLINEWIDTH-NINDENT-1;

if isempty(strtrim(longStr))
    wrappedStr = '     \n';
else
    wrapStrNoComments = linewrap(longStr,nUseableWidth);
    wrappedStr = [wrapStrNoComments{1} '\n'];
    for i=2:numel(wrapStrNoComments)
        wrappedStr = [wrappedStr cc(NINDENT) wrapStrNoComments{i} '\n'];
    end
end
end