function [count1, count2, infield] = prob2(E,kappa,gamma,g,wc,w0,wl,N,tlist)
%
% [count1, count2, infield] = prob2(E,kappa,gamma,g,wc,w0,wl,tlist)
%  solves the problem of a coherently driven cavity with a two-level atom
%  with the atom initially in the ground state and no photons in the cavity
%
%  E = amplitude of driving field, kappa = mirror coupling,
%  gamma = spontaneous emission rate, g = atom-field coupling,
%  wc = cavity frequency, w0 = atomic frequency, wl = driving field frequency,
%  N = size of Hilbert space for intracavity field (zero to N-1 photons)
%  tlist = times at which solution is required
% count1 = photocount rate of light leaking out of cavity
% count2 = spontaneous emission rate
% infield  = intracavity field

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

% Calculate solution as an exponential series
rhoES = ode2es(L,rho0);

% Calculate expectation values
count1 = esval(expect(C1dC1,rhoES),tlist);
count2 = esval(expect(C2dC2,rhoES),tlist);
infield = esval(expect(a,rhoES),tlist);