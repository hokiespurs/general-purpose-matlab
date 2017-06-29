function R = euler2dcm(rx,ry,rz,order)
% EULER2DCM Calculate Direction Cosine Matrix (DCM)
%   Computes the DCM when given rotation angles in radians about the 3 axes
% 
% Inputs:
%   - rx    : rotation about the x axis (radians)
%   - ry    : rotation about the y axis (radians)
%   - rz    : rotation about the z axis (radians)
%   - order : order of rotation (eg. zyx, xyz, zxy)
% 
% Outputs:
%   - R : DCM Rotation Matrix 
% 
% Examples:
%   roll = pi/3;pitch=0;yaw = pi;
%   R = euler2dcm(roll,pitch,yaw);
%
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum    
% Email         : richie@cormorantanalytics.com    
% Date Created  : 14-Jun-2017    
% Date Modified : 14-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab    

Rx = [1 0 0; 0 cos(rx) sin(rx); 0 -sin(rx) cos(rx)];
Ry = [cos(ry) 0 -sin(ry); 0 1 0;sin(ry) 0 cos(ry)];
Rz = [cos(rz) sin(rz) 0; -sin(rz) cos(rz) 0; 0 0 1];

if nargin==3 %default order
    order = 'zyx';
end

R = eye(3);
for i=1:3
    switch order(i)
        case {'x','X',1}
            R = Rx * R;
        case {'y','Y',2}
            R = Ry * R;
        case {'z','Z',3}
            R = Rz * R;
    end
end

end