function force = prob2lev(v,kL,g0,Gamma,Delta)
% force = prob2lev(v,kL,g0,Gamma,Delta)
%
% Calculates the force on a moving two-level atom travelling at
%  speed v in a standing wave with wavenumber kL. The coupling
%  strength is g0, the atomic spontaneous emission rate is
%  Gamma and the detuning is Delta  
%
Ne = 1; Ng = 1; Nat = Ne+Ng;
% Form the lowering operator
A = sigmam;
% Time-dependent couplings for atom and field
g   = eseries(g0,i*kL*v) + eseries(g0,-i*kL*v);
gg  = eseries(i*kL*g0,i*kL*v) + eseries(-i*kL*g0,-i*kL*v);
% Form interaction picture Hamiltonian
% Excited state terms
excited = basis(Nat,1:Ne);
H0 = -Delta*sum(excited*excited');
% Interaction with light
H = -(g'*A + A'*g) + H0;
% Force operator
F = gg'*A + gg*A';
% Collapse operators
C1 = sqrt(Gamma)*A; C1dC1 = C1'*C1;
% Liouvillians
L1 = spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
% Calculate total Liouvillian as an exponential series
LH = -i*(spre(H)-spost(H));
L = LH + L1;
% Matrix continued fraction calculation
rho = mcfrac(L,20,1);
force = expect(F,rho);
