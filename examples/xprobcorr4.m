kappa = 2; gamma = 0.2; g = 5;
wc = 0; w0 = 0; wl = 0;
N = 5; E = 0.5;
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

% Find steady state density matrix
rhoss = steady(L);

% Initial condition for regression theorem
arhoad = a*rhoss*a';

% Solve differential equation with this initial condition
solES = ode2es(L,arhoad);

% Find trace(a' * a * solution)
corrES = expect(a'*a,solES);
tlist = linspace(0,10,101);
plot(tlist,esval(corrES,tlist));
