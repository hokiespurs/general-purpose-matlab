function tseconds = secondsofweek(tdatenum)
%% Compute the time in seconds from start of week
tsecondsOfDay = hour(tdatenum)*60*60 ...
              + minute(tdatenum)*60 ...
              + second(tdatenum);
          
dayofweek = weekday(tdatenum) - 1; % 0 = sunday, 6 = saturday

tseconds = tsecondsOfDay + dayofweek * 60*60*24;

end