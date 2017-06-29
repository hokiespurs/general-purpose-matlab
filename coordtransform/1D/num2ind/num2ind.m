function xind = num2ind(x,lim,numlevels)
% NUM2IND Converts x to indices based on limits and number of indices
%   The values in x are linearly interpolated to index values evenly spaced
%   between lim(1) and lim(2)
% 
% Inputs:
%   - x         : values to be converted to indices
%   - lim       : limits of the values
%   - numlevels : number of index levels
% 
% Outputs:
%   - xind      : output index values of x
% 
% Examples:
%   x = rand(10,1);
%   xind = num2ind(x,[0.2 0.8],7)
%   [x xind]
%
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 26-Mar-2016    
% Date Modified : 11-Jun-2017   
% Github        : https://github.com/hokiespurs/general-purpose-matlab   

%% Convert a number to an index based on limits and number of levels
if lim(2)-lim(1)==0 
    %this handles if a desired lim has no range, set to mean level
    xind(:) = round(numlevels)/2;
else
    xind=round(changeScale(x,lim,[1 numlevels]));
    
    xind(xind<1)=1;
    xind(xind>numlevels)=numlevels;
end
end

function y = changeScale(x,LIMX,LIMY)
% change scale from Limits of X to Limits of Y
m = abs(diff(LIMY))/abs(diff(LIMX));

b = LIMY(1) - LIMX(1)*m;

y = m.*x + b;

end