%%
val = 34;
str = {'Santiam Pass1 44 23 05.17700 121 55 40.80530 33659.19921 45587.37939'
'Santiam Pass2 44 26 02.55048 121 56 56.00645 39123.57959 43885.68277'
'Santiam Pass3 44 45 49.32354 122 38 12.10401 75623.61352 -10823.89864'};
STR = 'Santiam Pass';

for i=1:3
x = strsplit(str{i},' ');
E{i} = x{end};
N{i} = x{end-1};
lon{i} = [x{end-4} ' ' x{end-3} ' ' x{end-2}];
lat{i} = [x{end-7} ' ' x{end-6} ' ' x{end-5}];
end

fprintf('%% %s\n',STR);
fprintf('truelat{%.0f} = dms2degrees([  %s;  %s;  %s]);\n',val,lat{:});
fprintf('truelon{%.0f} = -dms2degrees([%s; %s; %s]);\n',val,lon{:});
fprintf('trueN{%.0f} = [%s; %s; %s];\n',val,N{:});
fprintf('trueE{%.0f} = [%s; %s; %s];\n',val,E{:});
fprintf('zonestr{%.0f} = ''%s'';\n',val,STR);