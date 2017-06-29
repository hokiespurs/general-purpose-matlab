function checkInterp1nanthresh
%% Check 1
% dx      4     5  6      
x = [1 2 3 7 8 9 14 20 21];
y = [1 2 3 7 8 9 14 20 19];
% dy      4     5  6  
xi = 0:21;

MAXDX = 6;
MAXDY = 6;
yi = interp1nanthresh(x,y,xi,MAXDX,MAXDY);
% ends are nan because its not extrapolating

TRUEYI = [nan 1:20 19];
checkVal(yi,TRUEYI);

MAXDX = 4;
MAXDY = 5;
yi = interp1nanthresh(x,y,xi,MAXDX,MAXDY);

TRUEYI([11:14 16:20])=nan;
checkVal(yi,TRUEYI)

%% Check 2 w/ duplicates
% (3,2) and (3,4) should be averaged
% dx      4     5  6     
x = [1 2 3 3];
y = [1 2 2 4];
% dy      4     5  6  
xi = 0:3;

MAXDX = 6;
MAXDY = 6;
yi = interp1nanthresh(x,y,xi,MAXDX,MAXDY);

TRUEYI = [nan 1 2 3];
checkVal(yi,TRUEYI)

%% ALL GOOD
fprintf('ALL CHECKS PASSED\n');
end
function checkVal(x,y)
isgoodYI = x == y | (isnan(x) & isnan(y));
if any(~isgoodYI)
   error('Check failed');
end

end