function printComparison(truelat,truelon,trueE,trueN,mylat,mylon,myE,myN,str,thresh)
% Prints (PASS) if it passed, or prints out the data and deltas if failed
if nargin==9
    thresh = [0.01 0.001/3600];
end

headerstr = repmat('-',1,50);
nchar = numel(str);
headerstr(6:6+nchar+1) = [' ' str ' '];


checkdiff = zeros(4,1);
checkdiff(1) = any(abs(trueE-myE)>thresh(1));
checkdiff(2) = any(abs(trueN-myN)>thresh(1));
checkdiff(3) = any(abs(truelat-mylat)>thresh(2));
checkdiff(4) = any(abs(truelon-mylon)>thresh(2));

if any(checkdiff)
    
    fprintf(' %s (FAIL)\n',headerstr);
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
else
    fprintf(' %s (PASS)\n',headerstr);
    
end