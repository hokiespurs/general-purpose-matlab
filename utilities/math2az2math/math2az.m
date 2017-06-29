function azangle = math2az(mathangle)
% convert math degree angle to azimuth angle
azangle = 90-mathangle;
azangle(azangle<0)=azangle(azangle<0)+360;
end

