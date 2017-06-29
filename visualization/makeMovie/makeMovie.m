function makeMovie(filenames,savename,Hz,duplicate)
% MAKEMOVIE Converts a series of image files into a gif or avi
%   This function is used to help with turning a sequence of images into a
%   movie or an animated gif.  If it is called with no inputs, it will
%   prompt you with steps for how to select images and generate the output
%   video.  
% 
%   * Sometimes the aviwriter and gif writer do weird things, which is
%   sometimes overcome by changing the Hz... not sure why
%
% 
% Inputs:
%   - filenames : Cell array of image paths and name
%   - savename  : filename of output movie ('avi' or 'gif')
%   - Hz        : Hz of output video
%   - duplicate : Slows video down by repeating frames
% 
% Outputs:
%   - n/a 
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
% Date Created  : 15-Mov-2014    
% Date Modified : 11-Jun-2017      
% Github        : https://github.com/hokiespurs/general-purpose-matlab

if nargin==0
   [fnames,foldername]= uigetfile('*.png;*.jpg;*.tif;*.tiff','MultiSelect','on');
   [sname,savefolder]=uiputfile('*.avi;*.gif','Where do you want to save the movie?');
    savename=[savefolder '/' sname];
   Hz=inputdlg('Input Frame Rate in Hz');
   Hz = str2double(Hz{1});
    for i=1:numel(fnames)
       filenames{i}=[foldername '/' fnames{i}]; 
    end
end
if nargin==3
   duplicate = 1; 
end
[~,~,ext]=fileparts(savename);
if strcmp(ext,'.gif')
    makeGif(filenames,savename,1/Hz,duplicate)
elseif strcmp(ext,'.avi')
    makeAvi(filenames,savename,Hz,duplicate)
end

end

function makeAvi(filenames,outputfilename,framerate,duplicate)

writerObj=VideoWriter(outputfilename);
writerObj.FrameRate=framerate;
open(writerObj);
try
for i=1:numel(filenames)
    fprintf('%.0f/%.0f...%s\n',i,numel(filenames),datestr(now));
    
    [I,~,alpha]=imread(filenames{i});
    I(repmat(alpha==0,1,1,3)) = 255;

    frame.cdata=I;frame.colormap=[];
    for j=1:duplicate
        writeVideo(writerObj,frame);
    end
end
catch
    fprintf('error...closing writerobj');
end
close(writerObj);

end

function makeGif(filenames,outputfilename,delaytime,duplicate)

I=imread(filenames{1});
[A,map]=rgb2ind(I,256);

imwrite(A,map,outputfilename,'gif','LoopCount',Inf,'DelayTime',delaytime);
for i=2:numel(filenames)
    fprintf('%.0f/%.0f...%s\n',i,numel(filenames),datestr(now));
    [I,~,alpha]=imread(filenames{i});
    I(repmat(alpha==0,1,1,3)) = 255;
    [A,map]=rgb2ind(I,256);
    for j=1:duplicate
        imwrite(A,map,outputfilename,'gif','WriteMode','append','DelayTime',delaytime);
    end
end

end