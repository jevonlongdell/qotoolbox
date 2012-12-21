function q1 = subsref(q,S)
% QOBASE/SUBSREF performs subscripting for a quantum base object
% q{m1,m2,...} returns {m1,m2,...}'th array member of a quantum object
% q{m1,m2,...}(s) returns a double matrix consisting of subscript s of q{m1,m2,...}
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
%   
%    21-Dec-98    S.M. Tan	 Initial release

q1.dims = q.dims;
iq = reshape(1:prod(q.size),q.size); % Index matrix for q
index = 1;
switch S(index).type
case '.'
   switch lower(S(index).subs)
   case 'dims'
      q1 = q.dims; return;
   case 'size'
      q1 = q.size; return;
   case 'shape'
      q1 = q.shape; return;
   case 'data'
      q1 = q.data; return;
   otherwise
      error('Unknown field in quantum object');
   end      
case '{}'
   isel = iq(S(index).subs{:}); % Selected indicies (data columns)
   q1.size = size(isel);
   q1.shape = q.shape;
   q1.data = q.data(:,isel(:));
   index = index+1;
otherwise
   q1 = q;
end
if index > length(S),
   q1 = qobase(q1);
   return
else % Return a double matrix
   switch S(index).type
   case '()'
      psz = prod(q1.size);
      if psz == 1
         q1 = reshape(q1.data,q1.shape);
         q1 = q1(S(index).subs{:});
      else
         temp1 = zeros(q1.shape); temp1 = temp1(S(index).subs{:});
         temp = zeros([size(temp1),q1.size]);
         for k = 1:psz
            temp1 = reshape(q1.data(:,k),q1.shape);
            temp(:,:,k) = temp1(S(index).subs{:});
         end
         q1 = temp;
      end
   otherwise
      error('Invalid subscripting operation.');
   end
   if index < length(S)
      error('Invalid subscripting operation.');
   end
end
