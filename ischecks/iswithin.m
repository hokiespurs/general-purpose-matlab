function val = iswithin(x,lim)
% see if all x values are within a range defined by lim INCLUSIVE
if all(x(:)>=lim(1) & x(:)<=lim(2))
    val = true;
else
    val = false;
end

end