function qobaseck(q)
% QOCHECK    Private routine which checks fields of a quantum base object for consistency

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
%    20-Dec-98    S.M. Tan		Initial version
if size(q.size,1)~=1,
   error('SIZE field must be a row vector.');
end
[m,n] = size(q.data);
if n~=prod(q.size)
   error('Number of columns in DATA is incompatible with SIZE.');
end
if ~iscell(q.dims)
   error('DIMS field must be a cell array');
end
if ~isequal(size(q.dims),[1,2])
   error('DIMS field must be 1 by 2 cell array');
end
if ~isequal(size(q.shape),[1,2]),
   error('SHAPE field must be 1 x 2 vector.');
end
if ~iscell(q.dims{1})
   if q.shape(1)~=prod(q.dims{1})
      error('SHAPE(1) is inconsistent with DIMS{1}.');
   end
   if q.shape(2)~=prod(q.dims{2})
      error('SHAPE(2) is inconsistent with DIMS{2}.');
   end
else
   if q.shape(1)~=prod(q.dims{1}{1})*prod(q.dims{1}{2})
      error('SHAPE(1) is inconsistent with DIMS{1}.');
   end
   if q.shape(2)~=prod(q.dims{2}{1})*prod(q.dims{2}{2})
      error('SHAPE(2) is inconsistent with DIMS{2}.');
   end
end
if m~=prod(q.shape)
   error('Number of rows in DATA is incompatible with SHAPE.');
end