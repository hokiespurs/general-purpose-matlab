%%
dname = 'F:\pt\corvo\polarcorvo2_files';
d2 = 'F:\pt\corvo\Apolarcorvo2_files';
d3 = 'F:\pt\corvo\Bpolarcorvo2_files';

mkdir(d2);
mkdir(d3);

imnames = dirname('*.png',1,dname);

starttime = now;
for i=1:numel(imnames)
   ind = numel(dname);
   
   Aname = [d2 imnames{i}(ind+1:end)];
   id = fileparts(Aname);
   if ~exist(id)
       mkdir(id);
   end
   
   Bname = [d3 imnames{i}(ind+1:end)];
   id = fileparts(Bname);
   if ~exist(id)
       mkdir(id);
   end
   
   image8to16(Aname,Bname,imnames{i},false);
    loopStatus(starttime,i,numel(imnames),10);
end