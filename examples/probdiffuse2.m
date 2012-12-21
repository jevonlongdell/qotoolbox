function [count1, count2, infield] = probdiffuse2(E,kappa,gamma,g,wc,w0,wl,N,tlist,ntraj)
%
% [count1, count2, infield] = probdiffuse2(E,kappa,gamma,g,wc,w0,wl,tlist,ntraj)
%  illustrates solving the master equation by quantum Monte Carlo 
%  integration of the equation. This is the same problem as solved by probevolve.m.
% 
ida = identity(N); idatom = identity(2); 
% Define cavity field and atomic operators
a  = tensor(destroy(N),idatom);
sm = tensor(ida,sigmam);
% Hamiltonian
H = (w0-wl)*sm'*sm + (wc-wl)*a'*a + i*g*(a'*sm - sm'*a) + E*(a'+a);
% Collapse operators
C1  = sqrt(2*kappa)*a;
C2  = sqrt(gamma)*sm;
C1dC1 = C1'*C1;
C2dC2 = C2'*C2;
% Calculate Heff
Heff = H - 0.5*i*(C1dC1+C2dC2);
% Initial state
psi0 = tensor(basis(N,1),basis(2,2));
% Quantum Monte Carlo simulation
nexpect = sde2file('test.dat',-i*Heff,{C1},{C2},{C1dC1,C2dC2,a},psi0,tlist,ntraj);
sdesolve('test.dat','out.dat','photo.dat')
fid = fopen('out.dat','rb');
[iter,count1,count2,infield] = expread(fid,nexpect,tlist);
fclose(fid);

