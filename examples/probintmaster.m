function [count1, count2, infield, check] = probintmaster(E,kappa,gamma,g,wc,w0,wl,N,tlist)
%
% [count1, count2, infield] = probintmaster(E,kappa,gamma,g,wc,w0,wl,tlist)
%  illustrates solving the master equation by numerical integration of the 
%  differential equation. This is the same problem as solved by probevolve.m.
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
% Calculate the Liouvillian
LH = -i * (spre(H) - spost(H)); 
L1 = spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
L2 = spre(C2)*spost(C2')-0.5*spre(C2dC2)-0.5*spost(C2dC2);
L = LH+L1+L2;
% Initial state
psi0 = tensor(basis(N,1),basis(2,2));
rho0 = psi0 * psi0';
% Set up options, if required
options.lmm = 'ADAMS';
options.iter = 'FUNCTIONAL';
options.reltol = 1e-6;
options.abstol = 1e-6;
options.mxstep = 500;
% Write out the data file
ode2file('file1.dat',L,rho0,tlist,options);
% Call the equation solver
odesolve('file1.dat','file2.dat');
% Read in the output data file
fid = fopen('file2.dat','rb');
rho = qoread(fid,dims(rho0),size(tlist));
fclose(fid);
% Calculate expectation values
count1 = expect(C1dC1,rho);
count2 = expect(C2dC2,rho);
infield = expect(a,rho);
idtot = tensor(ida,idatom);
check = expect(idtot,rho);
