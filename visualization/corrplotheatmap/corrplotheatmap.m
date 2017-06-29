function [hax,hplots] = corrplotheatmap(X,varargin)
% CORRPLOTHEATMAP generates a pairwise heatmap for each column in X
%   corrplotheatmap is like corrplot, but makes a heatmap instead of a
%   scatterplot on the off diagonal elements.  You can also specify a
%   different polynomial fit for each axes.  
% 
% Inputs:
%   - X        : [nobservations,nvariables] Matrix of data 
% Optional Inputs:
%   - 'strlabel'   : Cell vector of labels for each variable
%   - 'lims'       : [nvar,2] [min max] array of limits for each variable
%   - 'nsteps'     : Number of steps in each heatmap and histogram
%   - 'npoly'      : Polynomial fit for each correlation
%   - 'fontsize'   : Fontsize for the title and labels
%   - 'r2fontsize' : Fontsize for the r2 correlation
%   - 'pos'        : [dr,dc,x1,y1,x2,y2] position of axes
%   - 'cmap'       : colormap to use
%
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

npts = size(X,1);
nvars = size(X,2);

%default values
defaultStrLabels = cell(nvars,1);
for i=1:nvars
   defaultStrLabels{i} = sprintf('var%i',i); 
end
defaultLims = [min(X);max(X);]';
defaultNsteps = 100 * ones(1,nvars);
defaultNpoly = ones(nvars);
defaultFontsize = 18;
defaultr2fontsize = 12;
defaultpos = [0.025,0.025,0.1,0.9,0.1,0.85];
dcmap = flipud(hot(350));
defaultcmap = dcmap(1:256,:);

% check functions
checkX = @(x) size(X,2)>1;
checkStrLabels = @(x) iscell(x);
checkLims = @(x) size(x,2)==2 && size(x,1)==nvars && isnumeric(x);
checkNsteps = @(x) isvector(x) && numel(x)==nvars && all(mod(x,1)==0) && x>0;
checkNpoly = @(x) size(x,1)==nvars && size(x,2)==nvars;
checkFontsize = @(x) isnumeric(x) && x>0 && isscalar(x) && mod(x,1)==0;
checkR2fontsize = @(x) isnumeric(x) && x>0 && isscalar(x) && mod(x,1)==0;
checkpos = @(x) isvector(x) && numel(x)==6;
checkcmap = @(x) size(x,2)==3 && isnumeric(x);

% parse inputs
p = inputParser;
addRequired(p, 'X'         ,checkX);
addParameter(p,'strlabel'   ,defaultStrLabels  ,checkStrLabels);
addParameter(p,'lims'      ,defaultLims       ,checkLims);
addParameter(p,'nsteps'    ,defaultNsteps     ,checkNsteps);
addParameter(p,'npoly'     ,defaultNpoly      ,checkNpoly);
addParameter(p,'fontsize'  ,defaultFontsize   ,checkFontsize);
addParameter(p,'r2fontsize',defaultr2fontsize ,checkR2fontsize);
addParameter(p,'pos'       ,defaultpos        ,checkpos);
addParameter(p,'cmap'      ,defaultcmap       ,checkcmap);

parse(p,X,varargin{:});

% get variables out of structure
strlabel   = p.Results.strlabel;
lims       = p.Results.lims;
nsteps     = p.Results.nsteps;
npoly      = p.Results.npoly;
fontsize   = p.Results.fontsize;
r2fontsize = p.Results.r2fontsize;
pos        = p.Results.pos;
cmap       = p.Results.cmap;

% make lims
xg = cell(nvars,1);
for i=1:nvars
   xg{i} = linspace(lims(i,1),lims(i,2),nsteps(i));
end

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
        hplots(i,j) = heatmapscat(x,y,xg{j},xg{i});
        colormap(cmap);
        % get caxis limits
        clim = caxis;
        cmin(i,j) = clim(1);
        cmax(i,j) = clim(2);
        % do regression
        if ~isnan(npoly(i,j))
            hold on
            [p,s] = polyfit(x,y,npoly(i,j));
            yg = polyval(p,xg{j});
            plot(xg{j},yg,'k-');
            xlim([xg{j}(1) xg{j}(end)]);
            ylim([xg{i}(1) xg{i}(end)]);
            r2 = 1 - s.normr^2 / norm(y-mean(y))^2;
            t = text(0.05,0.95,sprintf('%.2f',r2),'units','normalized',...
                'color','k','VerticalAlignment','top','fontsize',r2fontsize);
        end
        
        %label plots on left and bottom
        if i==nvars
            xlabel(strlabel{j},'fontsize',fontsize,'interpreter','latex');
        else
            set(gca,'xtick','');
        end
        
        if j==1
            ylabel(strlabel{i},'fontsize',fontsize,'interpreter','latex');
        else
            set(gca,'ytick','');
        end
        
        % Put histogram on diagonal
        if i==j %histogram on diagonal
            dx = mean(diff(xg{i}));
            xihist = [xg{i}-dx/2 xg{i}(end)+dx/2];
            %histogram needs the edges of the bins
            haxhist(i) = axg(i,j,true);
            hhist(i) = histogram(X(:,i),xihist,...
                'FaceColor',[0.3 0.3 0.3],'EdgeColor',[0.3 0.3 0.3]);
            set(haxhist(i),'xtick','','ytick','');
            xlim([xg{i}(1) xg{i}(end)])
            %diagonal climits dont matter, so throw em off
            cmin(i,j) = inf;
            cmax(i,j) = -inf;
        end
    end
end
drawnow;
% link axes
for i=1:4
    key = 'graphics_linkaxes1';
    linkax(hax(i,:),'YLim',key);
end
for j=1:4
    key = 'graphics_linkaxes2';
    linkax([hax(:,j); haxhist(j)],'XLim',key);
end
% add title
bigtitleax('Correlation Matrix',hax([1 4],[4 1]),0.01,...
    'fontsize',fontsize,'interpreter','latex');
cax = bigcolorbarax(hax(:),0.025,0.05,'Frequency of Observations',...
    'fontsize',fontsize','interpreter','latex');
caxis([median(cmin(:)) median(cmax(:))]);
set(hax(:),'CLim',[median(cmin(:)) median(cmax(:))])
end