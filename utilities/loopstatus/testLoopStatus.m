NLOOPS = 1000;
NSKIPS = 10;
startTime = now;
for i=1:NLOOPS
    pause(.05)
    loopStatus(startTime,i,NLOOPS,NSKIPS)
end
datestr(now)