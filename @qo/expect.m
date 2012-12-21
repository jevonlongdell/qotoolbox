function result = expect(ops,states)
% QO/EXPECT calculates expectation values
% expect(ops,states) finds expected value of operator(s) "ops" in state(s) "states".
%  Returns a double matrix

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
%   18-Sep-97   S.M. Tan   Implemented for Matlab 5
%   11-Jan-98   S.M. Tan   Modified for new structure
if ~isa(ops,'qo') | ~isa(states,'qo')
   error('Arguments must be quantum objects.');
end

if isoper(ops)
   ops = struct(ops.qobase);
   if isoper(states) % Density matrix
      states = struct(states.qobase);
      if isequal(ops.size,states.size)
         result = zeros(ops.size);
         for k = 1:prod(ops.size)
            result(k) = m2trace(reshape(ops.data(:,k),ops.shape)) * states.data(:,k);
         end
      elseif isequal(prod(ops.size),1)
         result = reshape(m2trace(reshape(ops.data,ops.shape)) * states.data,states.size);
      elseif isequal(prod(states.size),1)
         result = zeros(ops.size);
         for k = 1:prod(ops.size)
            result(k) = m2trace(reshape(ops.data(:,k),ops.shape)) * states.data;
         end
      else
         error('Invalid array sizes in expect');
      end
   elseif isket(states) % State vectors
      states = struct(states.qobase);
      if isequal(ops.size,states.size)
         result = zeros(ops.size);
         for k = 1:prod(ops.size)
            result(k) = states.data(:,k)' * reshape(ops.data(:,k),ops.shape) * states.data(:,k);
         end
      elseif isequal(prod(ops.size),1)
         result = reshape(sum(conj(states.data).*(reshape(ops.data,ops.shape) * states.data)),states.size);
      elseif isequal(prod(states.size),1)
         result = zeros(ops.size);
         for k = 1:prod(ops.size)
            result(k) = states.data' * reshape(ops.data(:,k),ops.shape) * states.data;
         end
      else
         error('Invalid array sizes in expect.');
      end
   end
else
   error('Invalid operand types.');
end
