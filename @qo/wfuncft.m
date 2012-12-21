function [wmat,yvec] = wfuncft(state,xvec,g)
% QO/WFUNC computes the Wigner function of a quantum object containing a single member
% [wmat,yvec] = wfunc(state,xvec,g)
%  evaluates Wigner function at points xvec+i*yvec, state can be a state vector or 
%  density matrix, g specifies convention a = 0.5*g*(x+iy), g=sqrt(2) by default.
%  WFUNC uses a Fourier transform based algorithm, and so xvec should be [-N/2:N/2-1]*dx
%  Note that yvec is calculated on the basis of xvec.

%   Copyright (c) 1996-97 by S.M. Tan
%   Revision history:
%   11-Oct-97   S.M. Tan   Implemented for Matlab 5

if prod(size(state))>1
   error('Can only find Wigner function of a quantum object with one member');
end
dx = xvec(2)-xvec(1); N = length(xvec);
if norm(xvec - [-N/2:N/2-1]*dx)/norm(xvec) > 1e-6
   error('xvec should be of the form [-N/2:N/2-1]*dx');
end   
if nargin<3, g=sqrt(2); end
if isoper(state)
   state = struct(state.qobase);
   rho = reshape(state.data,state.shape);
   [v,d] = eig(full(rho)); d = diag(d);
   wmat = 0;
   for k = 1:state.shape(1)
     [wmat1,yvec] = wfunc1(v(:,k),xvec,g);
      wmat = wmat + real(d(k)*wmat1);
   end   
elseif isket(state)
   state = struct(state.qobase);
   [wmat,yvec] = wfunc1(state.data,xvec,g);
else
   error('Invalid operand for wfunc');
end   

function [wigmat,yval] = wfunc1(psi,xval,g)
% qmat = wfunc1(psi,xval) calculates the Wigner function of a state 
%  whose number representation is in psi at the points in xval
if nargin<3, g = sqrt(2); end
psi = psi(:).';
n = length(psi);
S = oscfunc(n,xval*g/sqrt(2));
xpsi = psi * S;
[wigmat,yval]=wigner1(xpsi,xval*g/sqrt(2));
yval = yval*sqrt(2)/g; wigmat = 0.5*g.^2*real(wigmat).';

function [w,p]=wigner1(psi,x)
n=2*length(psi);
psi=psi(:).';
w=toeplitz(zeros(n/2,1),[0, fliplr(conj(psi)),zeros(1,n/2-1)]).* ...
flipud(toeplitz(zeros(n/2,1),[0, psi,zeros(1,n/2-1)]));
w=[w(:,n/2+1:n),w(:,1:n/2)];
w=fft(w.').';
w=real([w(:,3*n/4+1:n),w(:,1:n/4)]);
p=[-n/4:n/4-1]*pi/(n*(x(2)-x(1)));
w = w/(p(2)-p(1))/n;

function S = oscfunc(N,x)
% S = oscfunc(N,x) generates a vector of simple harmonic oscillator eigenfunctions 
%  at point x for n=0..N-1

% This file is part of the Quantum Optics toolbox
%   Copyright (c) 1996-97 by S.M. Tan
%   Revision history:
%   12-Sept-97   S.M. Tan   Implemented for Matlab 5
x = x(:).';
lx = length(x);
S = zeros(N,lx);
S(1,:) = exp(-x.^2/2)/pi^0.25;
if N == 1, return; end
S(2,:) = sqrt(2) * x .* S(1,:);
for k = 2:N-1
   S(k+1,:) = sqrt(2/k)*x.*S(k,:) - sqrt((k-1)/k) * S(k-1,:);
end
