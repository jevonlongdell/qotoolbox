function q1 = subsasgn(q,S,b)
% QOBASE/SUBSASGN performs subscript assignment for a quantum object
% q{m1,m2,...} = Q sets {m1,m2,...}'th array member of a quantum object
% q{m1,m2,...}(s) = Q returns a double matrix consisting of subscript s of q{m1,m2,...}
% {m1,m2,...}  may be omitted for a quantum object with one member

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
%   21-Dec-98    S.M. Tan	 Initial release

iq = reshape(1:prod(q.size),q.size); % Index matrix for q
if length(S)==1
   switch S(1).type
   case '{}'
      if ~isa(b,'qobase'), error('Require a qobase on rhs of assignment.'); end
      if isequal(prod(q.size),0)
         q.shape = b.shape; q.dims = b.dims;
      end
      if isequal(b.dims,q.dims)
         iq(S(1).subs{:}) = 0;
         fiq = find(iq);
         q1.shape = q.shape;
         q1.dims = q.dims;
         q1.size = size(iq);
         q1.data = sparse(prod(q.shape),prod(q1.size));
         q1.data(:,fiq) = q.data(:,iq(fiq));
         iq = zeros(size(iq));
         iq(S(1).subs{:}) = reshape(1:prod(b.size),b.size); 
         fiq = find(iq);
         q1.data(:,fiq) = b.data(:,iq(fiq));
      else
         error('Invalid subscript assignment to a qobase');
      end
   case '()'
      if ~isa(b,'double'), error('Need a double matrix to assign to a submatrix of a qobase'); end
      q1 = q;
      if ndims(b) > 2
         for k = 1:prod(q1.size)
            temp = reshape(q.data(:,k),q.shape);
            temp(S(1).subs{:}) = b(:,:,k);
            q1.data(:,k) = temp(:);
         end
      else
         for k = 1:prod(q1.size)
            temp = reshape(q.data(:,k),q.shape);
            temp(S(1).subs{:}) = b;
            q1.data(:,k) = temp(:);
         end
      end   
   end
elseif length(S)==2
   if S(1).type == '{}' & S(2).type == '()'
      if isequal(prod(q.size),0), error('Cannot assign to a submatrix of an empty qobase'); end
      if ~isa(b,'double'), error('Need a double matrix to assign to a submatrix of a qobase'); end
      iqtest = iq; iqtest(S(1).subs{:}) = 0;
      if prod(size(iqtest)) > prod(size(iq))
         indicies = num2cell(size(iqtest));
         iq(indicies{:}) = 0;
         fiq = find(iq);
         q1.shape = q.shape;
         q1.dims = q.dims;
         q1.size = size(iq);
         q1.data = sparse(prod(q.shape),prod(q1.size));
         q1.data(:,fiq) = q.data(:,iq(fiq));
      else
         q1 = q;
      end         
      iq = reshape(1:prod(q1.size),q1.size); % Index matrix for q1
      sel = iq(S(1).subs{:}); 
      if ndims(b) > 2
         for k = 1:length(sel)
            temp = reshape(q1.data(:,sel(k)),q1.shape);
            temp(S(2).subs{:}) = b(:,:,k);
            q1.data(:,sel(k)) = temp(:);
         end
      else
         for k = 1:length(sel)
            temp = reshape(q1.data(:,sel(k)),q1.shape);
            temp(S(2).subs{:}) = b;
            q1.data(:,sel(k)) = temp(:);
         end
      end   
   else
      error('Invalid subscript assignment')
   end
else
   error('Invalid subscript assignment')
end   
q1 = qobase(q1);