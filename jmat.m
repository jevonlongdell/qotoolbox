function A = jmat(j,type)
% JMAT computes the angular momentum matrix
% jmat(j,type) where "type" can be '+','-','x','y' or 'z' or a 3-vector direction
% 'j' is the angular momentum quantum number (integer multiple of 1/2)

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
%   12-Sept-97   S.M. Tan   Implemented for Matlab 5

if fix(2*j) ~= 2*j | j<0
   error('j must be a non-negative integer or half-integer');
end
if nargin==1
   A = [qo(0.5*(jplus(j)+jplus(j)'));qo(-0.5*i*(jplus(j)-jplus(j)'));qo(jz(j))];
else
   if isa(type,'double')
      if prod(size(type))~=3
         error('Invalid type');
      end   
      type = type/norm(type);
      A = 0.5*(type(1)-i*type(2))*jplus(j)+0.5*(type(1)+i*type(2))*jplus(j)'+...
         type(3)*jz(j);
   else   
      switch type
      case '+'
         A = jplus(j);
      case '-'
         A = jplus(j)';
      case 'x'
         A = 0.5*(jplus(j)+jplus(j)');
      case 'y'
         A = -0.5*i*(jplus(j)-jplus(j)');
      case 'z'
         A = jz(j);
      otherwise
         error('Invalid type');
      end
   end
   A = qo(A);
end

function a = jplus(j)
m = j:-1:-j; N = length(m);
a = spdiags(sqrt(j*(j+1)-(m+1).*m)',1,N,N);

function a = jz(j)
m = j:-1:-j; N = length(m);
a = spdiags(m',0,N,N);
