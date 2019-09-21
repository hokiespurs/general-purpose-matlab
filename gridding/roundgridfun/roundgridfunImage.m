function [Igrid,badval]=roundgridfunImage(x,y,I,xi,yi,fun,nanval)

[Rg,npts] = roundgridfun(x,y,I(:,:,1),xi,yi,fun);
Gg = roundgridfun(x,y,I(:,:,2),xi,yi,fun);
Bg = roundgridfun(x,y,I(:,:,3),xi,yi,fun);

Igrid = cat(3,Rg,Gg,Bg);

badval = npts==0;

Igrid(repmat(badval,1,1,3))=nanval;

Igrid=cast(Igrid,'like',I);

end