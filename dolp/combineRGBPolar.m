%% combine RGB and Polar
DNAME = 'C:\tmp\pt3\organized';

for iP = 1:9
    for iT = 1:4
        fprintf('P%iT%i..%s\n',iP,iT,datestr(now));
        imRGB = [DNAME '/' sprintf('RGB_P%02.0f_T%02.0f.png',iP,iT)];
        imPolar = [DNAME '/' sprintf('POLARB_P%02.0f_T%02.0f.png',iP,iT)];
        imCombo = [DNAME '/' sprintf('combo/COMBOB_P%02.0f_T%02.0f.tiff',iP,iT)];
        image8to16(imRGB,imPolar,imCombo,true);
    end
end

itest1 = [DNAME '/' sprintf('combo/test1.png')];
itest2 = [DNAME '/' sprintf('combo/test2.png')];
image8to16(itest1,itest2,imCombo,false);
