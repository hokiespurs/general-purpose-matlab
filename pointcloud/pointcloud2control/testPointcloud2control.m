%% 
CONTROLNAME = 'P:\Slocum\02_PROJECTS\PointCloudAccuracyAssesmentTool\Control\Control_RapidEph.csv';
POINTCLOUDDIR = 'P:\Slocum\02_PROJECTS\PointCloudAccuracyAssesmentTool\PointClouds\';
% POINTCLOUDNAME = 'P:\Slocum\02_PROJECTS\PointCloudAccuracyAssesmentTool\PointClouds\PSK_DirectGeo_GloGPS_5cntrl_05cm_grid_median.las';

NORMALRADIUS = 0.25;
EVALRADIUS = 0.25;
MAXDIST = 2;
MAKENORMALZ = false;
HISTZ = -0.25:0.01:0.25;

CMAP = [ 60  99 137;
        134 198  99;
        242 228 128;
        219 115  63;
        176 182 183]./255;
    
%% Get Pointcloud LAS Names
allpointcloudnames = dirname(POINTCLOUDDIR);

%% Read Control
controlcsv = importdata(CONTROLNAME);
controlData = cellfun(@(x) strsplit(x,','),controlcsv(2:end),'UniformOutput',false);

controlX=nan(numel(controlData),1);
controlY=nan(numel(controlData),1);
controlZ=nan(numel(controlData),1);
controlName=[];
controlClass=[];
for i=1:numel(controlData)
   controlX(i) = str2double(controlData{i}{2});
   controlY(i) = str2double(controlData{i}{3});
   controlZ(i) = str2double(controlData{i}{4});
   controlName{i} = controlData{i}{1};
   controlClass{i} = controlData{i}{8};
end

xyzControl = [controlX controlY controlZ];
%% For each pointcloud
for i=1:numel(allpointcloudnames)
    POINTCLOUDNAME = allpointcloudnames{i};
    [~,justname,ext]=fileparts(POINTCLOUDNAME);

    %% Read PC
    fprintf('Reading Pointcloud: %s ... %s\n',justname, datestr(now));
    pointcloudlas = lasdata(POINTCLOUDNAME);
    
    pointcloudX = pointcloudlas.x;
    pointcloudY = pointcloudlas.y;
    pointcloudZ = pointcloudlas.z;
    
    xyzPointcloud = [pointcloudlas.x pointcloudlas.y pointcloudlas.z];
    
    %% Calc Stats
    stats{i} = pointcloud2control(xyzPointcloud, xyzControl, NORMALRADIUS, ...
        'evalRadius',EVALRADIUS,'maxDist',MAXDIST,'makeNormalZ',MAKENORMALZ,...
        'histVals',HISTZ);
end

%% Compare things
STRNAMES = unique(controlClass);

for i=1:numel(STRNAMES)
    strname = STRNAMES{i};
    ind = strcmp(controlClass,strname);
    istats = stats(ind);
    
end

%% %% Debug
% DEBUGLIM = 2;
% INDEVAL = 1;
% 
% for INDEVAL = 1:194
%     try
%     xyzControlPoint = xyzControl(INDEVAL,:);
%     limXYZ = [xyzControlPoint - DEBUGLIM; xyzControlPoint + DEBUGLIM];
%     
%     indCube = xyzPointcloud(:,1) >= limXYZ(1,1) & xyzPointcloud(:,1) <= limXYZ(2,1) & ...
%         xyzPointcloud(:,2) >= limXYZ(1,2) & xyzPointcloud(:,2) <= limXYZ(2,2) & ...
%         xyzPointcloud(:,3) >= limXYZ(1,3) & xyzPointcloud(:,3) <= limXYZ(2,3);
%     indgood = false(size(indCube));
%     indgood(stats(INDEVAL).indvals)=true;
%     
%     PCout = xyzPointcloud(indCube & ~indgood,:);
%     PCin = xyzPointcloud(indCube & indgood,:);
%     
%     figure(1);clf
%     
%     subplot(2,2,1);
%     plot3(PCout(:,1),PCout(:,2),PCout(:,3),'b.','markersize',5)
%     hold on
%     plot3(PCin(:,1),PCin(:,2),PCin(:,3),'r.','markersize',10)
%     plot3(stats(INDEVAL).controlPt(1),stats(INDEVAL).controlPt(2),stats(INDEVAL).controlPt(3),'g.','markersize',20)
%     axis equal
%     view(90,0);
%     
%     subplot(2,2,2);
%     plot3(PCout(:,1),PCout(:,2),PCout(:,3),'b.','markersize',5)
%     hold on
%     plot3(PCin(:,1),PCin(:,2),PCin(:,3),'r.','markersize',10)
%     plot3(stats(INDEVAL).controlPt(1),stats(INDEVAL).controlPt(2),stats(INDEVAL).controlPt(3),'g.','markersize',20)
%     axis equal
%     view(0,0);
%     
%     subplot(2,2,3);
%     plot3(PCout(:,1),PCout(:,2),PCout(:,3),'b.','markersize',5)
%     hold on
%     plot3(PCin(:,1),PCin(:,2),PCin(:,3),'r.','markersize',10)
%     plot3(stats(INDEVAL).controlPt(1),stats(INDEVAL).controlPt(2),stats(INDEVAL).controlPt(3),'g.','markersize',20)
%     axis equal
%     view(90,90);
%     title(fixfigstring({controlName{INDEVAL},controlClass{INDEVAL}}))
% 
%     subplot(2,2,4);
%     bar(stats(INDEVAL).hist.centerbars,stats(INDEVAL).hist.val)
%     title(sprintf('%.2f cm',stats(INDEVAL).mean*100),'fontsize',30);
%     pause(1)
%     catch
%        fprintf('%s\n',controlName{INDEVAL});
%     end
% end
% %%
% clc
% STRNAMES = unique(controlClass);
% [~,justname,ext]=fileparts(POINTCLOUDNAME);
% fprintf('%s\n',[justname ext]);
% fprintf('-----------------------\n');
% fprintf('NORMAL RADIUS   = %.2fm\n',NORMALRADIUS);
% fprintf('CYLINDER RADIUS = %.2fm\n',EVALRADIUS);
% fprintf('-----------------------\n');
% fprintf('%30s | %17s | %17s | %17s | %17s | %17s | %17s | %11s\n','Name','Mean','Median','Min','Max','Std','Npts','Ncontrol');
% for i=1:numel(STRNAMES)
%     strname = STRNAMES{i};
%     indAsphalt = strcmp(controlClass,strname);
%     fprintf('%30s | ',strname);
%     istats = stats(indAsphalt);
%     fprintf('%7.2f ± %7.2f | ',100*nanmean([istats.mean]),100*nanstd([istats.mean]));
%     fprintf('%7.2f ± %7.2f | ',100*nanmean([istats.median]),100*nanstd([istats.median]));
%     fprintf('%7.2f ± %7.2f | ',100*nanmean([istats.min]),100*nanstd([istats.min]));
%     fprintf('%7.2f ± %7.2f | ',100*nanmean([istats.max]),100*nanstd([istats.max]));
%     fprintf('%7.2f ± %7.2f | ',100*nanmean([istats.std]),100*nanstd([istats.std]));
%     fprintf('%7.2f ± %7.2f | ',nanmean([istats.npts]),nanstd([istats.npts]));
%     fprintf('%10.0f \n',sum(~isnan([istats.npts])));
% end