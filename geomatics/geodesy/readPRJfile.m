function [Projdef,Ellipdef,type] = readPRJfile(fname)
%%
fid = fopen(fname,'r');
dat = fread(fid,'*char');
fclose(fid);

splitdat = strsplit(dat',{',','[',']'})';

%% Ellipsoid Parameters
Ellipdef.datum = strrep(splitdat{6},'"','');
Ellipdef.name  = strrep(splitdat{8},'"','');

Ellipdef.a    = str2double(splitdat{9});
Ellipdef.f    = 1./str2double(splitdat{10});
Ellipdef.e2   = 2*Ellipdef.f-Ellipdef.f^2;

%% Projection Parameters
Projdef.type = strrep(splitdat{18},'"','');
Projdef.name = strrep(splitdat{2},'"','');
switch Projdef.type
    case 'Transverse_Mercator'
        Projdef.latOrigin     = str2double(splitdat{33});
        Projdef.lonOrigin     = str2double(splitdat{27});
        Projdef.falseNorthing = str2double(splitdat{24});
        Projdef.falseEasting  = str2double(splitdat{21});
        Projdef.scaleFactor   = str2double(splitdat{30});
        type = 'tm';
    case 'Lambert_Conformal_Conic'
        is1sp = (str2double(splitdat{30}) == str2double(splitdat{33})) && ...
                (str2double(splitdat{30}) == str2double(splitdat{39}));
            
        if (is1sp)
            Projdef.latOrigin   = str2double(splitdat{39});
            Projdef.lonOrigin   = str2double(splitdat{27});
            Projdef.scaleFactor = str2double(splitdat{36});
            Projdef.falseEast  = str2double(splitdat{21});
            Projdef.falseNorth = str2double(splitdat{24});
            type = 'lcc1sp';
        else
            Projdef.falseLat   = str2double(splitdat{39});
            Projdef.falseLon   = str2double(splitdat{27});
            Projdef.LatSP1     = str2double(splitdat{30});
            Projdef.LatSP2     = str2double(splitdat{33});
            Projdef.falseEast  = str2double(splitdat{21});
            Projdef.falseNorth = str2double(splitdat{24});
            type = 'lcc2sp';
        end
    case 'Hotine_Oblique_Mercator_Azimuth_Natural_Origin'
        Projdef.latOrigin     = str2double(splitdat{36});
        Projdef.lonOrigin     = str2double(splitdat{33});
        Projdef.falseNorthing = str2double(splitdat{24});
        Projdef.falseEasting  = str2double(splitdat{21});
        Projdef.scaleFactor   = str2double(splitdat{27});
        Projdef.skewaxis      = str2double(splitdat{30});
        Projdef.azline        = str2double(splitdat{30});
        type = 'om';
end