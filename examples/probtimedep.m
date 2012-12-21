function force = probtimedep(v,kL,g0,Gamma,Delta,tlist)
% force = probtimedep(v,kL,g0,Gamma,Delta,tlist)
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
psi0 = basis(2,2); rho0 = psi0 * psi0';
% Extract amplitudes of various terms in the exponential series
L0 = L(0).ampl;
Lp = L(i*kL*v).ampl;
Lm = L(-i*kL*v).ampl;
% Make the function series for the right hand side
rhs = L0 + Lp*fn('cexp',i*kL*v) + Lm*fn('cexp',-i*kL*v);
ode2file('file1.dat',rhs,rho0,tlist);
% Call the equation solver
odesolve('file1.dat','file2.dat');
% Read in the output data file
fid = fopen('file2.dat','rb');
rho = qoread(fid,dims(rho0),size(tlist));
fclose(fid);
% Calculate expectation values
Flist = esval(F,tlist);
force = expect(Flist,rho);
