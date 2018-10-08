fnames = dirname('C:\Users\Richie\Documents\PANTILT\20181007_POLARTEST\*.JPG');
imnames= fnames(3:3:end);

DNAME = 'C:\Users\Richie\Documents\PANTILT\20181007_MAGTEST';
fnames = dirname([DNAME '/*.jpg']);
startim = 234;
imnames= fnames(startim:3:startim+3*5);

D = 0:30:150;
I=[];
for i=1:numel(imnames)
   I{i} = imread(imnames{i});
%    I{i} = imgaussfilt(I{i},2);
   Iinfo = imfinfo(imnames{i});
   fstop = Iinfo.DigitalCamera.FNumber;
   iso = Iinfo.DigitalCamera.ISOSpeedRatings;
   et = Iinfo.DigitalCamera.ExposureTime;
   imstr{i} = sprintf('%i , %.0d, %.0d, 1/%.0d',D(i),fstop,iso,1/et);
end

%%
clear R G B Y

for i=1:numel(I)
    R(:,:,i) = I{i}(:,:,1);
    G(:,:,i) = I{i}(:,:,2);
    B(:,:,i) = I{i}(:,:,3);
    Y(:,:,i) = rgb2gray(I{i});
end
%%
X = G;

CAX = [1 1.5];

figure(1);clf
for i=1:6
    h(i)=subplot(2,3,i);
    image(I{i});
    axis equal
    title(imstr{i});
end
linkaxes(h);
%
S = double(max(X,[],3))./double(min(X,[],3));
S(isnan(S))=1;
dolp = calcdolp(X,D);

%
figure(2);clf
mX = uint8(mean(X,3));
for i=1:6
    h(i) = subplot(2,3,i);
    imagesc(128+20*(X(:,:,i)-mX));
    axis equal
    caxis([0 255])
    title(imstr{i});
end
linkaxes(h);
%
figure(3);clf
h1=subplot(1,2,1);
Sind = num2ind(S,[1 2],256);
Srgb = ind2rgb(Sind,parula(256));
image(Srgb);
caxis(CAX);
colorbar
colormap(h1,parula);
axis equal

h2=subplot(1,2,2);
dolpind = num2ind(dolp,[0 180],256);
dolprgb = ind2rgb(dolpind,hsv(256));
image(dolprgb);shading flat
set(h2,'ydir','reverse');
caxis([0 180]);
colorbar
colormap(h2,hsv);
axis equal

linkaxes([h1 h2])

%
figure(4);clf
axg = axgrid(1,5,0.05,0.05);
axg(1:4);
[Xrgb, legendrgb] = bivariatergb(dolp,S,[0 180],CAX,flipud(hsv(256)));image(Xrgb);
axis equal
axg(5);
image(CAX,[0 180],legendrgb)
set(gca,'ydir','normal');
%% 
figure(5);clf
axg = axgrid(2,1,0.01,0.1,0.025,0.975,0.025,0.7);
h1 = axg(1);
imagesc((I{1}*1));
axis equal

h2 = axg(2);
image(Xrgb);
axis equal

linkaxes([h1 h2]);
colorbarangle([0.75 0.4 0.2 0.2],'cmap',[hsv(128);hsv(128)])
%%
%%
%image(I{1})
%
%
% X = G;
% S = 20;
% mX = median(X,3);
% dX = 128+S*(double(repmat(mX,1,1,6))-double(X));
% Itest = uint8(dX(:,:,[2 4 6]));
% 
% figure(1);clf
% h1=subplot(1,2,1);
% image(I{1});
% 
% h2=subplot(1,2,2);
% image(Itest);
% 
% linkaxes([h1 h2])
% % %%
% X = R;
% u = 3700;
% v = 3400;
% 
% figure(1);clf
% subplot(1,2,1)
% image(I{1});
% 
% subplot(1,2,2)
% x = X(v,u,:);
% plot([D D+180],[x(:);x(:)],'.-');
% hold on
% ax = axis;
% plot([dolp(v,u) dolp(v,u)],[0 255]);
% xlim([0 180])
% axis(ax)