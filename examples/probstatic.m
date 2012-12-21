function [force,diffuse,spont] = probstatic(Delta,gamma,g0,kL,z)
% [force,diffuse,spont] = probstatic(Delta,gamma,g0,kL,z) calculates the force, 
%  momentum diffusion and spontaneous emission rate for a stationary 
%  two-level atom in a standing wave light field.
%
%  Delta = laser freq - atomic freq
%  gamma = atomic decay
%  g0    = coupling between atom and light, g(z) = 2*g0*cos(kL*z)
%  kL    = wavenumber of light
%  z     = position in standing wave

g = 2*g0*cos(kL*z);
gg = -2*g0*kL*sin(kL*z);
%
sm = sigmam;
% Calculate Hamiltonian, force and collapse operator (spontaneous emission)
H = -Delta*sm'*sm - i*(g'*sm - sm'*g);
F = i*(gg'*sm - gg*sm');
C1 = sqrt(gamma)*sm;
% Calculate Liouvillian
C1dC1 = C1'*C1;
LH = -i*(spre(H)-spost(H));
L1 = spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
L = LH + L1;
% Find steady state density matrix and force
rhoss = steady(L);
force = expect(F,rhoss);
spont = expect(C1'*C1,rhoss);
% Initial condition for regression theorem
Frho = spre(F)*rhoss;
% Solve differential equation with this initial condition
solES = ode2es(L,Frho);
% Find trace(F * solution)
corrES = expect(F,solES);
% Calculate the covariance by subtracting product of means
covES = corrES-force^2;
% Integrate the force covariance and return real part
diffuse = real(esint(covES));