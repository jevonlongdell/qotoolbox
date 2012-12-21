
function S = spre(A,d)
% SPRE  Find superoperator associated with pre-multiplication by operator A.
% S = spre(A)   is such that spre(A)*rho is superoperator form of A*rho
% S = spre(A,d) handles case of A*rect where rect is not square. Superoperator
%               form of A*rect is spre(A,dims(rect,2))*rect
% SPRE operates member-wise on arrays

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
%      Jan-96   S.M. Tan   Initial implementation
%   18-Sep-97   S.M. Tan   Implemented for Matlab 5 
%   11-Jan-98   S.M. Tan   Modified for new structure

if ~isoper(A,'rect')
   error('Input is not an operator');
end   
A = struct(A.qobase);
S.size = A.size;
if nargin==1, d=A.dims{2}; end
S.dims = {{A.dims{1},d(:)},{A.dims{2},d(:)}};
S.shape = [prod(S.dims{1}{1})*prod(S.dims{1}{2}) prod(S.dims{2}{1})*prod(S.dims{2}{2})];
S.data = sparse(prod(S.shape),prod(S.size));
for k = 1:prod(S.size)
   temp = kron(speye(prod(d)),reshape(A.data(:,k),A.shape));
   S.data(:,k) = temp(:);
end
S = qo(S);
