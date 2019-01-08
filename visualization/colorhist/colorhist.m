function colorhist(x,rgb,xi)
ax = gca;
axpos = ax.Position;

yaxlim = [axpos(2) axpos(2)+axpos(4)];
xaxlim = [axpos(1) axpos(1)+axpos(3)];

nbins = numel(xi)-1;

px = linspace(xaxlim(1),xaxlim(2),nbins+1);
pyraw = histcounts(x,xi);
py = changeScale(pyraw,[0 max(pyraw(:))],yaxlim);
xlim([xi(1) xi(end)]);
xtixlabels = xticklabels;

xlim([0 1]);
xticks(linspace(0,1,size(xtixlabels,1)));
xticklabels(xtixlabels);
ylim([0 max(pyraw(:))])
for i=1:nbins
    ind = x>xi(i) & x<xi(i+1);
    if sum(ind)~=0
        X = rgb(ind,:);
        Xlab = rgb2hsv(double(X)./255);
%         Xlabsort = hsv2rgb(sortrows(Xlab,[1 2 -3]));
         Xlabsort = hsv2rgb(sortrows(Xlab,[1 -3 2]));
        
        X = uint8(permute(X,[1 3 2]));
        Xlabsort = uint8(255*permute(Xlabsort,[1 3 2]));
        
        if py(i)-yaxlim(1)~=0
            axes('Position',[px(i) yaxlim(1) mean(diff(px)) py(i)-yaxlim(1)])
            imagesc(Xlabsort);
            axis off
        end
    end
    drawnow
end
end