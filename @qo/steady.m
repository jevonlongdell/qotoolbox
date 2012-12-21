function rhoss = steady(L)
% STEADY finds steady-state density matrix for a Liouvillian superoperator or an operator
% rhoss = steady(L) 
% This version uses the inverse power method

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
%      Apr-96   S.M. Tan   Initial implementation
%   18-Sep-97   S.M. Tan   Implemented for Matlab 5
%   11-Jan-98   S.M. Tan   Modified for new structure

tol = 1e-6;
maxiter = 20;

if ~isoper(L) & ~issuper(L)
   error('Steady states can only be found for operators or superoperators.');
end   
sflag = issuper(L);

rhoss.size = size(L); 
if sflag
   rhoss.dims = dims(L,1);
   rhoss.shape = [prod(rhoss.dims{1}),prod(rhoss.dims{2})];
else
   rhoss.dims = {dims(L,1),1};
   rhoss.shape = [prod(rhoss.dims{1}),1];
end

L = struct(L.qobase);
rhoss.data = sparse(prod(rhoss.shape),prod(rhoss.size));
for k = 1:prod(rhoss.size)
   temp = reshape(L.data(:,k),L.shape);
   n = length(temp);
   L1 = temp + eps*norm(temp,'inf')*speye(n);
   v = randn(n,1); 
   it = 0;
   while norm(temp*v,'inf') > tol & it<maxiter
      v = L1\v; v = v./norm(v,'inf');
      it = it + 1;
   end
   if it>=maxiter
      error(['Failed to find steady-state after ' int2str(maxiter) ' iterations.']);
   end
   rhoss.data(:,k) = v(:);
end   

% Normalize according to type of problem
if sflag
   trow = m2trace(speye(rhoss.shape(1)));
   for k = 1:prod(rhoss.size)
      rhoss.data(:,k)=rhoss.data(:,k)./(trow * rhoss.data(:,k));
   end
else
   for k = 1:prod(rhoss.size)
      rhoss.data(:,k)=rhoss.data(:,k)./norm(rhoss.data(:,k));
   end
end
rhoss = qo(rhoss);
