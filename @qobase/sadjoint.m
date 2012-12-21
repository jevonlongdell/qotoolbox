function Lt = sadjoint(L)
% SADJOINT  Finds a superoperator whose effect on a density matrix is the adjoint
%  of the action of the superoperator L

% If the action of superoperator L on density matrix rho is A*rho*B, where A and B are operators,
%    the action of the adjoint superoperator on rho is B'*rho*A' 
% SADJOINT operates member-wise on arrays

%% version 0.15 23-Nov-2001
%
%    Copyright (C) 1996-2001  Sze M. Tan
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
%   23-Nov-2001 S.M. Tan   Initial implementation

if ~issuper(L)
   error('Input is not a superoperator');
end
Lt.size = L.size;
Lt.dims = L.dims;
Lt.shape = L.shape;
Lt.data = sparse(prod(Lt.shape),prod(Lt.size));
n = sqrt(Lt.shape(1));  % Size of ket Hilbert space
perm = reshape(1:n.^2,n,n)';
perm = perm(:); % Index vector for permutation
for k = 1:prod(Lt.size)
   temp = reshape(L.data(:,k),L.shape);
   temp = conj(temp(perm,perm));
   Lt.data(:,k) = temp(:);
end
Lt = qobase(Lt);
