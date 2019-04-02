function ef = elevationfactor(h)
%% Computes elevation factor in meters
R = 6372148.8; % radius in meters

ef = R/(R+h);

end