function S = spost(A,d)
% SPOST  Find superoperator associated with post-multiplication by A.
% S = spost(A) is such that spost(A)*rho is superoperator form of rho*A
% S = spost(A,d) handles case of rect*A where rect is not square. Superoperator
%                form of rect*A is spost(A,dims(rect,1))*rect
% SPOST operates member-wise on arrays

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
if nargin==1, d=A.dims{1}; end
S.dims = {{d(:),A.dims{2}},{d(:),A.dims{1}}};
S.shape = [prod(S.dims{1}{1})*prod(S.dims{1}{2}) prod(S.dims{2}{1})*prod(S.dims{2}{2})];
S.data = sparse(prod(S.shape),prod(S.size));
for k = 1:prod(S.size)
   temp = kron(reshape(A.data(:,k),A.shape).',speye(prod(d)));
   S.data(:,k) = temp(:);
end
S = qo(S);
