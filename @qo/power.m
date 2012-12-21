function q = power(q1,q2)
% QO/POWER exponentiates quantum array objects elementwise
% q = power(q1,q2) raises q1 to power q2

%% version 0.11 26-Jan-1999
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
%   20-Dec-98   S.M. Tan   Initial release
%   26-Jan-99   S.M. Tan   Treat double matrix elements as sparse

[q1,q2] = qobinop(q1,q2);
if isa(q1,'qo') & isa(q2,'qo')
   q1 = struct(q1.qobase); q2 = struct(q2.qobase);
   if ~isequal(q1.dims,q2.dims)
      error('Incompatible matrix sizes');
   end   
   if isequal(q1.size,q2.size)
      q = q1;
      for k = 1:prod(q1.size); 
         temp = reshape(q1.data(:,k),q1.shape) .^ reshape(q2.data(:,k),q2.shape);
         q.data(:,k) = temp(:);
      end
   elseif isequal(prod(q1.size),1)
      q = q2;
      d = reshape(q1.data,q1.shape);
      for k = 1:prod(q2.size); 
         temp = d .^ reshape(q2.data(:,k),q2.shape);
         q.data(:,k) = temp(:); 
      end
   elseif isequal(prod(q2.size),1)
      q = q1;
      d = reshape(q2.data,q2.shape);
      for k = 1:prod(q1.size); 
         temp = reshape(q1.data(:,k),q1.shape) .^ d;
         q.data(:,k) = temp(:); 
      end
   else   
      error('Incompatible quantum objects.');
   end
elseif isa(q1,'qo') & isa(q2,'double')
   q1 = struct(q1.qobase);
   if isequal(prod(size(q2)),1)
      q = q1; q.data = q.data .^ sparse(q2);
   elseif isequal(q1.size,size(q2));
      q = q1; for k = 1:prod(q1.size); q.data(:,k) = q.data(:,k) .^ sparse(q2(k)); end   
   else
      error('Incompatible quantum object and double matrix.');
   end   
elseif isa(q2,'qo') & isa(q1,'double')
   q2 = struct(q2.qobase);
   if isequal(prod(size(q1)),1)
      q = q2; q.data = sparse(q1) .^ q.data;
   elseif isequal(q2.size,size(q1));
      q = q2; for k = 1:prod(q2.size); q.data(:,k) = sparse(q1(k)) .^ q.data(:,k); end   
   else
      error('Incompatible quantum object and double matrix.');
   end   
elseif isa(q1,'double') & isa(q2,'double')   
   q = scalar(q1 .^ q2);
else
   error('Incompatible operands.');
end
q = qo(q);
