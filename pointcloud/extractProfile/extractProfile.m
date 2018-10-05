function [profileinds, downlineoffline]= extractProfile(xyStart,xyDirection,offlinethresh,downlinethresh,xy)
%% Extract proile from xyz data using a 2d line
DODEBUG = false;
%% Input Checks
% if xyDirection is scalar, it is an angle
if numel(xyDirection)==1
    xyEnd = xyStart + [sind(xyDirection) cosd(xyDirection)];
else 
    xyEnd = xyDirection;
end

% if offlinethresh is scalar, make it a min/max
if numel(offlinethresh)==1
    offlinethresh = [-offlinethresh offlinethresh];
end

% downlinethresh
if numel(xyDirection)==1 && numel(downlinethresh)==1
    % xyDirection is angle and thresh is scalar
    % [0 thresh]
    downlinethresh = [0 downlinethresh];
elseif numel(xyDirection)==2 && numel(downlinethresh)==1
    % xyDirection is point and thresh is scalar
    % [-thresh magnitude(P1-P2)+thresh]
    D = sqrt(sum((xyEnd-xyStart).^2));
    downlinethresh = [-downlinethresh D+downlinethresh];
elseif numel(xyDirection)==2 && numel(downlinethresh)==2
    % xyDirection is point and thresh is vector
    % [-thresh magnitude(P1-P2)+thresh]
    D = sqrt(sum((xyEnd-xyStart).^2));
    downlinethresh = [downlinethresh(1) D+downlinethresh(2)];
end

%% Convert points to [downline,offline] coordinate system
% Rotate Based on angle between xy1 and xy2
% make xystart (0,0) in coordinate sytem
Az = pi/2-atan2(xyEnd(2)-xyStart(2),xyEnd(1)-xyStart(1));

R = [cos(Az) -sin(Az);sin(Az) cos(Az)];

xyStartRotated = R * xyStart(:);

downlineoffline = (R * [xy(:,1)';xy(:,2)']) - xyStartRotated(:);

%% Filter using offline and downline threshholds
profileinds = downlineoffline(1,:) > offlinethresh(1)  & ...
              downlineoffline(1,:) < offlinethresh(2)  & ...
              downlineoffline(2,:) > downlinethresh(1) & ...
              downlineoffline(2,:) < downlinethresh(2);

downlineoffline = downlineoffline(:,profileinds)';
          
%% DEBUG
if DODEBUG
    xyEndRotated = R * xyEnd(:) - xyStartRotated;
    
    figure(100);clf
    subplot(1,2,1)
    plot(xy(~profileinds,1),xy(~profileinds,2),'r.');
    hold on
    plot(xy(profileinds,1),xy(profileinds,2),'b.');
    plot([xyStart(1) xyEnd(1)],[xyStart(2) xyEnd(2)],'k.-','markersize',50,'linewidth',2);
    axis equal
    grid on
    
    subplot(1,2,2)
    plot(downlineoffline(1,~profileinds),downlineoffline(2,~profileinds),'r.');
    hold on
    plot(downlineoffline(1,profileinds),downlineoffline(2,profileinds),'b.');
    
    
    plot([0 xyEndRotated(1)],[0 xyEndRotated(2)],'k.-','markersize',50,'linewidth',2);
    axis equal
    grid on
    
    downlinethresh
    D = sqrt(sum((xyEnd-xyStart).^2))
end
end