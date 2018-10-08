function dolp = calcdolp(X,D)

X2 = cat(3,X,X);
nX = size(X2,3);
D2 = repmat(reshape([D(:) 180+D(:)],1,1,numel(D)*2),size(X2,1),size(X2,2));

maskinds = cumsum(ones([1 1 nX],'uint8'),3);

maskvals = repmat(maskinds,size(X2,1),size(X2,2));

[minvals,indlow] = min(X,[],3);
indlow = repmat(uint8(indlow),1,1,nX);

mask = maskvals - indlow;
mask(mask>nX/2-1)=0;

mask = logical(mask);

Xuse = X2-repmat(minvals,1,1,nX);
Xuse(~mask)=0;
Duse = D2;
Duse(~mask)=0;

dolp = sum(double(Xuse).*Duse,3)./double(sum(Xuse,3));
dolp(isnan(dolp))=0;
dolp(dolp>180)=dolp(dolp>180)-180;

end