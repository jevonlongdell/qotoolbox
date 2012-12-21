function [forceES,diffuseES] = diffusea(v,kL,Jg,Je,Omega,Gamma,Delta)
% Calculate the force on an atom with light fields in a 
%  sigma+ sigma- configuration.
Ne = 2*Je+1; Ng = 2*Jg+1; Nat = Ne+Ng;
% Form the lowering operators for various polarizations of light
[am,a0,ap] = murelj(Jg,Je);
Am = sparse(Nat,Nat); Am(Ne+1:Ne+Ng,1:Ne)=am;
A0 = sparse(Nat,Nat); A0(Ne+1:Ne+Ng,1:Ne)=a0;
Ap = sparse(Nat,Nat); Ap(Ne+1:Ne+Ng,1:Ne)=ap;
% Convert to exponential series
AmES = const2es(Am);
A0ES = const2es(A0);
ApES = const2es(Ap);
% gp = 0.5*Omega*exp(i*kL*z);
% gm = 0.5*Omega*exp(-i*kL*z);
% ggp =  0.5*i*kL*Omega*exp(i*kL*z);
% ggm = -0.5*i*kL*Omega*exp(-i*kL*z);
% Due to motion, these become exponential series in time (z=vt)
gpES = const2es(0.5*Omega,i*kL*v);
gmES = const2es(0.5*Omega,-i*kL*v);
ggpES = const2es(0.5*i*kL*Omega,i*kL*v);
ggmES = const2es(-0.5*i*kL*Omega,-i*kL*v);
% Form interaction picture Hamiltonian
% Excited state terms
basis = speye(Nat,Nat);
H = sparse(Nat,Nat);
for ke = 1:Ne
   H = H - Delta*basis(:,ke)*basis(:,ke)';
end
% Convert to exponential series
HES = const2es(H);
% Interaction with sigma+ light
HpES = esneg(esadd(esmul(esadj(gpES),ApES),esmul(gpES,esadj(ApES))));
% Interaction with sigma- light
HmES = esneg(esadd(esmul(esadj(gmES),AmES),esmul(gmES,esadj(AmES))));
%
HES = esadd(const2es(H),HpES,HmES);
% Force operator
FpES = esadd(esmul(esadj(ggpES),ApES),esmul(ggpES,esadj(ApES)));
FmES = esadd(esmul(esadj(ggmES),AmES),esmul(ggmES,esadj(AmES)));
FES  = esadd(FpES,FmES);
% Collapse operators
C1 = sqrt(Gamma) * Am; C1dC1 = C1'*C1;
C2 = sqrt(Gamma) * A0; C2dC2 = C2'*C2;
C3 = sqrt(Gamma) * Ap; C3dC3 = C3'*C3;
% Liouvillians
L1 = spre(C1)*spost(C1')-0.5*spre(C1dC1)-0.5*spost(C1dC1);
L2 = spre(C2)*spost(C2')-0.5*spre(C2dC2)-0.5*spost(C2dC2);
L3 = spre(C3)*spost(C3')-0.5*spre(C3dC3)-0.5*spost(C3dC3);
%% Calculate total Liouvillian as an exponential series
LES = esadd(esh2esl(HES),const2es(L1+L2+L3));
% Matrix continued fraction calculation for force
Ncf = 20;
rhoFS = mcfrac(LES,Ncf,Ncf);
forceES = esexpect(FES,rhoFS);
% Find exponential series for (F-<F>)rho
KrhoFS = sfsmul(es2fs(forceES,kL*v),rhoFS,-Ncf*kL*v,Ncf*kL*v);
FrhoES = esmul(FES,rhoFS,Ncf*kL*v);
FrhoES = essub(FrhoES,KrhoFS);
% Calculate momentum diffusion
RES = mcfrac1(LES,FrhoES,1);
diffuseES = esexpect(FES,RES);

