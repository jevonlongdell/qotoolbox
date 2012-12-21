function q1 = permute(q,order)
% QOBASE/PERMUTE permutes the dimensions of a quantum object in the specified order
% q1 = permute(q,order), where order is a permutation of 1:(no. of spaces)
%                        q can be a vector, an operator or a superoperator

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
%   10-Oct-1997   S.M. Tan   Implemented for Matlab 5
%   23-Nov-2001   S.M. Tan   Allow q to be a superoperator

if issuper(q) % superoperator
   [dq,perm] = permute1(q.dims{1}{1},order);
   q1 = q; q1.dims = {{dq(order),dq(order)},{dq(order),dq(order)}};
   lp = length(perm);
   perm1 = reshape(1:lp.^2,lp,lp);  % Calculate permutation of density
   perm1 = perm1(perm,perm);        % matrix indices
   perm1 = perm1(:);
   for k = 1:prod(size(q))
      temp = reshape(q.data(:,k),q.shape);
      temp = temp(perm1,perm1);
      q1.data(:,k) = temp(:);
   end
elseif isoper(q) % Operator
   [dq,perm] = permute1(q.dims{1},order);
   q1 = q; q1.dims = {dq(order),dq(order)}; q1.size = q.size; q1.shape = q.shape;
   for k = 1:prod(size(q))
      temp = reshape(q.data(:,k),q.shape);
      temp = temp(perm,perm);
      q1.data(:,k) = temp(:);
   end
elseif isequal(prod(q.dims{1}),1)
   [dq,perm] = permute1(q.dims{2},order);
   q1 = q; q1.dims = {q.dims{1},dq(order)}; q1.size = q.size; q1.shape = q.shape;
   q1.data = q.data(perm,:);
elseif isequal(prod(q.dims{2}),1)
   [dq,perm] = permute1(q.dims{1},order);
   q1 = q; q1.dims = {dq(order),q.dims{2}}; q1.size = q.size; q1.shape = q.shape;
   q1.data = q.data(perm,:);
else
   error('Invalid operands to permute.');
end
q1 = qobase(q1);

function [dq,perm] = permute1(dq1,order);
dq = dq1;
if ~isequal(sort(order(:).'),1:length(dq))
   error(['ORDER must be a permutation of 1:' int2str(length(dq))]);
end
perm = list2ind(select(order,dq),dq);
