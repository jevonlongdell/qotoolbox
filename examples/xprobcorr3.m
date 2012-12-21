kappa = 2; gamma = 0.2; g = 5;
wc = 0; w0 = 0; wl = 0;
N = 5; E = 0.5;
ida = identity(N); idatom = identity(2); 
tlist = linspace(0,100,201);
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
aval = expect(a'*a,psi)./norm(psi).^2;
% plot(tlist,real(aval),tlist,imag(aval));
psif = psi{length(tlist)};
psif = psif/norm(psif);
ntraj = 50;
tlist1 = linspace(0,10,101);
nexpect = mccorr2file('test.dat',-i*Heff,{C1,C2},{a'*a},psif,a*psif,tlist1,ntraj);
mccorr('test.dat','out.dat');
fid = fopen('out.dat','rb');
[iter,cfunc] = expread(fid,nexpect,tlist1);
fclose(fid);
plot(tlist1,real(cfunc),tlist1,imag(cfunc));

