function rmse = calcrmse(x_measured,x_true)

x_measured = x_measured(~isnan(x_measured(:)));
N = numel(x_measured);

rmse = sqrt(sum((x_measured-x_true).^2/N));

end