function rho1 = ptrace(rho,sel)
% QO/PTRACE Calculate partial trace of a state vector or density matrix
% rho1 = ptrace(state,sel) returns a density matrix, sel is a selection vector specifying
%                          the indicies of the spaces which remain after computation of trace

%% version 0.14 15-Nov-1999
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
%   11-Jan-98   S.M. Tan   Modified for new structure
%    8-Sep-98   S.M. Tan   Improved efficiency for state kets
%   15-Nov-99   S.M. Tan   Corrected problem with call to "permute"

rho1 = struct(rho.qobase);
sel = sel(:);
drho = rho1.dims{1}; N = prod(drho); M = prod(drho(sel));
if isequal(prod(rho1.dims{2}),1);
   rest = (1:length(drho))';
   rest(sel) = [];
   psi = permute(rho.qobase,[sel;rest]);
   rho1.dims = {drho(sel),drho(sel)};
   rho1.shape = [M,M]; 
   rho1.data = sparse(prod(drho(sel)).^2,prod(rho1.size));
   for k = 1:prod(rho1.size)
      A = reshape(psi.data(:,k),[prod(drho(rest)),prod(drho(sel))]); 
      A = A'*A;
      rho1.data(:,k) = A(:);
   end
elseif ~isequal(rho1.dims{1},rho1.dims{2}); 
   error('Invalid state for partial trace');
else   
   perm = sparse(M*M,N*N);
   rest = 1:length(drho);
   rest(sel) = [];
   ilistsel = select(sel,drho); indsel = list2ind(ilistsel,drho);
   ilistrest = select(rest,drho); indrest = list2ind(ilistrest,drho);
   irest = (indrest-1)*N + indrest;
   m = 0;
   for k = indsel.'
      temp = (k-1)*N;
      for l = indsel.'
         m = m + 1;
         perm(m,irest+temp+l-1) = 1;
      end
   end
   rho1.dims = {drho(sel),drho(sel)};
   rho1.shape = [M,M]; 
   rho1.data = perm * rho1.data;
end
rho1 = qo(rho1);