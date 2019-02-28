function [hax,hplots] = corrplotheatmap(X,varargin)
% CORRPLOTHEATMAP generates a pairwise heatmap for each column in X
%   corrplotheatmap is like corrplot, but makes a heatmap instead of a
%   scatterplot on the off diagonal elements.  You can also specify a
%   different polynomial fit for each axes.  
% 
% Inputs:
%   - X        : [nobservations,nvariables] Matrix of data 
%
% Optional Inputs:
%   - 'strlabel'      : Cell vector of labels for each variable
%   - 'lims'          : [nvar,2] [min max] array of limits for each variable
%   - 'nsteps'        : Number of steps in each heatmap and histogram
%   - 'npoly'         : Polynomial fit for each correlation
%   - 'fontsize'      : Fontsize for the title and labels
%   - 'r2fontsize'    : Fontsize for the r2 correlation
%   - 'pos'           : [dr,dc,x1,y1,x2,y2] position of axes
%   - 'cmap'          : colormap to use
%	- 'ticks'         : x and y axis tick marks
%	- 'clim'          : colorbar limits
%	- 'dogrid'        : boolean grid on/off 
%	- 'tickfontsize'  : tick number font size
%	- 'labelfontsize' : x and y label font size
%   - 'plotlog'       : boolean plog log heatmap 

% Outputs:
%   - hax    : handle for each of the axes
%   - hplots : handle for each of the plots
% 
% Examples:
%   - Example code goes here
% 
% Dependencies:
%   - roundgridfun.m
%   - iswithin.m
%   - axgrid.m
%   - bigcolorbar.m
%   - bigcolorbarax.m
%   - bigtitle.m
%   - bigtitleax.m
%   - maxpos.m
%   - heatmapscat.m
% 
% Toolboxes Required:
%   - n/a
% 
% Author        : Richie Slocum
% Email         : richie@cormorantanalytics.com
% Date Created  : 21-Jun-2017
% Date Modified : 21-Jun-2017  
% Github        : https://github.com/hokiespurs/general-purpose-matlab

%
% VARS = {'X','strlabel','lims','nsteps','npoly',...
%     'r2fontsize','pos','cmap','mapsize','ticks','clim','grid',...
%     'tickfontsize','labelfontsize'};
% OPTIONAL = [1 ones(1,14)*3];
% DEFAULTVALS = cell(1,14);
% inputParserTemplate(VARS,OPTIONAL,DEFAULTVALS)

%% Function Call
[X,strlabel,lims,nsteps,npoly,r2fontsize,pos,cmap,ticks,clim,dogrid,tickfontsize,labelfontsize,plotlog] = parseInputs(X,varargin{:});

%%
npts = size(X,1);
nvars = size(X,2);
% make lims
xg = cell(nvars,1);
for i=1:nvars
   xg{i} = linspace(lims(i,1),lims(i,2),nsteps(i));
end

% remove nans
badinds = any(isnan(X),2);
X(badinds,:)=[];

% make axes 
axg = axgrid(nvars,nvars,pos(1),pos(2),pos(3),pos(4),pos(5),pos(6));
hax = nan(nvars);
hplots = nan(nvars);
haxhist = nan(nvars^2,1);
hhist = nan(nvars^2,1);
cmin = nan(nvars);
cmax = nan(nvars);
for i=1:nvars
    for j=1:nvars
        hax(i,j) = axg(i,j);
        x = X(:,j);
        y = X(:,i);
        % make heatmapscat
        if plotlog
            hplots(i,j) = heatmapscat(x,y,xg{j},xg{i},false,true,true);
        else
            hplots(i,j) = heatmapscat(x,y,xg{j},xg{i},false,true,false);
        end
        set(gca,'fontsize',tickfontsize,'TickLabelInterpreter','latex');
        colormap(cmap);
        % get caxis limits
        ijclim = caxis;
        cmin(i,j) = ijclim(1);
        cmax(i,j) = ijclim(2);
        % do regression
        if ~isnan(npoly(i,j))
            hold on
            [p,s] = polyfit(x,y,npoly(i,j));
            yg = polyval(p,xg{j});
            plot(xg{j},yg,'k-');
            xlim([xg{j}(1) xg{j}(end)]);
            ylim([xg{i}(1) xg{i}(end)]);
            r2 = 1 - s.normr^2 / norm(y-mean(y))^2;
            t = text(0.05,0.95,sprintf('$R^2 = %.2f$',r2),'units','normalized',...
                'color','k','VerticalAlignment','top','fontsize',r2fontsize,'interpreter','latex');
        end
        if dogrid
           grid on; 
        end
        %label plots on left and bottom
        if i==nvars
            xlabel(strlabel{j},'fontsize',labelfontsize,'interpreter','latex');
        else
            set(gca,'XTickLabel',repmat(' ',numel(xticks),1))
        end
        
        if j==1
            ylabel(strlabel{i},'fontsize',labelfontsize,'interpreter','latex');
        else
            set(gca,'YTickLabel',repmat(' ',numel(yticks),1))
        end
        if ~isempty(ticks)
            xticks(ticks{j});
            yticks(ticks{i});
        end
        ylim([xg{i}(1) xg{i}(end)]);
        xlim([xg{j}(1) xg{j}(end)]);
        % Put histogram on diagonal
        if i==j %histogram on diagonal
            dx = mean(diff(xg{i}));
            xihist = [xg{i}-dx/2 xg{i}(end)+dx/2];
            %histogram needs the edges of the bins
            haxhist(i) = axg(i,j,true);
            hhist(i) = histogram(X(:,i),xihist,...
                'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3]);
            set(haxhist(i),'XTickLabel',repmat(' ',numel(xticks),1))
            set(haxhist(i),'ytick','');
            xlim([xg{i}(1) xg{i}(end)])
            %diagonal climits dont matter, so throw em off
            cmin(i,j) = inf;
            cmax(i,j) = -inf;
            if dogrid
                grid on;
            end
        end
        drawnow
    end
end
drawnow;
% link axes
for i=1:nvars
    key = 'graphics_linkaxes1';
    linkax(hax(i,:),'YLim',key);
end
for j=1:nvars
    key = 'graphics_linkaxes2';
    linkax([hax(:,j); haxhist(j)],'XLim',key);
end
% add title
hcolorbar = bigcolorbarax(hax(:),0.025,0.025,'Frequency of Observations',...
    'fontsize',labelfontsize','interpreter','latex');
set(hcolorbar,'fontsize',tickfontsize);
hcolorbar.TickLabelInterpreter = 'latex';
ylabel(hcolorbar,'Frequency of Observations','fontsize',labelfontsize,'interpreter','latex');
hcolorbar.Ticks = [];

if isempty(clim)
    CAX = [median(cmin(:)) median(cmax(:))];
else
    CAX = clim;
end

caxis(CAX);

if plotlog
    cbartix = hcolorbar.Ticks;
    for i=1:numel(cbartix)
       cbarlabel{i} = sprintf('%.0f',10.^cbartix(i));
    end
    hcolorbar.TickLabels = cbarlabel;
    
end
set(hax(:),'CLim',CAX);
end


function [X,strlabel,lims,nsteps,npoly,r2fontsize,pos,cmap,ticks,clim,dogrid,tickfontsize,labelfontsize,plotlog] = parseInputs(X,varargin)
%%	 Call this function to parse the inputs
npts = size(X,1);
nvars = size(X,2);

%default values
default_strlabel = cell(nvars,1);
for i=1:nvars
   default_strlabel{i} = sprintf('var%i',i); 
end

default_lims           = [min(X);max(X);]';
default_nsteps         = 100 * ones(1,nvars);
default_npoly          = ones(nvars);
default_r2fontsize     = 12;
default_pos             = [0.025,0.025,0.1,0.9,0.1,0.85];

dcmap = flipud(hot(350));
default_cmap           = dcmap(1:256,:);

default_ticks          = [];
default_clim           = [];
default_dogrid         = true;
default_tickfontsize   = 14;
default_labelfontsize  = 18;
default_plotlog        = false;

% Check Values
check_X              = @(x) size(X,2)>1;
check_strlabel       = @(x) iscell(x);
check_lims           = @(x) size(x,2)==2 && size(x,1)==nvars && isnumeric(x);
check_nsteps         = @(x) isvector(x) && numel(x)==nvars && all(mod(x,1)==0) && x>0;
check_npoly          = @(x) size(x,1)==nvars && size(x,2)==nvars;
check_r2fontsize     = @(x) isnumeric(x) && x>0 && isscalar(x) && mod(x,1)==0;
check_pos            = @(x) isvector(x) && numel(x)==6;
check_cmap           = @(x) size(x,2)==3 && isnumeric(x);
check_ticks          = @(x) iscell(x);
check_clim           = @(x) numel(x)==2;
check_dogrid         = @(x) islogical(x);
check_tickfontsize   = @(x) isnumeric(x) && x>0 && isscalar(x) && mod(x,1)==0;
check_labelfontsize  = @(x) isnumeric(x) && x>0 && isscalar(x) && mod(x,1)==0;
check_plotlog        = @(x) islogical(x);

% Parser Values
p = inputParser;
% Required Arguments:
addRequired(p, 'X' , check_X );
% Parameter Arguments
addParameter(p, 'strlabel'      , default_strlabel     , check_strlabel      );
addParameter(p, 'lims'          , default_lims         , check_lims          );
addParameter(p, 'nsteps'        , default_nsteps       , check_nsteps        );
addParameter(p, 'npoly'         , default_npoly        , check_npoly         );
addParameter(p, 'r2fontsize'    , default_r2fontsize   , check_r2fontsize    );
addParameter(p, 'pos'           , default_pos          , check_pos           );
addParameter(p, 'cmap'          , default_cmap         , check_cmap          );
addParameter(p, 'ticks'         , default_ticks        , check_ticks         );
addParameter(p, 'clim'          , default_clim         , check_clim          );
addParameter(p, 'dogrid'        , default_dogrid       , check_dogrid        );
addParameter(p, 'tickfontsize'  , default_tickfontsize , check_tickfontsize  );
addParameter(p, 'labelfontsize' , default_labelfontsize, check_labelfontsize );
addParameter(p, 'plotlog'       , default_plotlog      , check_plotlog );

% Parse
parse(p,X,varargin{:});
% Convert to variables
X             = p.Results.('X');
strlabel      = p.Results.('strlabel');
lims          = p.Results.('lims');
nsteps        = p.Results.('nsteps');
npoly         = p.Results.('npoly');
r2fontsize    = p.Results.('r2fontsize');
pos           = p.Results.('pos');
cmap          = p.Results.('cmap');
ticks         = p.Results.('ticks');
clim          = p.Results.('clim');
dogrid        = p.Results.('dogrid');
tickfontsize  = p.Results.('tickfontsize');
labelfontsize = p.Results.('labelfontsize');
plotlog       = p.Results.('plotlog');

end