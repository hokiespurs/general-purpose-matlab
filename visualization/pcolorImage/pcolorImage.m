function I = pcolorImage(X,cax,cmap)

ind = num2ind(X,cax,size(cmap,1));
I = ind2rgb(ind,cmap);

badvals = repmat(isnan(X),[1 1 3]);

I(badvals)=255;

end