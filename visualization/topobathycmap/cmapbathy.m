function cmap = cmapbathy(varargin)
% CMAPBATHY Quick way to make a colormap based on the JERLOV water types
%   Detailed explanation goes here
%
% (jerlovname,nvals,seafloorcolor,atmoscolor,depthrange)
% Required Inputs: 
% Optional Inputs: (default)
%	- depthrange      : ([0 10]) *description* 
%	- nvals           : (64) *description* 
%	- jerlovname       : ('I') *description* 
%	- seafloorcolor   : ([233 215 199]/255) default seafloor color 
%	- atmoscolor      : ([1 1 1]) *description* 
% 
% Outputs:
%   - [enter any outputs here] 
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

%% JERLOV Constants for RGB
JERLOVNAMES = {'I', 'IA','IB', 'II','III',  '1',  '3',  '5',  '7',  '9'};
JERLOVRGB   = [59    59    58    56    54    54    51    45    40    33
               96    95    95    92    88    88    82    73    61    47
               98    98    97    94    89    87    79    65    48    27]/100;

MAXDEPTH    = [20    20    15   9.7   5.2   4.7     3   1.9   1.2    0.8]; 

% Add my custom one
JERLOVRGB(:,11) = [65; 93; 98]/100; 
MAXDEPTH(11)    = 10;
JERLOVNAMES{11} = 'rs';
%% Parse input values
[jerlovname,nvals,seafloorcolor,atmoscolor,depthrange] = parseInputs(varargin{:});

jerlovind = find(strcmp(jerlovname,JERLOVNAMES));

if depthrange(2)>100
   depthrange(2)=MAXDEPTH(jerlovind); 
end

%%
isdepthpositive = true;
if any(depthrange<0)
   depthrange = [min(abs(depthrange)) max(abs(depthrange))];
   isdepthpositive = false;
end
%%
depthvals = depthrange(1):0.01:depthrange(2);
rgb = calcRGBfalloff(depthrange(1):0.01:depthrange(2),atmoscolor,JERLOVRGB(:,jerlovind),seafloorcolor);
cmapdepths = linspace(depthrange(1),depthrange(2),nvals);
cmap = interp1(depthvals',rgb',cmapdepths,'linear','extrap');

%% 
if isdepthpositive
   cmap = flipud(cmap); 
end
end

function rgb = calcRGBfalloff(depth,atmosRGB,attenuationRGB,diffuseRGB)
% depth in meters
% RGB = [0 1]

scaleup = 1;

RGB_ATMOS2BOTTOM(1,:) = scaleup*atmosRGB(1)*(attenuationRGB(1)).^(depth);
RGB_ATMOS2BOTTOM(2,:) = scaleup*atmosRGB(2)*(attenuationRGB(2)).^(depth);
RGB_ATMOS2BOTTOM(3,:) = scaleup*atmosRGB(3)*(attenuationRGB(3)).^(depth);

rgb(1,:) = diffuseRGB(1)*RGB_ATMOS2BOTTOM(1,:).*(attenuationRGB(1)).^(depth)/scaleup;
rgb(2,:) = diffuseRGB(2)*RGB_ATMOS2BOTTOM(2,:).*(attenuationRGB(2)).^(depth)/scaleup;
rgb(3,:) = diffuseRGB(3)*RGB_ATMOS2BOTTOM(3,:).*(attenuationRGB(3)).^(depth)/scaleup;

end

function [jerlovname,nvals,seafloorcolor,atmoscolor,depthrange] = parseInputs(varargin)
%%	 Call this function to parse the inputs

% Default Values
default_jerlovname     = 'I';
default_depthrange     = [0 999]; % triggers using the max depth
default_nvals          = 64;
default_seafloorcolor  = [233 215 199]/255;
default_atmoscolor     = [1 1 1];

% Check Values
check_jerlovname     = @(x) isstring(x) | ischar(x);
check_depthrange     = @(x) isnumeric(x) & numel(x)==2;
check_nvals          = @(x) isnumeric(x) & numel(x)==1;
check_seafloorcolor  = @(x) isnumeric(x) & numel(x)==3 & ~any(x>1);
check_atmoscolor     = @(x) isnumeric(x) & numel(x)==3 & ~any(x>1);


% Parser Values
p = inputParser;
% Optional Arguments
addOptional(p, 'depthrange'    , default_depthrange   , check_depthrange  );
addOptional(p, 'nvals'         , default_nvals        , check_nvals       );
addOptional(p, 'jerlovname'    , default_jerlovname   , check_jerlovname   );
addOptional(p, 'seafloorcolor' , default_seafloorcolor, check_seafloorcolor );
addOptional(p, 'atmoscolor'    , default_atmoscolor   , check_atmoscolor  );

% Parse
parse(p,varargin{:});
% Convert to variables
depthrange    = p.Results.('depthrange');
nvals         = p.Results.('nvals');
jerlovname    = p.Results.('jerlovname');
seafloorcolor = p.Results.('seafloorcolor');
atmoscolor    = p.Results.('atmoscolor');
end
