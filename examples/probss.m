function [count1, count2, infield] = probss(E,kappa,gamma,g,wc,w0,wl,N)
%
% [count1, count2, infield] = probss(E,kappa,gamma,g,wc,w0,wl)
%  solves the problem of a coherently driven cavity with a two-level atom
%
%  E = amplitude of driving field, kappa = mirror coupling,
%  gamma = spontaneous emission rate, g = atom-field coupling,
%  wc = cavity frequency, w0 = atomic frequency, wl = driving field frequency,
%  N = size of Hilbert space for intracavity field (zero to N-1 photons)
%  
% count1 = photocount rate of light leaking out of cavity
% count2 = spontaneous emission rate
% infield  = intracavity field
%
ida = identity(N); idatom = identity(2); 

% Define cavity field and atomic operators
a  = tensor(destroy(N),idatom);
sm = tensor(ida,sigmam);

% Hamiltonian
H = (w0-wl)*sm'*sm + (wc-wl)*a'*a + i*g*(a'*sm - sm'*a) + E*(a'+a);

% Collapse operators
C1    = sqrt(2*kappa)*a;
C2    = sqrt(gamma)*sm;
C1dC1 = C1'*C1;
C2dC2 = C2'*C2;

% Calculate the Liouvillian
LH = -i * (spre(H) - spost(H)); 
L1 = spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
L2 = spre(C2)*spost(C2')-0.5*spre(C2dC2)-0.5*spost(C2dC2);
L  = LH+L1+L2;

% Find steady state
rhoss = steady(L);

% Calculate expectation values
count1  = expect(C1dC1,rhoss);
count2  = expect(C2dC2,rhoss);
infield = expect(a,rhoss);