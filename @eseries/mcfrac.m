function rhoFS = mcfrac(LES,Ncf,Nes)
% ESERIES/MCFRAC finds exponential series solution of master eqn using matrix continued fractions
% rhoFS = mcfrac(LES,Ncf,Nes) calculates a matrix-continued fraction 
%  solution of the master equation d(rho)/dt = L(rho) where L is an
%  exponential series consisting of a constant term and two terms with
%  positive and negative angular frequencies
%

%   Copyright (c) 1996-97 by S.M. Tan
%   Revision history:
%   12-Sept-97   S.M. Tan   Implemented for Matlab 5
%   28-Sep-99    S.M. Tan   Modified for Matlab 5.3

tol = 1e-6;
if ~issuper(LES)
   error('mcfrac requires a superoperator for its first argument')
end
nL2 = shape(LES); nL2 = nL2(1);
if nterms(LES) == 1
   if LES.s(1) ~= 0
      error('Invalid input to MCFRAC'); 
   end
   rhoFS = eseries(steady(subsref(LES,substruct('{}',{1},'.','ampl'))));
   return
elseif nterms(LES) == 3
   sval = i * max(abs(LES.s));
   i0 = find(abs(LES.s) < tol*abs(sval));
   ip = find(abs(LES.s - sval) < tol*abs(sval));
   im = find(abs(LES.s + sval) < tol*abs(sval));
   if isempty(i0) | isempty(ip) | isempty(im)
      error('Input to mcfrac should have a constant term and a sinusoid.'); 
   end
   L0 = double(subsref(LES,substruct('{}',{i0},'.','ampl')));
   Lp = double(subsref(LES,substruct('{}',{ip},'.','ampl')));
   Lm = double(subsref(LES,substruct('{}',{im},'.','ampl')));
   I = speye(size(L0));
   S = sparse(nL2,nL2);
   Ssave = sparse(nL2,nL2*Nes);
   for k = Ncf:-1:1
      S = - (L0-sval*k*I + Lm*S) \ Lp;
      if k<=Nes
         Ssave(:,(k-1)*nL2+(1:nL2)) = S;
      end
   end
   T = sparse(nL2,nL2);
   Tsave = sparse(nL2,nL2*Nes);
   for k = -Ncf:-1
      T = - (L0-sval*k*I + Lp*T) \ Lm;
      if abs(k)<=Nes
         Tsave(:,(abs(k)-1)*nL2+(1:nL2)) = T;
      end
   end
   LL = Lp*T + L0 + Lm*S;
   rho0 = double(steady(qo(LL,dims(LES))));
   rhoFS = sparse(nL2,2*Nes+1);
   rhoFS(:,Nes+1) = rho0(:);
   rho = rho0(:);
   for k = 1:Nes
      rho = Tsave(:,(k-1)*nL2+(1:nL2))*rho;
      rhoFS(:,Nes+1-k) = rho; 
   end
   rho = rho0(:);
   for k = 1:Nes
      rho = Ssave(:,(k-1)*nL2+(1:nL2))*rho;
      rhoFS(:,Nes+1+k) = rho; 
   end
   rhoFS.data = rhoFS; rhoFS.dims = dims(LES,1);
   rhoFS.shape = [prod(rhoFS.dims{1}),prod(rhoFS.dims{2})];
   rhoFS.size = [2*Nes+1,1];
   
   rhoFS = estidy(eseries(qo(rhoFS),(-Nes:Nes)'*sval));
else
   error('Invalid exponential series for mcfrac')
end
