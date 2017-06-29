function mathangle = az2math(azangle)
% convert azimuth degree angle to math angle
mathangle = 90-azangle;
mathangle(mathangle<0)=mathangle(mathangle<0)+360;

end