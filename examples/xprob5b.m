% xprob5b.m tests calculation of force and diffusion on a uniformly 
%  moving atom

kL = 1;
g0 = 1.5*sqrt(2);
Gamma = 1;
Delta = -3;
vlist = linspace(0.05,5,100);
nv = length(vlist);
flist = zeros(nv,1);
dlist = zeros(nv,1);

for kv = 5:nv
   v = vlist(kv);
   [forceES,diffuseES] = prob5b(v,kL,g0,Gamma,Delta);
   flist(kv) = forceES(0);
   dlist(kv) = diffuse(0);
   kv
end

subplot(2,1,1);
plot(vlist,real(flist));
subplot(2,1,2);
plot(vlist,real(dlist));
subplot
