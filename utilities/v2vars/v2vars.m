function varargout = v2vars(v,dim)
% V2VARS Helper function to convert a vector to multiple variables
%   This function saves you the time of writing a bunch of lines to
%   generate multiple variables from one matrix. This really isn't the best
%   coding practice, but it does make the code easier to interpret.
% 
% Inputs:
%   - v   : Matrix of variables
%   - dim : Dimension to loop through to extract new variables
% 
% Outputs:
%   - varargout: multiple outputs depending on size of matrix v 
% 
% Examples:
%   xyz = rand(10,3);
%   [x,y,z] = v2vars(xyz,2);
% 
%   RGB = imread('fabric.png');
%   [R,G,B]=v2vars(RGB,3);
%   RGB2 = cat(3,R+50,G+50,B+50);
%   
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 9-Jun-2017    
% Date Modified : 11-Jun-2017
% Github        : https://github.com/hokiespurs/general-purpose-matlab

if nargin==1
    [m,n,p]=size(v);
    dim = find([m n p]~=1,1,'first');
    if isempty(dim)
        warning('Nothing is happening in v2vars');
        dim = 1;
    end
end
if nargout>size(v,dim)
    error('Too many output variables... theres no data there');
end
varargout = cell(1,nargout);

% reshape the array so that the desired data is along the first dimension
permuteorder = [dim 1:ndims(v)];
permuteorder(dim+1)=[];
v = permute(v,permuteorder);
% calculate the order to go back to the same structure
[~,inversePermuteOrder]=sort(permuteorder);

%get data for each nargout
for i=1:nargout
    iv = permute(v(i,:,:,:),inversePermuteOrder);
    varargout{i} = iv;
end
end