function b = basis(N,indx)
% BASIS creates a basis ket in an N dimensional Hilbert space
%  BASIS(N,indx) is the basis vector with a one in the component with index "indx"
%   if "indx" is a vector, result is an array of selected basis vectors
%  BASIS(N) is an array whose k'th member is the k'th basis vector

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
%   20-Dec-98   S.M. Tan   Implemented for Matlab 5

if prod(size(N))~=1 | N~=floor(N) | N(1)<1
   error('N must be an integer > 0');
end
if nargin<2, indx=1:N; end
if any(indx~=floor(indx)) | any(indx>N) | any(indx<1)
   error('Basis vector indicies must be integers in range 1..N')
end
b = qo;
for k = 1:length(indx)
   e = zeros(N,1); e(indx(k))=1;
   b{k} = qo(e);
end
