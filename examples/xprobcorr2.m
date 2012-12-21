% xprobcorr.m is the driver file for probcorr.m

kappa = 2;
gamma = 0.2;
g = 5;
wc = 0;
w0 = 0;
wl = 0;
N = 4;
E = 0.5;
neigs = input('Number of significant eigenvalues?');

[corrES,covES] = probcorr2(E,kappa,gamma,g,wc,w0,wl,N,neigs);

tlist = linspace(0,10,200);
corr  = esval(corrES,tlist);
cov   = esval(covES,tlist);
figure(1); plot(tlist,real(corr),tlist,real(cov));
wlist = linspace(-10,10,200);
Ps = esspec(covES,wlist);
figure(2); plot(wlist,Ps);
