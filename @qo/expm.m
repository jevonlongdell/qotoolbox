function B = expm(A)
% QO/EXPM Calculate operator or superoperator exponential
%  B = expm(A)

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
%   11-Jan-98   S.M. Tan   Implemented for Matlab 5
A = struct(A.qobase);
if isequal(A.dims{1},A.dims{2})
   B.dims = A.dims; B.size = A.size; B.shape = A.shape; 
   B.data = sparse(prod(B.shape),prod(B.size));
   for k = 1:prod(B.size)
      temp = expm(full(reshape(A.data(:,k),A.shape)));
      B.data(:,k) = temp(:);
   end
else
   error('Invalid operand for matrix exponential');
end
B = qo(B);