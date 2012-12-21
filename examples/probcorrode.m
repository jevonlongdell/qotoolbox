function [corr,cov] = probcorrode(E,kappa,gamma,g,wc,w0,wl,N,tlist)
%
% [corr,cov] = probcorrode(E,kappa,gamma,g,wc,w0,wl,N)
%  returns the two-time correlation and covariance of the intracavity 
%  field for the problem of a coherently driven cavity with a two-level 
%  atom
%
%  E = amplitude of driving field, kappa = mirror coupling,
%  gamma = spontaneous emission rate, g = atom-field coupling,
%  wc = cavity frequency, w0 = atomic frequency, wl = driving field frequency,
%  N = size of Hilbert space for intracavity field (zero to N-1 photons)
%  tlist = list of times at which correlation is required
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

% Find steady state density matrix and field
rhoss = steady(L);
ass = expect(a,rhoss);

% Initial condition for regression theorem
arho = a*rhoss;

% Solve differential equation with this initial condition

options.lmm = 'ADAMS';
options.iter = 'FUNCTIONAL';
options.reltol = 1e-6;
options.abstol = 1e-12;
% Write out the data file
ode2file('file1.dat',L,arho,tlist,options);
% Call the equation solver
odesolve('file1.dat','file2.dat');
% Read in the output data file
fid = fopen('file2.dat','rb');
corr = zeros(size(tlist));
cov  = zeros(size(tlist));
%
for k = 1:length(tlist)
   arho1 = qoread(fid,dims(arho),1);
   corr(k) = expect(a',arho1);
   cov(k) = corr(k) - ass'*ass;
end   
fclose(fid);
