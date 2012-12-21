% xprobevolve.m is a driver file for probevolve

kappa = 2;
gamma = 0.2;
g = 1;
wc = 0;
w0 = 0;
wl = 0;
N = 4;
E = 0.5;
n = input('Number of significant eigenvalues? ');
tlist = linspace(0,10,200);
[count1,count2,infield] = probevolve2(E,kappa,gamma,g,wc,w0,wl,N,tlist,n);

plot(tlist,real(count1),tlist,real(count2));
