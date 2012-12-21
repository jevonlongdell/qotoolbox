function A = tensor(A1,varargin)
% QO/TENSOR computes tensor product of any number of vectors or operators.
% A = tensor(A1,A2,...) computes tensor product of arguments A1, A2,...
% Arguments can be arrays of the same size, or contain a single member.

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
%      Jan -96   S.M. Tan   Initial implementation
%   12-Sept-97   S.M. Tan   Implemented for Matlab 5 

if ~isa(A1,'qo') | issuper(A1)
   error('Invalid arguments.');
end
A = struct(A1.qobase); 
for k = 1:length(varargin)
   A1 = varargin{k};
   if ~isa(A1,'qo') | issuper(A1)
      error('Invalid arguments.');
   end
   A = kron2(A,struct(A1.qobase));
end
A = qo(A);

function q = kron2(q1,q2)
% QO/KRON2 Kronecker product
if isequal(q1.size,q2.size)
   q.dims={[q1.dims{1};q2.dims{1}],[q1.dims{2};q2.dims{2}]}; q.size=q1.size;
   q.shape=[prod(q.dims{1}) prod(q.dims{2})]; q.data=sparse(prod(q.shape),prod(q.size));
   for k = 1:prod(q.size);
      temp = kron(reshape(q1.data(:,k),q1.shape),reshape(q2.data(:,k),q2.shape));
      q.data(:,k) = temp(:);
   end
elseif isequal(prod(q1.size),1)
   q.dims={[q1.dims{1};q2.dims{1}],[q1.dims{2};q2.dims{2}]}; q.size=q2.size;
   q.shape=[prod(q.dims{1}) prod(q.dims{2})]; q.data=sparse(prod(q.shape),prod(q.size));
   temp1 = reshape(q1.data,q1.shape);
   for k = 1:prod(q.size);
      temp = kron(temp1,reshape(q2.data(:,k),q2.shape));
      q.data(:,k) = temp(:);
   end
elseif isequal(prod(q2.size),1)
   q.dims={[q1.dims{1};q2.dims{1}],[q1.dims{2};q2.dims{2}]}; q.size=q1.size;
   q.shape=[prod(q.dims{1}) prod(q.dims{2})]; q.data=sparse(prod(q.shape),prod(q.size));
   temp2 = reshape(q2.data,q2.shape);
   for k = 1:prod(q.size);
      temp = kron(reshape(q1.data(:,k),q1.shape),temp2);
      q.data(:,k) = temp(:);
   end
else error('Invalid matrix sizes in Kronecker product.');
end
