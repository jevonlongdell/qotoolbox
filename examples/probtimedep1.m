function force = probtimedep1(v,kL,g0,Gamma,Delta,tlist)
% force = probtimedep1(v,kL,g0,Gamma,Delta,tlist)
%
% Calculates the force on a moving 2 level atom travelling at
%  speed v in a standing wave with wavenumber kL. The coupling
%  strength is g0, the atomic spontaneous emission rate is
%  Gamma and the detuning is Delta. The force is calculated at 
%  times in tlist.
%
Ne = 1; Ng = 1; Nat = Ne+Ng;
% Form the lowering operator
A = sigmam;
% g  = 2*g0*cos(kL*z)  = g0*exp(i*kL*z) + g0*exp(-i*kL*z)
% gg = -2*g0*sin(kL*z) = i*kL*g0*exp(i*kL*z) - i*kL*g0*exp(-i*kL*z)
g   = eseries(g0,i*kL*v) + eseries(g0,-i*kL*v);
gg  = eseries(i*kL*g0,i*kL*v) + eseries(-i*kL*g0,-i*kL*v);
% Form interaction picture Hamiltonian
excited = basis(Nat,1:Ne);
H = -Delta*sum(excited*excited')-(g'*A + A'*g);
% Force operator
F = gg'*A + gg*A';
% Collapse operators
C1 = sqrt(Gamma) * A; C1dC1 = C1'*C1;
% Liouvillian as an exponential series
L = -i*(spre(H)-spost(H))+spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
% Atom initially is in ground state
psi0 = basis(2,2);
% Extract amplitudes of various terms in the exponential series
H0 = H(0).ampl;
Hp = H(i*kL*v).ampl;
Hm = H(-i*kL*v).ampl;
% Make the function series for the right hand side
H = H0 + Hp*fn('cexp',i*kL*v) + Hm*fn('cexp',-i*kL*v);
Heff = H - 0.5*i*C1dC1;
%
Fs = F(0).ampl + F(i*kL*v).ampl*fn('cexp',i*kL*v) + F(-i*kL*v).ampl*fn('cexp',-i*kL*v);
nexpect = mc2file('file1.dat',-i*Heff,{C1},{Fs},psi0,tlist,200);
% Call the equation solver
odesolve('file1.dat','file2.dat');
% Read in the output data file
fid = fopen('file2.dat','rb');
[iter,force] = expread(fid,nexpect,tlist);
fclose(fid);




