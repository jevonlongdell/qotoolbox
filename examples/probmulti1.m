function force = probmulti1(v,kL,Jg,Je,Omega,Gamma,Delta)
% Calculate the force on an atom with light fields in a 
%  sigma+ sigma- configuration.
Ne = 2*Je+1; Ng = 2*Jg+1; Nat = Ne+Ng;
% Form the lowering operators for various polarizations of light
[am,a0,ap] = murelj(Jg,Je);
Am = sparse(Nat,Nat); Am(Ne+1:Ne+Ng,1:Ne)=am; Am = qo(Am);
A0 = sparse(Nat,Nat); A0(Ne+1:Ne+Ng,1:Ne)=a0; A0 = qo(A0);
Ap = sparse(Nat,Nat); Ap(Ne+1:Ne+Ng,1:Ne)=ap; Ap = qo(Ap);
%
gp  = eseries(0.5*Omega,i*kL*v);
gm  = eseries(0.5*Omega,-i*kL*v);
ggp = eseries(0.5*i*kL*Omega,i*kL*v);
ggm = eseries(-0.5*i*kL*Omega,-i*kL*v);
% Form interaction picture Hamiltonian
% Excited state terms
excited = basis(Nat,1:Ne);
H0 = -Delta*sum(excited*excited');
% Interaction with sigma+ light
Hp = -(gp'*Ap + gp*Ap');
% Interaction with sigma- light
Hm = -(gm'*Am + gm*Am');
H  = H0 + Hp + Hm;
% Force operator
Fp = (ggp'*Ap + ggp*Ap');
Fm = (ggm'*Am + ggm*Am');
F = Fp + Fm;
% Collapse operators as an array
C = sqrt(Gamma)*[Am,A0,Ap];
% Loss Liouvillians
Lloss = spre(C)*spost(C')-0.5*spre(C'*C)-0.5*spost(C'*C);
% Calculate total Liouvillian 
L = -i*(spre(H)-spost(H)) + sum(Lloss);
% Matrix continued fraction calculation
rho = mcfrac(L,20,1);
force = expect(F,rho);
