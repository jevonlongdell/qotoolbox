function q1 = truncate(q,indices)
% QOBASE/TRUNCATE truncates the space of a quantum object "q" using the list of 
%  "indices". 
% e.g. if the vector space dimensions of q are [4,5,3], and we wish to truncate the
%  space by selecting directions 2:3, 1:5 and 1:2 in the subspaces, set 
%  indices = {2:3,1:5,1:2}. The output will have vector space dimensions [2,5,2]
% Alternatively, we can select a collection of individual directions. For example if
%  indices = [3,4,2; 1,4,2; 2,1,2; 4,1,3], we are selecting a four dimensional 
%  subspace spanned by directions given by the rows of indices.
%

%% version 0.15 25-Nov-2001
%
%    Copyright (C) 1996-2001  Sze M. Tan
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
%   25-Nov-2001   S.M. Tan   Initial implementation

if issuper(q) % superoperator
   [dq,perm] = truncate1(q.dims{1}{1},indices);
   q1.dims = {{dq,dq},{dq,dq}};
   q1.size = q.size;
   q1.shape = [prod(dq).^2,prod(dq).^2];
   q1.data = sparse(prod(q1.shape),prod(size(q)));
   lp = prod(q.dims{1}{1});
   perm1 = reshape(1:lp.^2,lp,lp);  % Calculate indices for density
   perm1 = perm1(perm,perm);        % matrix
   perm1 = perm1(:);
   for k = 1:prod(size(q))
      temp = reshape(q.data(:,k),q.shape);
      temp = temp(perm1,perm1);
      q1.data(:,k) = temp(:);
   end
elseif isoper(q) % Operator
   [dq,perm] = truncate1(q.dims{1},indices);
   q1.dims = {dq,dq}; q1.size = q.size; q1.shape = [prod(dq),prod(dq)];
   q1.data = sparse(prod(q1.shape),prod(size(q)));
   for k = 1:prod(size(q))
      temp = reshape(q.data(:,k),q.shape);
      temp = temp(perm,perm);
      q1.data(:,k) = temp(:);
   end
elseif isbra(q)
   [dq,perm] = truncate1(q.dims{2},indices);
   q1.dims = {q.dims{1},dq}; q1.size = q.size; q1.shape = [1,prod(dq)];
   q1.data = q.data(perm,:);
elseif isket(q)
   [dq,perm] = truncate1(q.dims{1},indices);
   q1.dims = {dq,q.dims{2}}; q1.size = q.size; q1.shape = [prod(dq),1];
   q1.data = q.data(perm,:);
else
   error('Invalid operands to truncate.');
end
q1 = qobase(q1);

function [dq,perm] = truncate1(dq1,indices);
if iscell(indices)
   % Check that there are the correct number of selection vectors
   nsub = length(dq1);
   if length(indices) ~= nsub
      error('Number of cells in indices must match number of subspaces');
   end
   % Check that the selection vectors are all in range
   nind = zeros(1,nsub);
   for k = 1:nsub
      if any(indices{k}<=0) | any(indices{k}>dq1(k))
         error(sprintf('Indices in cell %d must be in the range 1 to %d',k,dq1(k)));
      end
      nind(k) = length(indices{k});
   end
   % Make list of indices
   list = zeros(prod(nind),nsub);
   for k = nsub:-1:1
      ndx = indices{k};
      ndx = repmat(ndx(:)',[prod(nind(k+1:end)),1]);
      list(:,k) = repmat(ndx(:),[prod(nind(1:k-1)),1]);
   end
   perm = list2ind(list,dq1);
   dq = nind(:);
else   
   % We are already provided with the list of indices
   for k = 1:size(indices,2)
      if any(indices(:,k)<=0) | any(indices(:,k)>dq1(k))
         error(sprintf('Indices in column %d must be in the range 1 to %d',k,dq1(k)));
      end
   end   
   perm = list2ind(indices,dq1);
   dq = size(indices,1);
end
