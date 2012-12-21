function s = shape(q,k)
% QO/SHAPE returns shape of a member of a quantum object
% s = shape(q) returns a row vector giving the shape of the object "q"
%  regarded as a matrix.
% nrows = shape(q,1) gives number of rows in matrix representation of "q"
% ncols = shape(q,2) gives number of columns in matrix representation of "q"

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
%   10-Jan-98   S.M. Tan   Implemented for Matlab 5
%   20-Dec-98   S.M. Tan   Added second argument
s = q.shape;
if nargin>1,
   if k==1 | k==2
      s = s(k);
   else
      error('In shape(q,k), k must be 1 or 2.');
   end 
end