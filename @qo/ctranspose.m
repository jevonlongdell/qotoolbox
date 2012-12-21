function q = ctranspose(q1)
% QO/CTRANSPOSE implements conjugate transpose for quantum objects
% q = ctranspose(q1)
% N.B. This takes Hermitian conjugate of array members, not of the array!

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
%   18-Sept-97   S.M. Tan   Implemented for Matlab 5
%    8-Jan -98   S.M. Tan   Modified for new structure
q1 = struct(q1.qobase); q = q1;
q.dims = {q1.dims{2},q1.dims{1}};
q.shape = [q.shape(2) q.shape(1)];

for k = 1:prod(q.size)
   temp = reshape(q1.data(:,k),q1.shape)';
   q.data(:,k) = temp(:);
end
q = qo(q);