function [corrES,covES] = probcorr3(E,kappa,gamma,g,wc,w0,wl,N,neigs)
%
% [corrES,covES] = probcorr(E,kappa,gamma,g,wc,w0,wl,N)
%  returns the two-time correlation and covariance of the intracavity 
%  field as exponential series for the problem of a coherently driven 
%  cavity with a two-level atom
%
%  E = amplitude of driving field, kappa = mirror coupling,
%  gamma = spontaneous emission rate, g = atom-field coupling,
%  wc = cavity frequency, w0 = atomic frequency, wl = driving field frequency,
%  N = size of Hilbert space for intracavity field (zero to N-1 photons)
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
%
C1dC1 = C1'*C1;
C2dC2 = C2'*C2;
Heff = H - i*0.5*(C1dC1+C2dC2);
% Initial state
psi0 = tensor(basis(N,1),basis(2,2));
% Quantum Monte Carlo simulation
nexpect = mc2file('test.dat',-i*Heff,{C1,C2},[],psi0,tlist,1);
mcsolve('test.dat','out.dat');
fid = fopen('out.dat','rb');
if gettraj(fid) ~= 1, error('Unexpected data in file'); end
psi = qoread(fid,dims(psi0),size(tlist));
photnum = photnum + expect(a'*a,psi)./norm(psi).^2;
plot(tlist,photnum);

