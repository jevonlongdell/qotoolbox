function [force,diffuse] = prob5b(v,kL,g0,Gamma,Delta)
% [force,diffuse] = prob5b(v,kL,g0,Gamma,Delta)
%
% Calculates the force and diffusion on a moving 2 level atom travelling at
%  speed v in a standing wave with wavenumber kL. The coupling
%  strength is g0, the atomic spontaneous emission rate is
%  Gamma and the detuning is Delta  
%
tic
Ne = 1; Ng = 1; Nat = Ne+Ng;
% Form the lowering operator
A = sigmam;
% g  = 2*g0*cos(kL*z)  = g0*exp(i*kL*z) + g0*exp(-i*kL*z)
% gg = -2*g0*sin(kL*z) = i*kL*g0*exp(i*kL*z) - i*kL*g0*exp(-i*kL*z)
g   = eseries(g0,i*kL*v) + eseries(g0,-i*kL*v);
gg  = eseries(i*kL*g0,i*kL*v) + eseries(-i*kL*g0,-i*kL*v);
toc,tic;
% Form interaction picture Hamiltonian
% Excited state terms
H0 = 0;
for ke = 1:Ne
   H0 = H0 - Delta*basis(Nat,ke)*basis(Nat,ke)';
end
toc,tic;
% Interaction with light
H = -(g'*A + A'*g) + H0;
% Force operator
F = gg'*A + gg*A';
% Collapse operators
C1 = sqrt(Gamma) * A; C1dC1 = C1'*C1;
toc,tic;
% Liouvillians
L1 = spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
% Calculate total Liouvillian as an exponential series
LH = -i*(spre(H)-spost(H));
L = LH + L1;
toc,tic
% Matrix continued fraction calculation for force
Ncf = 20;
rho = mcfrac(L,Ncf,Ncf);
force = expect(F,rho);
Frho = (F-force*speye(2))*rho;
toc
keyboard
%
R = mcfrac1(L,Frho,1);
diffuse = expect(F,R);


