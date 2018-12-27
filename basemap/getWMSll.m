function [latvector,lonvector,Iortho] = getWMSll(lat,lon,z,varargin)
% GETWMSLL Short summary of this function goes here
%   Detailed explanation goes here
%
% Required Inputs: 
%	- lat           : [min_lat max_lat] latitude bounding limits
%	- lon           : [min_lon max_lon] longitude bounding limits
%	- z             : WMS Zoom level  
%               1 = 150,000   m 
%               7 =   1,222   m 
%              10 =     152.7 m 
%              13 =      76.4 m 
%              16 =       2.4 m 
%              19 =       0.3 m 
%
% Optional Inputs: (default)
%	- 'server'      : (0) *description* 
%	- 'serverext'   : (0) *description* 
%	- 'serverorder' : (0) *description* 
%	- 'dodebug'     : (0) *description* 
%	- 'imsize'      : (0) *description* 
%	- 'override'    : (0) *description* 
%   - 'servername'  : (0) *description*
%
% Outputs:
%	- 'latvector'   : (0) *description* 
%	- 'lonvector'   : (0) *description* 
%	- 'Iortho'      : (0) *description* 
% 
% Examples:
%   - [enter any example code here]
% 
% Dependencies:
%   - [unknown]
% 
% Toolboxes Required:
%   - [unknown]
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 26-Dec-2018
% Date Modified : 26-Dec-2018
% Github        : [enter github web address]

%% Function Call
[lat,lon,z,SERVER,SERVEREXT,SERVERORDER,DODEBUG,IMSIZE,OVERRIDE,SERVERNAME] = parseInputs(lat,lon,z,varargin{:});

servercall = [SERVER '/%i/%i/%i' SERVEREXT];

% Compute Tile Limits
n = 2 ^ z;
% flip max/min because image coordinates

ytiletop = floor(n * (1 - (log(tand(min(lat)) + secd(min(lat))) / pi)) / 2);
ytilebottom = floor(n * (1 - (log(tand(max(lat)) + secd(max(lat))) / pi)) / 2);
nytile = abs(ytilebottom-ytiletop)+1;

xtilemin = floor(n * ((min(lon) + 180) / 360));
xtilemax = floor(n * ((max(lon) + 180) / 360));
nxtile = xtilemax-xtilemin+1;

% Preallocate Tile Image
Iortho = zeros(nytile*IMSIZE,nxtile*IMSIZE,3,'uint8');

% Get Big limits
lonmin = xtilemin / n * 360.0 - 180.0;
lonplus1 = (xtilemin+1) / n * 360.0 - 180.0;
dlon = lonplus1-lonmin;

latmin = atan(sinh(pi * (1 - 2 * ytilebottom / n))) * 180 / pi;
latplus1 = atan(sinh(pi * (1 - 2 * (ytilebottom+1) / n))) * 180 / pi;
dlat = latplus1-latmin;

latvector = latmin + ((1:IMSIZE*nytile)-1) * dlat/256;
lonvector = lonmin + ((1:IMSIZE*nxtile)-1) * dlon/256;

if (nxtile*nytile)>100 && ~OVERRIDE
   error('easy there partner, thats a lot of data'); 
end
%
icount = 0;
ntotal = numel(xtilemin:xtilemax)*numel(ytilebottom:ytiletop);
starttime = now;
for ix = xtilemin:xtilemax
    for iy = ytilebottom:ytiletop
        icount=icount+1;
        xind = (1:IMSIZE)+(ix-xtilemin)*IMSIZE;
        yind = (1:IMSIZE)+(iy-ytilebottom)*IMSIZE;
        if strcmp(SERVERORDER,'ZYX')
            Iortho(yind,xind,:) = imread(sprintf(servercall,z,iy,ix));
        elseif strcmp(SERVERORDER,'ZXY')
            Iortho(yind,xind,:) = imread(sprintf(servercall,z,ix,iy));
        else
            error('SERVER ORDER NOT DEFINED YET');
        end
        if DODEBUG==1
            figure(101);clf
            imagesc(lonvector,latvector,Iortho);set(gca,'ydir','normal')
            axis equal
            xlabel('Longitude');
            ylabel('Latitude');
            hold on
            plot([lon(1) lon(1) lon(2) lon(2) lon(1)],...
                 [lat(1) lat(2) lat(2) lat(1) lat(1)],'r-');
             drawnow
        elseif DODEBUG==2
            loopStatus(starttime,icount,ntotal,1);
        end
    end
end

if DODEBUG
    IorthoTemp=Iortho;
    for iix = 1:nytile
            IorthoTemp(256*iix,:,1)=255;
            IorthoTemp(256*iix,:,2)=255;
            IorthoTemp(256*iix,:,3)=255;
    end
    for iiy = 1:nxtile
            IorthoTemp(:,256*iiy,1)=255;
            IorthoTemp(:,256*iiy,2)=255;
            IorthoTemp(:,256*iiy,3)=255;
    end
    
    figure(101);clf
    imagesc(lonvector,latvector,IorthoTemp);set(gca,'ydir','normal')
            axis equal
            xlabel('Longitude');
            ylabel('Latitude');
            hold on
            plot([lon(1) lon(1) lon(2) lon(2) lon(1)],...
                 [lat(1) lat(2) lat(2) lat(1) lat(1)],'b-');
             drawnow
end

end

function [lat,lon,z,server,serverext,serverorder,dodebug,imsize,override,servername] = parseInputs(lat,lon,z,varargin)
%%	 Call this function to parse the inputs

% Default Values
default_server       = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile';
default_serverext    = '.png';
default_serverorder  = 'ZYX';
default_dodebug      = false;
default_imsize       = 256;
default_override     = false;
default_servername   = 'esriworld';

% Check Values
check_lat          = @(x) true;
check_lon          = @(x) true;
check_z            = @(x) true;
check_server       = @(x) true;
check_serverext    = @(x) true;
check_serverorder  = @(x) true;
check_dodebug      = @(x) true;
check_imsize       = @(x) true;
check_override     = @(x) true;
check_servername   = @(x) true;

% Parser Values
p = inputParser;
% Required Arguments:
addRequired(p, 'lat' , check_lat );
addRequired(p, 'lon' , check_lon );
addRequired(p, 'z'   , check_z   );
% Parameter Arguments
addParameter(p, 'server'      , default_server     , check_server      );
addParameter(p, 'serverext'   , default_serverext  , check_serverext   );
addParameter(p, 'serverorder' , default_serverorder, check_serverorder );
addParameter(p, 'dodebug'     , default_dodebug    , check_dodebug     );
addParameter(p, 'imsize'      , default_imsize     , check_imsize      );
addParameter(p, 'override'    , default_override   , check_override    );
addParameter(p, 'servername'  , default_servername , check_servername  );

% Parse
parse(p,lat,lon,z,varargin{:});
% Convert to variables
lat         = p.Results.('lat');
lon         = p.Results.('lon');
z           = p.Results.('z');
server      = p.Results.('server');
serverext   = p.Results.('serverext');
serverorder = p.Results.('serverorder');
dodebug     = p.Results.('dodebug');
imsize      = p.Results.('imsize');
override    = p.Results.('override');
servername  = p.Results.('servername');

if strcmp(servername,'esriworld')
    server      = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile';
    serverext   = '.png';
    serverorder = 'ZYX';
    imsize      = 256;
% elseif strcmp(servername,'openstreetmap')
%     server      = 'https://a.tile.openstreetmap.org';
%     serverext   = '.png';
%     serverorder = 'ZXY';
%     imsize      = 256;
elseif strcmp(servername,'terra')
    server      = 'https://s3.amazonaws.com/elevation-tiles-prod/terrarium';
    serverext   = '.png';
    serverorder = 'ZXY';
    imsize      = 256;
end

end