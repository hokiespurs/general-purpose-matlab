function tseconds = secondsofweek(tdatenum)
%% Compute the time in seconds from start of week
tsecondsOfDay = (tdatenum-floor(tdatenum))*24*60*60;
          
dayofweek = weekday(tdatenum) - 1; % 0 = sunday, 6 = saturday

tseconds = tsecondsOfDay + dayofweek * 60*60*24;

end