%% testcolorhist

N = 100000;

x = rand(1,N)*100;

rgb=uint8(rand(N,3)*255);

xi = 0:1:100;

figure(1);clf
colorhist(x,rgb,xi);

figure(2);clf
histogram(x,xi)