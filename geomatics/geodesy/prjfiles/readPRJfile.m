function [Projdef,Ellipdef,type] = readPRJfile(fname)
% READPRJFILE reads a PRJ file and returns projection/ellipsoid parameters
%   Returns the projection/ellipsoid parameters for LCC, TM, OM projections
% 
% Inputs:
%   - fname : PRJ filename
% 
% Outputs:
%   - Projdef  : Projection structure 
%   - Ellipdef : Ellipsoid structure
%   - type     : string for type of projection
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
% Date Created  : 15-Mar-2019
% Date Modified : 27-Mar-2019
% Github        : https://github.com/hokiespurs/general-purpose-matlab/tree/master/geomatics/geodesy

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
        % LCC 1SP is defined with 2SP that are equal in the PRJ file
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