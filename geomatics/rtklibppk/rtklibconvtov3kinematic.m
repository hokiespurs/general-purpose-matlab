function rtklibconvtov3kinematic(infile,outfile,markername)

SYSTEMCMD = sprintf('convbin.exe');
strargs{1} = ' -v "3.03"';                  % Output Format
strargs{2} = sprintf(' -hm "%s"',markername); % Marker name
strargs{3} = ' -od -os -oi -ot -ol';        % Doppler, snr, iono corr, time corr, leap seconds
strargs{4} = sprintf(' -o "%s"',outfile);
strargs{5} = ' -ts 2018/01/01 00:00:00 ';  % Start Time
strargs{6} = sprintf(' "%s"',infile);

sendcmd = SYSTEMCMD;
for i=1:numel(strargs)
   sendcmd = [sendcmd strargs{i}]; 
end

[~,~] = system(sendcmd);

%% Read File
fid = fopen(outfile,'r');
a = fread(fid,'*char');
lines = strsplit(a','\n');
for i=1:100
    if (lines{i}(1)=='>')
       break; 
    end
end
fclose(fid);
firstline = i;
%% Write File
fid = fopen(outfile,'w+t');
for i=1:numel(lines)
    if i==firstline
        fprintf(fid,'>                              2  0                     \n');
    end
    fprintf(fid,'%s\n',lines{i}(1:end-1));
end
fclose(fid);
end