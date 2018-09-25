function Ifilt = adapthistRGB(Iraw,numtiles,varargin)
%% Use this function to apply adapthisteq to an RGB image
%
% INPUT
%    Iraw: MxNxP Double [0 1]: Raw Image Input
%    numtiles: QxR: Number of tiles to break the image into
%
% OUTPUT
%    Ifilt: MxNxP: Processed image output as RGB
%
% This code is modified from the matlab help example for adapthisteq

if nargin ==1
    numtiles = [8 8];
    varargin = [];
elseif nargin==2
        varargin=[];
end
    %convert RGB to LAB space
    cform2lab = makecform('srgb2lab');
    LAB = applycform(Iraw, cform2lab);
    
    L = LAB(:,:,1)/100;
    % Perform AdaptHistEq in LAB space
    LAB(:,:,1) = adapthisteq(L,'NumTiles',numtiles)*100;
    
    %convert back to RGB
    cform2srgb = makecform('lab2srgb');
    Ifilt = applycform(LAB, cform2srgb);
end