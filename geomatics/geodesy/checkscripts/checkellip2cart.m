%% check Ellip2cart and cart2ellip
% check conversion from ellipsoid to geocentric cartesian coordinates
clc
clear

fprintf('\nTesting Ellipsoid to Cartesian Transformation \n\n');

%% True values
%NAD83 Ellipsoid
Ellipdef.a  =  6378137;
Ellipdef.f  = 1/298.257222100882711243;
Ellipdef.e2 = 2*Ellipdef.f-Ellipdef.f^2;

% coordinates from OPUS report (Channel Islands, CA, 2019)
truelat = dms2degrees([34 1 9.86873]);
truelon = -dms2degrees([119 41 5.63957]);
trueh   = -31.671;

truex = -2620769.558;
truey = -4597513.118;
truez = 3548213.378;

%% Compute
[myx,myy,myz]=ellip2cart(Ellipdef,truelat,truelon,trueh);
[mylat,mylon,myh]=cart2ellip(Ellipdef,truex,truey,truez);

%% Compare
fprintf('   Forward Projection   \n');
fprintf('        | %10s | %16f | %16f | %20.8f \n','X',myx,truex,myx-truex);
fprintf('        | %10s | %16f | %16f | %20.8f \n','Y',myy,truey,myy-truey);
fprintf('        | %10s | %16f | %16f | %20.8f \n','Z',myz,truez,myz-truez);
fprintf('\n   Inverse Projection   \n');
fprintf('        | %10s | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f |\n','Lat',...
    degrees2dms(mylat),degrees2dms(truelat),degrees2dms(mylat-truelat));
fprintf('        | %10s | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f |\n','Lon',...
    degrees2dms(mylon),degrees2dms(truelon),degrees2dms(mylon-truelon));
fprintf('        | %10s | %16f | %16f | %16f \n','h',myh,trueh,myh-trueh);