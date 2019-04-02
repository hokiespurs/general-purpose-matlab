% checkellip2orthometric
% check that the geoid is applied correctly

%% Constants
% truth values are from OPUS report from Channel Islands, CA (2018)
lon = -dms2degrees([119 41  5.63957]);
lat = dms2degrees([34  1  9.86873]);
h =  -31.671;
true_H = 4.202;

geoid = readGeoid12B;

%% Compute
myH = ellip2orthometric(lat,lon,h,geoid);

%% Check
fprintf('\nCheck Application of Geoid\n');
fprintf('%10s | %10s | %10s\n','Computed','Truth','Delta');
fprintf('%10f | %10f | %10f\n\n',myH,true_H,myH-true_H);