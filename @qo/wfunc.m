function wmat = wfunc(state,xvec,yvec,g)
% QO/WFUNC computes the Wigner function of a quantum array object 
% wmat = wfunc(state,xvec,yvec,g) 
%  evaluates Wigner function at points xvec+i*yvec, state can be a state 
%  vector or density matrix, g specifies convention a = 0.5*g*(x+iy), 
%  g=sqrt(2) by default

%% version 0.14 3-Apr-1999
%
%    Copyright (C) 1996-2002  Sze M. Tan
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
%
%    Address: Physics Department, The University of Auckland, New Zealand
%    Email: s.tan@auckland.ac.nz

%   Revision history:
%   27-Dec-98   S.M. Tan   Initial release
%    3-Apr-99   S.M. Tan   Modified recursion for improved stability

if isoper(state);
   ketflag = 0;
elseif isket(state)
   ketflag = 1;
else
   error('Invalid operands to wfunc.');
end   

if nargin<4, g=sqrt(2); end
N = prod(dim(state));
if N<=32
   wmat = wsmall(state,xvec,yvec,g);
   return;   
end

[xx,yy] = meshgrid(xvec,yvec);
amat = 0.5*g*(xx + i*yy);
Wlist = zeros(size(amat,1),size(amat,2),N);
state = struct(state.qobase);
wmat = zeros([size(amat) state.size]);
%
Wlist(:,:,1) = exp(-2*abs(amat).^2)/pi;
for n = 1:N-1
   Wlist(:,:,n+1) = (2*amat.*Wlist(:,:,n))./sqrt(n);
end
for k = 1:prod(state.size)
   rho = reshape(state.data(:,k),state.shape);
   if ketflag, rho = rho*rho'; end
   wmat(:,:,k) = rho(1,1)*real(Wlist(:,:,1));
   for n = 2:N
      wmat(:,:,k) = wmat(:,:,k)+2*real(rho(1,n)*Wlist(:,:,n));
   end      
end   

for m = 1:N-1
   temp = Wlist(:,:,m+1);
   Wlist(:,:,m+1) = (2*conj(amat).*temp-sqrt(m)*Wlist(:,:,m))/sqrt(m);
   for n = m+1:N-1
      temp2 = (2*amat.*Wlist(:,:,n)-sqrt(m)*temp)./sqrt(n);
      temp  = Wlist(:,:,n+1);
      Wlist(:,:,n+1) = temp2;
   end
   for k = 1:prod(state.size)
      rho = reshape(state.data(:,k),state.shape);
      if ketflag, rho = rho*rho'; end
      wmat(:,:,k) = wmat(:,:,k)+rho(m+1,m+1)*real(Wlist(:,:,m+1));
      for n = m+2:N
         wmat(:,:,k) = wmat(:,:,k)+2*real(rho(m+1,n)*Wlist(:,:,n));
      end      
   end
end
wmat = 0.25 * wmat * g^2;

% The following code is used if N<=32. It operates more quickly but
%  is susceptible to round-off problems for larger N
function wmat = wsmall(state,xvec,yvec,g)
global WIGNER_N WIGNER_CMAT
if isempty(WIGNER_N)
   WIGNER_N = 1;
   WIGNER_CMAT = {[1/pi]};
end   

if isoper(state);
   ketflag = 0;
elseif isket(state)
   ketflag = 1;
else
   error('Invalid operands to wfunc.');
end   

N = prod(dim(state));
if WIGNER_N < N
   make_CMAT(N);
   WIGNER_N = N;
end
[xx,yy] = meshgrid(xvec,yvec);
if nargin<4, g=sqrt(2); end
amat = 0.5*g*(xx + i*yy);

state = struct(state.qobase);
wmat = zeros([size(amat) state.size]);
for m = 1:prod(state.size)
   rho = reshape(state.data(:,m),state.shape);
   if ketflag, rho = rho*rho'; end
   c = sparse(N,N);
   for k = 1:N
      for l = 1:N
         c(1:l,1:k) = c(1:l,1:k) + WIGNER_CMAT{k,l}*rho(k,l);
      end
   end
   wmat(:,:,m) = weval(c,amat);
end   
wmat = 0.25 * wmat * g^2;

function w = weval(c,a)
N = max(size(c));
r2 = abs(a).^2;
w = 0;
for k = N-1:-1:1
   w = w + 2*real(a.^k.*polyval(flipud(diag(c,-k)),r2));
end
w = w + polyval(flipud(diag(c)),r2);
w = w.*exp(-2*r2);

function make_CMAT(newN)
global WIGNER_N WIGNER_CMAT
ud = spdiags((0:newN-1)',1,newN,newN);
ld = ud';
for N = WIGNER_N+1:newN
   % form cmat{N,1} through cmat{N,N-1}
   for n = 1:N-1
      c = WIGNER_CMAT{N-1,n};
      cnew = sparse(n,N);
      cnew(:,2:N) = 2*c;
      cnew(1:n-1,1:N-1) = cnew(1:n-1,1:N-1) - 0.5*ud(1:n-1,1:n)*c;
      WIGNER_CMAT{N,n} = cnew/sqrt(N-1);
   end
   % form cmat{1,N} through cmat{N,N}
   for m = 1:N
      c = WIGNER_CMAT{m,N-1};
      cnew = sparse(N,m);
      cnew(2:N,:) = 2*c;
      cnew(1:N-1,1:m-1) = cnew(1:N-1,1:m-1) - 0.5*c*ld(1:m,1:m-1);
      WIGNER_CMAT{m,N} = cnew/sqrt(N-1);
   end
end
