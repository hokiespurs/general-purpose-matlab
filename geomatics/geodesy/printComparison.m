function printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,str)
headerstr = repmat('-',1,50);
nchar = numel(str);
headerstr(6:6+nchar+1) = [' ' str ' '];

fprintf(' %s \n',headerstr);
fprintf('\n   Forward Projection   \n');
fprintf('        | %13s | %16s | %16s | %16s |\n','','Calculated','True','Delta');
for i=1:numel(myE)
    fprintf('        | %10s(%i) | %16f | %16f | %16f |\n','Easting',i,myE(i),trueE(i),myE(i)-trueE(i));
    fprintf('        | %10s(%i) | %16f | %16f | %16f |\n','Northing',i,myN(i),trueN(i),myN(i)-trueN(i));
end
fprintf('\n   Inverse Projection   \n');
fprintf('        | %13s | %16s | %16s | %16s |\n','','Calculated','True','Delta');
for i=1:numel(myE)
    
    fprintf('        | %10s(%i) | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f |\n','Lat',i,...
        degrees2dms(mylat(i)),degrees2dms(truelat(i)),degrees2dms(mylat(i)-truelat(i)));
    fprintf('        | %10s(%i) | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f | %4.0f %02.0f %08.4f |\n','Lon',i,...
        degrees2dms(mylon(i)),degrees2dms(truelon(i)),degrees2dms(mylon(i)-truelon(i)));
end


end