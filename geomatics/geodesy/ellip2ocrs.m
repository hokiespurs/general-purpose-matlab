function [E,N] = ellip2ocrs(lat,lon,ocrsname)
% convert lat/lon coordinates into OCRS projection
[Projdef,Ellipdef,type] = getOCRS(ocrsname);


switch type
    case 'lcc1sp'
        fun = @ellip2lcc1sp;
    case 'lcc2sp'
        fun = @ellip2lcc2sp;
    case 'tm'
        fun = @ellip2transmercator;
    case 'om'
        fun = @ellip2obliquemercator;
end
[E,N]=fun(Ellipdef,Projdef,lat,lon);

end

