function rtklibppkecef(rinexRover,rinexBase,navfile,baseECEF, outdir,inpfiles)
% RTKLIBPPK helper script for running rtklib binary
%   Script to automate processing PPK data
% 
% Inputs:
%   - rtklibbin    : Location of binary exe for rnx2rtkp.exe
%   - rinexRover   : Rover rinex  file
%   - rinexBase    : Base rinex file
%   - navfile      : nav file
%   - baseLatLonHt : 3 element vector of lat, lon, height 
%   - baseDatum    : text describing datum of base
%   - outdir       : output directory for 'ppkproc.pos'
%   - inpfiles     : cell array of extra input files (ephemeris/clock)
% 
% Outputs:
%   - n/a 
% 
% Examples:
%   - n/a
% 
% Dependencies:
%   - n/a
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 20-May-2018
% Date Modified : 20-May-2018
% Github        : https://github.com/hokiespurs/general-purpose-matlab

outname    = 'ppkproc.pos';
rtklibbin = 'rnx2rtkp.exe ';
syscmd = [rtklibbin ' -k -p 2 -t -c -r ' sprintf('%.9f ',baseECEF)];
syscmd = [syscmd '-o ' outdir '/' outname ' '];

syscmd = [syscmd '"' rinexRover '" '];
syscmd = [syscmd '"' rinexBase '" '];
syscmd = [syscmd '"' navfile '" '];

for i=1:numel(inpfiles)
    syscmd = [syscmd '"' inpfiles{i} '" '];
end

system(syscmd)

fid = fopen([outdir '/readme.txt'],'w+t');
fprintf(fid,'RTKLIB PROCESSING FROM MATLAB "rtklibppk.m"\n');
fprintf(fid,'Base Coordinate:\n');
fprintf(fid,' WGS84 ECEF X: %.9f\n',baseLatLonHt(1));
fprintf(fid,' WGS84 ECEF Y: %.9f\n',baseLatLonHt(2));
fprintf(fid,' WGS84 ECEF Z: %.9f\n',baseLatLonHt(3));
fprintf(fid,'System Command:\n');
fprintf(fid,' %s\n',syscmd);
fclose(fid);
end