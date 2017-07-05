function [HH,MM,SS,dd] = calchms(tseconds)
%% Calculate time in seconds to HMS and Days

dd = mod(floor(tseconds/(24*60*60)),0);
HH = mod(floor(tseconds/(60*60)),24);
MM = mod(floor(tseconds/(60)),60);
SS = mod(tseconds,60);

end