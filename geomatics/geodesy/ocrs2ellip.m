function [lat,lon] = ocrs2ellip(E,N,ocrsname)
% convert lat/lon coordinates into OCRS projection
[Projdef,Ellipdef,type] = getOCRS(ocrsname);


switch type
    case 'lcc1sp'
        fun = @lcc1sp2ellip;
    case 'lcc2sp'
        fun = @lcc2sp2ellip;
    case 'tm'
        fun = @transmercator2ellip;
    case 'om'
        fun = @obliquemercator2ellip;
end
[lat,lon]=fun(Ellipdef,Projdef,E,N);

end

