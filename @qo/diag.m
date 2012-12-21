function d = diag(q,k)
% QO/DIAG computes diagonal of a quantum object array
%  d = diag(q,k) produces k'th diagonal of q
% Result is a double array

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
%   9-Oct-97   S.M. Tan   Implemented for Matlab 5

q = struct(q.qobase);
if nargin<2, k = 0; end
if isequal(prod(q.size),1)
   d = diag(reshape(q.data,q.shape),k);
else
   d1 = diag(reshape(q.data(:,1),q.shape),k);
   d = zeros([length(d1) q.size]);
   for l = 1:prod(q.size)
      d(:,l) = diag(reshape(q.data(:,l),q.shape),k);
   end
end   

