function qmat = qfunc(state,xvec,yvec,g)
% QO/QFUNC computes the Q function of a quantum array object
% qmat = qfunc(state,xvec,yvec,g) 
%  evaluates Q function at points xvec+i*yvec, state can be a state vector or 
%  density matrix, g specifies convention a = 0.5*g*(x+iy), g=sqrt(2) by default

%% version 0.15 20-Aug-2002
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
%   11-Oct-97   S.M. Tan   Implemented for Matlab 5

if nargin<4, g=sqrt(2); end
[xx,yy] = meshgrid(xvec,yvec);
amat = 0.5*g*(xx + i*yy);

if isoper(state);
   ketflag = 0;
elseif isket(state)
   ketflag = 1;
else
   error('Invalid operands to wfunc.');
end   

N = prod(dim(state));
state = struct(state.qobase);
qmat = zeros([size(amat) state.size]);
for m = 1:prod(state.size)
   rho = reshape(state.data(:,m),state.shape);
   if ketflag
      qmat(:,:,m) = qfunc1(rho,amat);
   else
      [v,d] = eig(full(rho)); d = diag(d);
      qmat(:,:,m) = 0;
      for k = 1:state.shape(1)
         qmat(:,:,m) = qmat(:,:,m) + real(d(k)*qfunc1(v(:,k),amat));
      end   
   end
end  
qmat = 0.25 * qmat * g^2;

function qmat1=qfunc1(psi,amat)
psi = psi(:).';
index = 1:length(psi);
qmat1 = abs(polyval(fliplr(psi(index)./sqrt([1,cumprod(1:length(psi)-1)])),conj(amat))).^2/pi;
qmat1 = real(qmat1.*exp(-abs(amat).^2));
