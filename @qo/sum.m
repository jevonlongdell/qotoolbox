function q = sum(q1,indx)
% QO/SUM computes the sum of array members in a quantum array object
%   For row or column arrays, SUM(Q) is the sum of the members of X. For
%    rectangular arrays, SUM(Q) is a row array with the sum over each
%    column. For N-D arrays, SUM(Q) operates along the first non-singleton 
%    dimension.
%   SUM(Q,DIM) sums along the dimension DIM. 

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
%   06-Jan-99   S.M. Tan   Initial implementation
q1 = struct(q1.qobase);
sq1 = q1.size;
if nargin == 1,
   indx = find(sq1~=1);
   if isempty(indx)
      q = qo(q1);
      return
   end
end
indx = indx(1);
sq = [sq1(1:indx-1) 1 sq1(indx+1:end)];
q.dims = q1.dims; q.size = sq; q.shape = q1.shape;
q.data = sparse(prod(q.shape),prod(q.size));
nresult = prod(sq); l0 = 1;
nskip = prod(sq1(1:indx-1));
for k = 1:nresult
   l = l0;
   temp = reshape(q1.data(:,l),q.shape);
   for m = 2:sq1(indx)
      l = l + nskip;
      temp = temp + reshape(q1.data(:,l),q.shape);
   end
   q.data(:,k) = temp(:);
   l0 = l0 + 1;
   if rem(k,nskip)==0, 
      l0 = l0 + nskip*(sq1(indx)-1);
   end
end
q = qo(q);
