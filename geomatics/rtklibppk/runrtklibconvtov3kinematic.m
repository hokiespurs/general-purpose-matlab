%%
clc
infile = 'C:\temp\test.obs';
outfile = 'C:\temp\test_out.18o';
markername = 'UAS_0001';
rtklibconvtov3kinematic(infile,outfile,markername)

fid = fopen(outfile,'r');
a = fread(fid,'*char');
lines = strsplit(a(:)','\n');
for i=1:50
    fprintf('%s',lines{i});
end
fclose(fid);