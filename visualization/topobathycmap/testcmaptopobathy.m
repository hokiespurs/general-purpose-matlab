%% TEST different depth colormaps
JERLOVNAMES = {'I', 'IA','IB', 'II','III',  '1',  '3',  '5',  '7',  '9','rs'};

figure(1);clf
for i=1:numel(JERLOVNAMES)
    h= subplot(20,20,i);
    jerlovname = JERLOVNAMES{i};
    nvals = 100;
    seafloorcolor = [];
    atmoscolor = [];
    depthrange = [0 999];
    cmap = cmapbathy(depthrange,nvals,jerlovname);
    
    c=colorbar;
    c.Position = [0.001 + i*0.065 0.1 0.05 0.7];
    colormap(h,cmap)
    pause(0.05)
end

%%
    h= subplot(20,20,19);
c=colorbar;
c.Position = [0.8 0.1 0.05 0.7];
cmaptopobathy([-10 3]);

    h= subplot(20,20,20);
c=colorbar;
c.Position = [0.9 0.1 0.05 0.7];
cmaptopobathy([-10 3],100,jet);