function t = getImageTime(imnames,dname)

if nargin==1
   dname = '.'; 
end

if ~iscell(imnames)
   allnames{1} = imnames;
else
   allnames = imnames;
end

t = nan(size(allnames));
for i=1:numel(allnames)
    x = imfinfo([dname '/' allnames{i}]);
    t(i) = datenum(x.DigitalCamera.DateTimeOriginal,'yyyy:mm:dd HH:MM:ss');
    t(i) = t(i) + (str2double(x.DigitalCamera.SubsecTime)/100)/24/60/60;
end

end