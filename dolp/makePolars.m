% fnames = dirname('C:\Users\Richie\Documents\PANTILT\20181007_POLARTEST\*.JPG');
% imnames= fnames(3:3:end);
%
% DNAME = 'C:\Users\Richie\Documents\PANTILT\20181007_MAGTEST';
% fnames = dirname([DNAME '/*.jpg']);
% startim = 234;
% imnames= fnames(startim:3:startim+3*5);

DNAME = 'C:\tmp\pt3\organized';
LVALS = 0:30:150;

for iP = 8:9
    for iT = 1:4
        imnames = cell(6,1);
        D = LVALS;
        I=[];
        imstr = [];
        for iL = 1:6
            imstrlook = sprintf('P%02.0f_T%02.0f_L%03.0f_N*.jpg',iP,iT,LVALS(iL));
            fnames = dirname(imstrlook,1,DNAME);
            if isempty(fnames)
                fnames{1} = 'C:\tmp\pt3\organized\foo.jpg';
                fprintf('foo\n');
            end
            Itemp = [];
            for i=1:numel(fnames)
                Itemp(:,:,:,i)=imread(fnames{i});
            end
            imnames{iL} = fnames{1};
            
            I{iL} = uint8(median(Itemp,4));
            
            try
                Iinfo = imfinfo(imnames{iL});
                fstop = Iinfo.DigitalCamera.FNumber;
                iso = Iinfo.DigitalCamera.ISOSpeedRatings;
                et = Iinfo.DigitalCamera.ExposureTime;
            catch
                fstop = 0;
                iso = 0;
                et = 0;
            end
            imstr{iL} = sprintf('%i , %.1f, %.1f, 1/%.0f',D(iL),fstop,iso,1/et);
        end
        
        if et==0
            Xrgb = I{1};
            imwrite(Xrgb,[DNAME '/' sprintf('POLARB_P%02.0f_T%02.0f.png',iP,iT)]);
            continue
        else
            %         for i=1:numel(imnames)
            %             I{i} = imread(imnames{i});
            %             %    I{i} = imgaussfilt(I{i},2);
            %             Iinfo = imfinfo(imnames{i});
            %             fstop = Iinfo.DigitalCamera.FNumber;
            %             iso = Iinfo.DigitalCamera.ISOSpeedRatings;
            %             et = Iinfo.DigitalCamera.ExposureTime;
            %             imstr{i} = sprintf('%i , %.1f, %.1f, 1/%.0f',D(i),fstop,iso,1/et);
            %         end
            
            %%
            clear R G B Y
            
            for i=1:numel(I)
                R(:,:,i) = I{i}(:,:,1);
                G(:,:,i) = I{i}(:,:,2);
                B(:,:,i) = I{i}(:,:,3);
                Y(:,:,i) = rgb2gray(I{i});
            end
            %%
            X = Y;
            
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
                imagesc(128+20*(uint8(X(:,:,i))-mX));
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
            
            imwrite(Xrgb,[DNAME '/' sprintf('POLARB_P%02.0f_T%02.0f.png',iP,iT)]);
        end
    end
end
