function cmap = cmaptopobathy(z,varargin)
% CMAPTOPOBATHY Short summary of this function goes here
%   Detailed explanation goes here
%
% Required Inputs: 
%	- z          : *description* 
% Optional Inputs: (default)
%	- ncolors    : (0) *description* 
%	- cmapsea    : (0) *description* 
%	- cmapland   : (0) *description* 
% 
% Outputs:
%   - cmap       : Mx3 Colormap
% 
% Examples:
%   - [enter any example code here]
% 
% Dependencies:
%   - [unknown]
% 
% Toolboxes Required:
%   - [unknown]
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 30-Sep-2019
% Date Modified : 30-Sep-2019
% Github        : [enter github web address]


%% Function Call
[z,ncolors,cmapsea,cmapland] = parseInputs(z,varargin{:});

watervals = linspace(min(z),0,numel(cmapsea)/3);
landvals = linspace(eps,max(z),numel(cmapland)/3+1);
% make n+1 land values, then remove the first one, this makes a soft
% transition at the 0 crossing... could change this, or maybe add an option
% in the future if you REALLY want a hard color change at 0
landvals(1)=[];
if max(z)==0
   landvals = linspace(1,2,numel(cmapland)/3); % the points wont be used 
end
cmapvals = linspace(z(1),z(2),ncolors);

cmap = interp1([landvals watervals],[cmapland;cmapsea],cmapvals,'linear','extrap');

if nargout==0
   caxis(z);
   colormap(gca,cmap);
end
end

function [z,ncolors,cmapsea,cmapland] = parseInputs(z,varargin)
%%	 Call this function to parse the inputs

% Default Values
default_ncolors   = 64;
default_cmapsea   = cmapbathy;
default_cmapland  = [    0.8387    0.9419    0.6806
    0.8066    0.9032    0.6060
    0.7805    0.8645    0.5354
    0.7596    0.8258    0.4688
    0.7431    0.7871    0.4062
    0.7301    0.7484    0.3476
    0.7097    0.6996    0.2930
    0.6710    0.6306    0.2424
    0.6323    0.5607    0.1958
    0.5935    0.4906    0.1532
    0.5548    0.4211    0.1145
    0.5161    0.3531    0.0799
    0.4774    0.2875    0.0493
    0.4387    0.2251    0.0226
    0.4000    0.1667         0];

% Check Values
check_z         = @(x) true;
check_ncolors   = @(x) true;
check_cmapsea   = @(x) true;
check_cmapland  = @(x) true;

% Parser Values
p = inputParser;
% Required Arguments:
addRequired(p, 'z' , check_z );
% Optional Arguments
addOptional(p, 'ncolors'  , default_ncolors , check_ncolors  );
addOptional(p, 'cmapsea'  , default_cmapsea , check_cmapsea  );
addOptional(p, 'cmapland' , default_cmapland, check_cmapland );
% Parse
parse(p,z,varargin{:});
% Convert to variables
z        = p.Results.('z');
ncolors  = p.Results.('ncolors');
cmapsea  = p.Results.('cmapsea');
cmapland = p.Results.('cmapland');
end