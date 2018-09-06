function [Xs,As]=calcXsAs(x,y,pt,AsAz)
%% Convert coordinates to Cross-shore and Along-shore using a pt and azimuth
% R = [cosd(az) sind(az);
%      -sind(az) cosd(az)];


%
rotangle = 90-AsAz;
As = (x-pt(1)) * cosd(rotangle) + (y-pt(2)) * sind(rotangle);
Xs = (x-pt(1)) * -sind(rotangle) + (y-pt(2)) * cosd(rotangle);



end