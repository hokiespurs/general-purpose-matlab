function inputParserTemplate(args,flag,defaultvals)
% INPUTPARSERTEMPLATE generates code to use parse given optional parameters
%   The inputParserTemplate allows you to easily generate code to use the
%   inputParser function in matlab.
% 
% Inputs:
%   - args : Cell array of variable names (must be valid names)
%   - flag : Flag to indicate if the type of input
%         * 1 : Required : This variable must be input
%         * 2 : Optional : Can be omitted, but all optional variables 
%                  must be used before any parameter variable can be called
%         * 3 : Parameter: 'string',value pair of optional variables
% Optional Inputs:
%   - defaultvals : default values for optional/parameter values
%
% Outputs:
%   - code printed to screen, copy it into your function
% 
% Examples:
%     args = {'reqA','reqB','optC','paramD','paramE'};
%     flag = [1 1 2 3 3];
%     inputParserTemplate(args,flag)
%
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 08-Sep-2017
% Date Modified : 08-Sep-2017
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%% Check Inputs to Function
if nargin==2
    defaultvals = [];
end
defaultvals = checkFunctionInputs(args,flag,defaultvals);

%% Function Definition
clc
printFunctionDefinition(args,flag);

%% Header Block
printHeaderBlock(args,flag,defaultvals);

%% Function Call
fprintf('\n\n%%%% Function Call\n');
printFunctionCall(args,flag);

fprintf('\nend\n');
%% parseInputs Function 
printParseInputsFun(args,flag,defaultvals);

end

function alldefault = checkFunctionInputs(args,flag,defaultvals)
%% Checks the inputs and throws errors if things are unhappy
% returns a defaultvals variable thats filled with 0s if empty
% also makes default vals a string to be output with quotes if needed

if ~iscell(args)
   error('args must be a cell'); 
end

if ~isnumeric(flag)
   error('flag must be numeric'); 
end

if ~iscell(defaultvals) && ~isempty(defaultvals)
   error('defaultvals must be a cell (or empty for default 0s)'); 
end

if numel(flag)~=numel(args)
    error('must be one flag for each argument')
end

if sum(any(flag(:)' == [1 2 3]'))~=numel(args)
    error('flag values can only be 1,2, or 3');
end

if isempty(defaultvals)
   noptional = sum(any(flag(:)'==[2 3]'));
   tempdefaultvals = cell(noptional,1);
   for i=1:noptional
      tempdefaultvals{i}='0'; 
   end
else
   noptional = sum(any(flag(:)'==[2 3]'));
   tempdefaultvals = cell(noptional,1);
   for i=1:noptional
       %try to convert the default value to a double
       if isempty(defaultvals{i})
           tempdefaultvals{i}=sprintf('[]');
       elseif isnumeric(defaultvals{i})
           tempdefaultvals{i}=sprintf('%g',defaultvals{i});
       else
           tempdefaultvals{i}=sprintf('''%s''',defaultvals{i});
       end
   end
end
alldefault = cell(numel(args),1);
alldefault(any(flag(:)'==[2 3]'),1)=tempdefaultvals;

end

function str = printFunctionDefinition(args,flag)
%% prints the function definition for a function called "myfunction"
nrequired  = sum(flag==1);
noptional  = sum(flag==2);
nparameter = sum(flag==3);

printargs = '';
if nrequired>0
    printargs = [printargs sprintf('%s,',args{flag==1})];
end

if noptional+nparameter>0
   printargs = [printargs 'varargin,'];
end

if nargout==0
    fprintf(['function myfunction(' printargs(1:end-1) ')\n']);
else
    str = printargs(1:end-1);
end

end

function printHeaderBlock(args,flag,defaultvals)
%% Prints the header block showing the input variables
% summary
nargs = numel(args);
maxstrlen = max(cellfun(@numel,args));

% function header
fprintf('%% MYFUNCTION Short summary of this function goes here\n');
fprintf('%%   Detailed explanation goes here\n%%\n');

% inputs
fprintf('%% Required Inputs: (default)\n');
for i=1:nargs
    if flag(i)==1
        fprintf('%%\t- %-*s : *description* \n',maxstrlen+2,['' args{i} '']);
    end
end

fprintf('%% Optional Inputs: (default)\n');
for i=1:nargs
    if flag(i)==2
        fprintf('%%\t- %-*s : (%s) *description* \n',maxstrlen+2,['' args{i} ''],defaultvals{i});
    end
end

for i=1:nargs
    if flag(i)==3
        fprintf('%%\t- %-*s : (%s) *description* \n',maxstrlen+2,['''' args{i} ''''],defaultvals{i});
    end
end

%% blank remainder of h1 header block
fprintf('\n');
fprintf('%% Outputs:\n');
fprintf('%%   - [enter any outputs here] \n');
fprintf('%% \n');
fprintf('%% Examples:\n');
fprintf('%%   - [enter any example code here]\n');
fprintf('%% \n');
fprintf('%% Dependencies:\n');
fprintf('%%   - [unknown]\n');
fprintf('%% \n');
fprintf('%% Toolboxes Required:\n');
fprintf('%%   - [unknown]\n');
fprintf('%% \n');
fprintf('%% Author        : Richie Slocum\n');
fprintf('%% Email         : richie@cormorantanalytics.com\n');
fprintf('%% Date Created  : %s\n',datestr(now,'dd-mmm-yyyy'));
fprintf('%% Date Modified : %s\n',datestr(now,'dd-mmm-yyyy'));
fprintf('%% Github        : [enter github web address]\n');

end

function str = printFunctionCall(args,flag)
%% Print the call of the function
nrequired  = sum(flag==1);
noptional  = sum(flag==2);
nparameter = sum(flag==3);

%outvars
outvars = '';
if nrequired>0
    outvars = [outvars sprintf('%s,',args{flag==1})];
end

if noptional>0
   outvars = [outvars sprintf('%s,',args{flag==2})];
end

if nparameter>0
   outvars = [outvars sprintf('%s,',args{flag==3})];
end
outvars = outvars(1:end-1);

%invars
printfun = 'parseInputs(';
if nrequired>0
    printfun = [printfun sprintf('%s,',args{flag==1})];
end

if noptional + nparameter>0
   printfun = [printfun 'varargin{:},'];
end
printfun = printfun(1:end-1);

if nargout==0
    fprintf(['[' outvars '] = ' printfun ');\n']);
else
    str = [' = ' printfun];
end
end

function printParseInputsFun(args,flag,defaultvals)
%% Prints out the function 'parseInputs'
varnames = '[';

for i=1:numel(args)
if flag(i)==1
   varnames = [varnames sprintf('%s,',args{i})];
end
end
for i=1:numel(args)
if flag(i)==2
   varnames = [varnames sprintf('%s,',args{i})];
end
end
for i=1:numel(args)
if flag(i)==3
   varnames = [varnames sprintf('%s,',args{i})];
end
end
varnames = [varnames(1:end-1) ']'];

strout = printFunctionCall(args,flag);
fprintf(['\nfunction ' varnames strout(1:end-3) ')\n']);
fprintf('%%%%\t Call this function to parse the inputs\n\n');

%% Default Values
fprintf('%% Default Values\n');
maxdefaultstrlen = max(cellfun(@numel,args(ismember(flag,[2 3]))));

for i=1:numel(args)
   if ismember(flag(i),[2 3])
       fprintf('%-*s = %s;\n',9+maxdefaultstrlen,['default_' args{i}],defaultvals{i});
   end
end

%% Check Functions
fprintf('\n%% Check Values\n');
maxcheckstrlen = max(cellfun(@numel,args));
for i=1:numel(args)
    fprintf('%-*s = @(x) true;\n',7+maxcheckstrlen,['check_' args{i}]);
end

%% Parser
fprintf('\n%% Parser Values\n');
fprintf('p = inputParser;\n');
%required
if any(flag==1)
    fprintf('%% Required Arguments:\n');
    maxrequiredstrlen = max(cellfun(@numel,args(flag==1)));
    for i=1:numel(args)
        if flag(i)==1
            fprintf('addRequired(p, %-*s, %-*s);\n',...
                maxrequiredstrlen+3,['''' args{i} ''''],...
                maxrequiredstrlen+7,['check_' args{i}])
        end
    end
end
%optional
if any(flag==2)
    fprintf('%% Optional Arguments\n');
    maxrequiredstrlen = max(cellfun(@numel,args(flag==2)));
    for i=1:numel(args)
        if flag(i)==2
            fprintf('addOptional(p, %-*s, %-*s, %-*s);\n',...
                maxrequiredstrlen+3,['''' args{i} ''''],...
                maxrequiredstrlen+8,['default_' args{i}],...
                maxrequiredstrlen+7,['check_' args{i}])
        end
    end
end
%parameter
if any(flag==3)
    fprintf('%% Parameter Arguments\n');
    maxrequiredstrlen = max(cellfun(@numel,args(flag==3)));
    for i=1:numel(args)
        if flag(i)==3
            fprintf('addParameter(p, %-*s, %-*s, %-*s);\n',...
                maxrequiredstrlen+3,['''' args{i} ''''],...
                maxrequiredstrlen+8,['default_' args{i}],...
                maxrequiredstrlen+7,['check_' args{i}])
        end
    end
end
%% parse 
fprintf('%% Parse\n');
strval = printFunctionDefinition(args,flag);
fprintf(['parse(p,' strval '{:});\n']);

%% Break Parser into Variables (requires v2struct)
fprintf('%% Convert to variables\n');
for i=1:numel(args)
   fprintf('%-*s = p.Results.(''%s'');\n',maxcheckstrlen,args{i},args{i}); 
end
fprintf('end\n');
end