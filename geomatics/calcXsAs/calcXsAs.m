function [Xs,As]=calcXsAs(x,y,pt,AsAz,doinverse)
%% Convert coordinates to Cross-shore and Along-shore using a pt and azimuth
% R = [cosd(az) sind(az);
%     -sind(az) cosd(az)];

if nargin==4 || doinverse==false
    rotangle = 90-AsAz;
    As = (x-pt(1)) * cosd(rotangle) + (y-pt(2)) * sind(rotangle);
    Xs = (x-pt(1)) * -sind(rotangle) + (y-pt(2)) * cosd(rotangle);
else % do inverse
    rotangle = -(90-AsAz);
    Xs = (y) * cosd(rotangle) + (x) * sind(rotangle) + pt(1);
    As = (y) * -sind(rotangle) + (x) * cosd(rotangle) + pt(2);
end

end