function [weeknum,dow,sow]=gpstime(tdatenum)
% GPSTIME computes the weeknumber, day of week, and second of week
% 
% Inputs:
%   - tdatenum : GPS Datenum Time
% 
% Outputs:
%   - weeknum : GPS Week Number
%   - dow     : GPS Day of week (0-6)
%   - sow     : GPS Seconds of week
% 
% Examples:
%   - [weeknum,dow,sow]=gpstime(datenum('Apr 5, 2018'));
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 20-May-2018
% Date Modified : 20-May-2018
% Github        : https://github.com/hokiespurs/general-purpose-matlab
TROLLOVER = [datenum(1999,8,22) datenum(2019,4,07)];
GPSWEEK = [1024 2048];

if tdatenum>TROLLOVER(2)
    t0 = TROLLOVER(2);
    weekoffset = GPSWEEK(2);
else
    t0 = TROLLOVER(1);
    weekoffset = GPSWEEK(1);
end

weeknum = floor((tdatenum-t0)/7) + weekoffset;

dow = weekday(tdatenum) - 1; % 0 = sunday, 6 = saturday

tsecondsOfDay = (tdatenum-floor(tdatenum))*24*60*60;
sow = tsecondsOfDay + dow * 60*60*24;

end