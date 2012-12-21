function q = mpower(q1,q2)
% QO/MPOWER performs matrix exponentiation quantum array objects
% q = mpower(q1,q2) performs matrix exponentiation on q1 and q2

%% version 0.12 3-Feb-1999
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
%   20-Dec-98   S.M. Tan   	Initial release
%    3-Feb-99   M.J. Dunstan    Scalar quantum object ^ Double matrix

[q1,q2] = qobinop(q1,q2);
if isa(q1,'qo') & isa(q2,'qo')
   q1=struct(q1.qobase); q2=struct(q2.qobase);
   if isequal(q1.dims{2},q2.dims{1})
      error('Cannot exponentiate operator by an operator');
      q.dims={q1.dims{1},q2.dims{2}}; q.shape=[q1.shape(1) q2.shape(2)];
      if isequal(q1.size,q2.size)
         q.size = q1.size; q.data = sparse(prod(q.shape),prod(q.size));
         for k = 1:prod(q.size); 
	    temp = reshape(q1.data(:,k),q1.shape) ^ reshape(q2.data(:,k),q2.shape);
            q.data(:,k) = temp(:);
         end
      elseif isequal(prod(q1.size),1)
         q.size = q2.size; q.data = sparse(prod(q.shape),prod(q.size));
         temp1 = reshape(q1.data,q1.shape);
         for k = 1:prod(q.size); 
            temp = temp1 ^ reshape(q2.data(:,k),q2.shape);
            q.data(:,k) = temp(:);
         end   
      elseif isequal(prod(q2.size),1)
         q.size = q1.size; q.data = sparse(prod(q.shape),prod(q.size));
         temp2 = reshape(q2.data,q2.shape);
         for k = 1:prod(q.size); 
            temp = reshape(q1.data(:,k),q1.shape) ^ temp2;
            q.data(:,k) = temp(:);
         end   
      else error('Invalid array sizes.');
      end
   elseif isequal(q1.dims{2},q2.dims) % Super-operator and flattened operator
      error('Cannot exponentiate superoperator by an operator');
      q.dims = q1.dims{1}; q.shape = [prod(q.dims{1}),prod(q.dims{2})];
      if isequal(q1.size,q2.size)
         q.size = q1.size; q.data = sparse(prod(q.shape),prod(q.size));
         for k = 1:prod(q.size); q.data(:,k) = reshape(q1.data(:,k),q1.shape) ^ q2.data(:,k); end
      elseif isequal(prod(q1.size),1)
         q.size = q2.size; q.data = sparse(prod(q.shape),prod(q.size));
	 temp = reshape(q1.data,q1.shape);
         for k = 1:prod(q.size); q.data(:,k) = temp ^ q2.data(:,k); end
      elseif isequal(prod(q2.size),1)
         q.size = q1.size;  q.data = sparse(prod(q.shape),prod(q.size));
         for k = 1:prod(q.size); q.data(:,k) = reshape(q1.data(:,k),q1.shape) ^ q2.data(:); end
      else error('Invalid array sizes.');
      end
   else error('Incompatible matrix sizes.');   
   end
elseif isa(q1,'qo') & isa(q2,'double')   
   
   if isequal(prod(size(q2)),1)
      q = struct(q1.qobase);
      for k = 1:prod(q.size)
         temp = reshape(q.data(:,k),q.shape) ^ q2;
         q.data(:,k) = temp(:);
      end
      elseif isequal(size(q1),size(q2));
      q = struct(q1.qobase);
      for k = 1:prod(q.size)
         temp = reshape(q.data(:,k),q.shape) ^ q2(k);
         q.data(:,k) = temp(:);
      end   
   elseif isequal(prod(size(q1)),1)
      q = q1{ones(size(q2))} ^ q2;
   else
      error('Invalid combination of a quantum array object and a double matrix.');
   end
elseif isa(q2,'qo') & isa(q1,'double')   
    
   if isequal(prod(size(q1)),1)
      q = struct(q2.qobase);
      for k = 1:prod(q.size)
         temp = q1 ^ full( reshape(q.data(:,k),q.shape));
         q.data(:,k) = temp(:);
      end
   elseif isequal(size(q2),size(q1))
      q = struct(q2.qobase);
      for k = 1:prod(q.size) 
         temp = q1(k) ^ full( reshape(q.data(:,k),q.shape)); 
         q.data(:,k) = temp(:);
      end   
   elseif isequal(prod(size(q2)),1);
      q = q1 ^ q2{ones(size(q1))};
   else  
      error('Invalid combination of a double matrix and a quantum array object.');
   end
elseif isa(q1,'double') & isa(q2,'double')   
   q = scalar(q1 ^ q2);
else
   error('Incompatible operands.');
end
q = qo(q);
