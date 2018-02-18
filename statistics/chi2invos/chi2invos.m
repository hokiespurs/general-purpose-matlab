function chi2 = chi2invos(alpha, ndof)
% produces the same results as chi2inv but doesnt use the toolbox!
chi2 = gammaincinv(alpha, ndof/2)*2;
end